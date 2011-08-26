// -*- Mode: C++; tab-width: 2; -*-
// vi: set ts=2:

//follows amw EF form
//burial preference included and residue positions based on Ca for glycine

#include <ios> // needed for cout
#include <iostream>
#include <string>
#include <map>
#include <iomanip> //this allows manipulation of the output behaviour (from cout)

// the BALL kernel classes
#include <BALL/KERNEL/residue.h>
#include <BALL/KERNEL/system.h>
#include <BALL/MATHS/analyticalGeometry.h>
#include <BALL/DATATYPE/string.h>
// for calculating the SAS area numerically
#include <BALL/STRUCTURE/numericalSAS.h>
#include <BALL/STRUCTURE/defaultProcessors.h>
#include <BALL/STRUCTURE/residueChecker.h>
#include <BALL/STRUCTURE/fragmentDB.h>
// reading and writing of PDB files
#include <BALL/FORMAT/PDBFile.h>

#include <stdio.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_eigen.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_statistics.h>
#include <fstream>
#include <utility>
#include "blitz/array.h"

// this class will allow me to use a hash-like object later
class NumberName
{
public:
	//typedef std::pair<std::string,int>; //needed for some versions of VC++
	void insert(const std::string& name, int value) { theMap[name] = value; }

	int find(const std::string& name) {
		std::map<std::string,int>::iterator it = theMap.find(name);
		if (it != theMap.end())
			return it->second;
		else
			return -1;
	}

private:
	std::map<std::string,int> theMap;
};

// we use the BALL namespace and the std namespace (for cout and endl)
using namespace BALL;
using namespace std;
using namespace blitz;
using std::string;
using std::map;

//user modifiable
int native_chain_length;
int surf_decoys;
double well_1_end,well_2_end;
int seg_res[2000];
double gammas1_well_1_f[20][20];
double gammas1_well_2_f[20][20];
double gammas2_well_1_f[20][20];
double gammas2_well_2_f[20][20];
double gammas3_1[20];
double gammas3_2[20];
double gammas3_3[20];

Array<double,1> gammas1_well_1_f_list(210);
Array<double,1> gammas1_well_2_f_list(210);
Array<double,1> gammas2_well_1_f_list(210);
Array<double,1> gammas2_well_2_f_list(210);

double residue_percent_sas[2000]={0};
int i=1;
//for random number shuffling
int seed;
double rij_,rand_rij_;
float decoy_mean_fold,decoy_std_fold; //mean and sqrt(var) over native structures
int restype1;
double well1_distance_bound=6.5;
double well2_distance_bound=9.5;

int main(int argc, char *argv[])
{
//added to control digits output after decimal (setiosflags ( ios::fixed );)
std::cout << std::fixed << std::setprecision(3);

/////////////////////////
// Constants defined here
NumberName residues;
residues.insert ( "ALA",0);
residues.insert ( "ARG",1);
residues.insert ( "ASN",2);
residues.insert ( "ASP",3);
residues.insert ( "CYS",4);
residues.insert ( "GLN",5);
residues.insert ( "GLU",6);
residues.insert ( "GLY",7);
residues.insert ( "HIS",8);
residues.insert ( "ILE",9);
residues.insert ( "LEU",10);
residues.insert ( "LYS",11);
residues.insert ( "MET",12);
residues.insert ( "PHE",13);
residues.insert ( "PRO",14);
residues.insert ( "SER",15);
residues.insert ( "THR",16);
residues.insert ( "TRP",17);
residues.insert ( "TYR",18);
residues.insert ( "VAL",19);

//////////////////////////////////////////////////////////
//Open the file with contact potentials and read them in..
ifstream gammas1_file_f;

gammas1_file_f.open(argv[i]); i++;
if(!gammas1_file_f) { cout << "Unable to open file"; exit(0); }
int j=0,k=0,well=1; float gamma=0; int list1_cnt=0; int list2_cnt=0;
while (gammas1_file_f >> gamma) {
//cout << gamma << endl;
	if (well == 1) { gammas1_well_1_f[j][k] = gamma; gammas1_well_1_f[k][j] = gamma; gammas1_well_1_f_list(list1_cnt) = gamma; list1_cnt++; }
	if (well == 2) { gammas1_well_2_f[j][k] = gamma; gammas1_well_2_f[k][j] = gamma; gammas1_well_2_f_list(list2_cnt) = gamma; list2_cnt++; }
	if (j==k) {j++;k=0;} else { k++; }
	if ((j==20)) { well=2; j=0; k=0; }
}
gammas1_file_f.close();

//////////////////////////////////////////////////////////
//Open the file with contact potentials and read them in..
ifstream gammas2_file_f;

gammas2_file_f.open(argv[i]); i++;
if(!gammas2_file_f) { cout << "Unable to open file"; exit(0); }
j=0; k=0; well=1; gamma=0; list1_cnt=0; list2_cnt=0;
while (gammas2_file_f >> gamma) {
	if (well == 1) { gammas2_well_1_f[j][k] = gamma; gammas2_well_1_f[k][j] = gamma; gammas2_well_1_f_list(list1_cnt) = gamma; list1_cnt++; }
	if (well == 2) { gammas2_well_2_f[j][k] = gamma; gammas2_well_2_f[k][j] = gamma; gammas2_well_2_f_list(list2_cnt) = gamma; list2_cnt++; }
	if (j==k) {j++;k=0;} else { k++; }
	if ((j==20)) { well=2; j=0;k=0; }
}
gammas2_file_f.close();

//////////////////////////////////////////////////////////
//Open the file with contact potentials and read them in..
ifstream gammas3_file;


gammas3_file.open(argv[i]); i++;
if(!gammas3_file) { cout << "Unable to open file"; exit(0); }
j=0; k=0; gamma=0;
while (gammas3_file >> gamma) {
  if (j%3==0) { gammas3_1[k] = gamma; }
  if (j%3==1) { gammas3_2[k] = gamma; }
  if (j%3==2) { gammas3_3[k] = gamma; k++; }
  j++;
}
gammas3_file.close();

//////////////////////////////////////////////////////////
//Open the file with the sas info for the native chain
j=0; double decoy_sas=0; double decoy_sas_native_info[2000];
for(int x1=0;x1<2000;x1++) { decoy_sas_native_info[x1] = 0; }
ifstream decoy_sas_native_info_file;


decoy_sas_native_info_file.open(argv[i]); i++;
if(!decoy_sas_native_info_file) { cout << "Unable to open decoy sas info filename list file"; exit(0); }
while (decoy_sas_native_info_file >> decoy_sas) {
	decoy_sas_native_info[j]=decoy_sas;
	residue_percent_sas[j]=decoy_sas;
	decoy_sas = 0;
	j++;
}
decoy_sas_native_info_file.close();

/////////////////////////////////////
//prepare the random number generator
seed = time(0);
srand(seed);




surf_decoys = atoi(argv[i]); i++;
// create a PDBFile object
PDBFile infile(argv[i]); i++;


// create a system
System S;
infile >> S; // read the contents of bpti.pdb into the system 
infile.close(); // close the file
native_chain_length = S.countResidues();

map<int, int> cont_to_type;
const int ARRSIZE1 = native_chain_length;
Array<int,2> native_contact_map(ARRSIZE1,ARRSIZE1);
native_contact_map=0;
Array<int,2> res1_res2_to_cont(ARRSIZE1,ARRSIZE1);
res1_res2_to_cont=0;
int native_contact_cnt=0;


/////////////////////////////////////////////////////////////////////////////////
// Here, I will read in the sequence residue id's to a vector..
int seg_res_count=0;
ResidueIterator pull_ids_it;
for (pull_ids_it = S.beginResidue(); pull_ids_it != S.endResidue(); ++pull_ids_it) {
		seg_res[seg_res_count]=residues.find(pull_ids_it->getName());
		++seg_res_count;
}

Array<double,2> rij_cb_cb(ARRSIZE1,ARRSIZE1);
Array<double,2> rij_ca_cb(ARRSIZE1,ARRSIZE1);
Array<double,2> rij_cb_ca(ARRSIZE1,ARRSIZE1);
Array<double,2> rij_ca_ca(ARRSIZE1,ARRSIZE1);

int res_1_flag_ca,res_1_flag_cb,res_1_flag_c,res_1_flag_n;
int res_2_flag_ca,res_2_flag_cb,res_2_flag_c,res_2_flag_n;
int res_1_position=0,res_2_position=0;
ResidueIterator res_it_1;
for (res_it_1 = S.beginResidue(); res_it_1 != S.endResidue(); ++res_it_1) {
	Vector3 ca1_pos,cb1_pos,gly_c1_pos,gly_n1_pos,catocb1,anchor1_pos;
	Vector3 ca2_pos,cb2_pos,gly_c2_pos,gly_n2_pos,catocb2,ca1tocb2,ca2tocb1,anchor2_pos;
	res_1_flag_ca=0; res_1_flag_cb=0; res_1_flag_c=0; res_1_flag_n=0;
	if (res_it_1->getName() == "GLY") {
		Vector3 gly_c1_pos,gly_n1_pos,bb1toca1,normal_to_plane1;
		AtomIterator atom_it_res_1;
		for (atom_it_res_1 = res_it_1->beginAtom(); atom_it_res_1 != res_it_1->endAtom(); ++atom_it_res_1) {
			if (atom_it_res_1->getName()=="CA") { ca1_pos = atom_it_res_1->getPosition(); res_1_flag_ca=1; }
			if (atom_it_res_1->getName()=="C") { gly_c1_pos = atom_it_res_1->getPosition(); res_1_flag_c=1; }
			if (atom_it_res_1->getName()=="N") { gly_n1_pos = atom_it_res_1->getPosition(); res_1_flag_n=1; }
		}
		if ((res_1_flag_ca==0)||(res_1_flag_c==0)||(res_1_flag_n==0)) { cout << "Atom (ca,c,or n) missing in a Glycine residue\tPosition: " << res_1_position << endl; exit(0); }
		bb1toca1 = (ca1_pos-((gly_c1_pos+gly_n1_pos)/2));
		//calculate the vector normal to the plane formed by C,N,CA
		Plane3* plane1 = new Plane3(ca1_pos,gly_c1_pos,gly_n1_pos);
		plane1->normalize();
		normal_to_plane1 = plane1->n;
		cb1_pos = (((gly_c1_pos+gly_n1_pos)/2)+(bb1toca1.normalize()*1.7617)-(normal_to_plane1*1.23135));
		anchor1_pos = ca1_pos;
	}
	else {
		AtomIterator atom_it_res_1b;
		for (atom_it_res_1b = res_it_1->beginAtom(); atom_it_res_1b != res_it_1->endAtom(); ++atom_it_res_1b) {
			if (atom_it_res_1b->getName()=="CA") { ca1_pos = atom_it_res_1b->getPosition(); res_1_flag_ca=1; }
			if (atom_it_res_1b->getName()=="CB") { cb1_pos = atom_it_res_1b->getPosition(); res_1_flag_cb=1; }
		}
		if ((res_1_flag_ca==0)||(res_1_flag_cb==0)) { cout << "Atom (ca or cb) missing in a non-Glycine residue\tPosition: " << res_1_position << endl; exit(0); }
		anchor1_pos = cb1_pos;
	} // end for loop over atom_it_1
	catocb1 = (cb1_pos-ca1_pos);

	ResidueIterator res_it_2;
	res_2_position = 0;
  for (res_it_2 = S.beginResidue(); res_it_2 != S.endResidue(); ++res_it_2) {
		if (res_1_position < (res_2_position-1)) {
			if (res_it_2->getName() == "GLY") {
				Vector3 gly_c2_pos,gly_n2_pos,bb2toca2,normal_to_plane2;
				res_2_flag_ca=0; res_2_flag_cb=0; res_2_flag_c=0; res_2_flag_n=0;
				AtomIterator atom_it_res_2;
				for (atom_it_res_2 = res_it_2->beginAtom(); atom_it_res_2 != res_it_2->endAtom(); ++atom_it_res_2) {
					if (atom_it_res_2->getName()=="CA") { ca2_pos = atom_it_res_2->getPosition(); res_2_flag_ca=1; }
					if (atom_it_res_2->getName()=="C") { gly_c2_pos = atom_it_res_2->getPosition(); res_2_flag_c=1; }
					if (atom_it_res_2->getName()=="N") { gly_n2_pos = atom_it_res_2->getPosition(); res_2_flag_n=1; }
				}
				if ((res_2_flag_ca==0)||(res_2_flag_c==0)||(res_2_flag_n==0)) { cout << "Atom (ca,c,or n) missing in a Glycine residue\tPosition: " << res_2_position << endl; exit(0); }
				bb2toca2 = (ca2_pos-((gly_c2_pos+gly_n2_pos)/2));
				//calculate the vector normal to the plane formed by C,N,CA
				Plane3* plane2 = new Plane3(ca2_pos,gly_c2_pos,gly_n2_pos);
				plane2->normalize();
				normal_to_plane2 = plane2->n;
				cb2_pos = (((gly_c2_pos+gly_n2_pos)/2)+(bb2toca2.normalize()*1.7617)-(normal_to_plane2*1.23135));
				anchor2_pos = ca2_pos;
			}
			else {
				AtomIterator atom_it_res_2b;
				for (atom_it_res_2b = res_it_2->beginAtom(); atom_it_res_2b != res_it_2->endAtom(); ++atom_it_res_2b) {
					if (atom_it_res_2b->getName()=="CA") { ca2_pos = atom_it_res_2b->getPosition(); res_2_flag_ca=1; }
					if (atom_it_res_2b->getName()=="CB") { cb2_pos = atom_it_res_2b->getPosition(); res_2_flag_cb=1; }
				}
				if ((res_2_flag_ca==0)||(res_2_flag_cb==0)) { cout << "Atom (ca or cb) missing in a non-Glycine residue\tPosition: " << res_2_position << endl; exit(0); }
				anchor2_pos = cb2_pos;
			} // end for loop over atom_it_1
			catocb2 = (cb2_pos-ca2_pos);

			//Here,I gather the relevant angles, etc.
			Angle angle1,angle2;
			ca1tocb2 = cb2_pos-ca1_pos;
			ca2tocb1 = cb1_pos-ca2_pos;
			GetAngle(ca1tocb2,catocb1,angle1);
			GetAngle(ca2tocb1,catocb2,angle2);

			double distance_atom_1_2 = GetDistance(anchor1_pos,anchor2_pos);

			if ( distance_atom_1_2 < well1_distance_bound ) { 
				cont_to_type[native_contact_cnt]=1;
				res1_res2_to_cont(res_1_position,res_2_position)=native_contact_cnt;
				native_contact_map(res_1_position,res_2_position)++;
				native_contact_cnt++; 
			} // end if loop to force contact within 5 angstroms..

			if (( distance_atom_1_2 < well2_distance_bound )&&( distance_atom_1_2 >= well1_distance_bound)) { 
				if ( (residue_percent_sas[res_1_position]>0.05)&&(residue_percent_sas[res_2_position]>0.05)) {
					cont_to_type[native_contact_cnt]=3;
					res1_res2_to_cont(res_1_position,res_2_position)=native_contact_cnt;
					native_contact_map(res_1_position,res_2_position)++;
					native_contact_cnt++; 
				}
				else {
					cont_to_type[native_contact_cnt]=2;
					res1_res2_to_cont(res_1_position,res_2_position)=native_contact_cnt;
					native_contact_map(res_1_position,res_2_position)++;
					native_contact_cnt++; 
				}
			} // end if loop to force contact between 5 and 12 angstroms..

		rij_cb_cb(res_1_position,res_2_position) = GetDistance(cb1_pos,cb2_pos);
    rij_ca_cb(res_1_position,res_2_position) = GetDistance(ca1_pos,cb2_pos);
    rij_cb_ca(res_1_position,res_2_position) = GetDistance(cb1_pos,ca2_pos);
    rij_ca_ca(res_1_position,res_2_position) = GetDistance(ca1_pos,ca2_pos);
    rij_cb_cb(res_2_position,res_1_position) = GetDistance(cb1_pos,cb2_pos);
    rij_ca_cb(res_2_position,res_1_position) = GetDistance(cb1_pos,ca2_pos);
    rij_cb_ca(res_2_position,res_1_position) = GetDistance(ca1_pos,cb2_pos);
    rij_ca_ca(res_2_position,res_1_position) = GetDistance(ca1_pos,ca2_pos);

		} //end if res_1<(res_2-1)
		++res_2_position;
	} //end res_it_2
	++res_1_position;
} //end res_it_1

//determine pi (density values for native chain)
//calculate pi (density) and S1,S2,S3 for burial preference
Array<double,1> S1_native(ARRSIZE1); Array<double,1> S2_native(ARRSIZE1); Array<double,1> S3_native(ARRSIZE1);
double pi[2000];
double well_1_start=4.5;
double well_1_end=6.5;
double well_2_start=6.5;
double well_2_end=9.5;
for (j=0; j<native_chain_length; j++) {
  for (k=0; k<native_chain_length; k++) {
    if (abs(j-k)>12) {
      if ((seg_res[j]!=residues.find("GLY"))&&(seg_res[k]!=residues.find("GLY"))) {
        pi[j] += ( 0.25 * (1+tanh(5*(rij_cb_cb(j,k)-well_1_start))) * (1+tanh(5*(well_1_end-rij_cb_cb(j,k)))) );
      }
      else if ((seg_res[j]==residues.find("GLY"))&&(seg_res[k]!=residues.find("GLY"))) {
        pi[j] += ( 0.25 * (1+tanh(5*(rij_ca_cb(j,k)-well_1_start))) * (1+tanh(5*(well_1_end-rij_ca_cb(j,k)))) );
      }
      else if ((seg_res[j]!=residues.find("GLY"))&&(seg_res[k]==residues.find("GLY"))) {
        pi[j] += ( 0.25 * (1+tanh(5*(rij_cb_ca(j,k)-well_1_start))) * (1+tanh(5*(well_1_end-rij_cb_ca(j,k)))) );
      }
      else {
        pi[j] += ( 0.25 * (1+tanh(5*(rij_ca_ca(j,k)-well_1_start))) * (1+tanh(5*(well_1_end-rij_ca_ca(j,k)))) );
      }
    }
  }
  S1_native(j) = ( tanh(5*(pi[j]-0)) + tanh(5*(3-pi[j])) );
  S2_native(j) = ( tanh(5*(pi[j]-3)) + tanh(5*(6-pi[j])) );
  S3_native(j) = ( tanh(5*(pi[j]-6)) + tanh(5*(9-pi[j])) );
}

double native_surface_energy_fold=0;
Array<double,1> native_surface_energy_fold_rand_pi_rij_res(surf_decoys);
native_surface_energy_fold_rand_pi_rij_res=0;

double native_surface_energy_fold_burial=0;
Array<double,1> native_surface_energy_fold_burial_rand_pi_res(surf_decoys);
native_surface_energy_fold_burial_rand_pi_res=0;

double native_surface_energy_fold_perres_burial=0;
Array<double,1> native_surface_energy_fold_perres_burial_rand_pi_res(surf_decoys);
native_surface_energy_fold_perres_burial_rand_pi_res=0;

Array<int,2> rand_res_perres(ARRSIZE1,surf_decoys);
Array<int,2> rand_res_paira(native_contact_cnt,surf_decoys);
Array<int,2> rand_res_pairb(native_contact_cnt,surf_decoys);
Array<int,2> rand_pos_pi(ARRSIZE1,surf_decoys);
int contact_cnt2=0;
for (int pos1=0;pos1<native_chain_length;pos1+=1) {
  for (restype1=0;restype1<surf_decoys;restype1+=1) {
		rand_pos_pi(pos1,restype1) = (int) (( (double)rand() / ((double) (RAND_MAX)+1))*native_chain_length);
		rand_res_perres(pos1,restype1) = seg_res[ (int) (( (double)rand() / ((double) (RAND_MAX)+1))*native_chain_length) ];
	}
  for (int pos2=0;pos2<native_chain_length;pos2+=1) {
		if (native_contact_map(pos1,pos2)>0) {
    	for (restype1=0;restype1<surf_decoys;restype1+=1) {
      	rand_res_paira(contact_cnt2,restype1) = seg_res[ (int) (( (double)rand() / ((double) (RAND_MAX)+1))*native_chain_length) ];
      	rand_res_pairb(contact_cnt2,restype1) = seg_res[ (int) (( (double)rand() / ((double) (RAND_MAX)+1))*native_chain_length) ];
    	}
			contact_cnt2++;
		}
  }
}

int contact_cnt3=0;
res_1_position=0,res_2_position=0;
ResidueIterator res_it_3;
for (res_it_3 = S.beginResidue(); res_it_3 != S.endResidue(); ++res_it_3) {

	native_surface_energy_fold_perres_burial = ((gammas3_1[seg_res[res_1_position]]*S1_native(res_1_position)+gammas3_2[seg_res[res_1_position]]*S2_native(res_1_position)+gammas3_3[seg_res[res_1_position]]*S3_native(res_1_position)));
	//get decoy perres burial terms
	for (restype1=0;restype1<surf_decoys;restype1+=1) {
		//assign randomized burial terms based on randomly chosen densities (from native structure)
		native_surface_energy_fold_perres_burial_rand_pi_res(restype1) = ((gammas3_1[rand_res_perres(res_1_position,restype1)]*S1_native(rand_pos_pi(res_1_position,restype1))+gammas3_2[rand_res_perres(res_1_position,restype1)]*S2_native(rand_pos_pi(res_1_position,restype1))+gammas3_3[rand_res_perres(res_1_position,restype1)]*S3_native(rand_pos_pi(res_1_position,restype1))));
	}

	decoy_mean_fold = gsl_stats_mean(native_surface_energy_fold_perres_burial_rand_pi_res.data(),1,surf_decoys);
	decoy_std_fold = gsl_stats_sd(native_surface_energy_fold_perres_burial_rand_pi_res.data(),1,surf_decoys);
	cout << "PERRES_BURIAL\t" << res_1_position << "\t" << native_surface_energy_fold_perres_burial << "\t" << decoy_mean_fold << "\t" << ((native_surface_energy_fold_perres_burial-decoy_mean_fold)/decoy_std_fold) << endl;

	ResidueIterator res_it_4;
	res_2_position = res_1_position;
	for (res_it_4 = res_it_3; res_it_4 != S.endResidue(); ++res_it_4) {
		if (native_contact_map(res_1_position,res_2_position)>0) {
			if (res_1_position < (res_2_position-1)) {
				//get native burial
				native_surface_energy_fold_burial = ((gammas3_1[seg_res[res_1_position]]*S1_native(res_1_position)+gammas3_2[seg_res[res_1_position]]*S2_native(res_1_position)+gammas3_3[seg_res[res_1_position]]*S3_native(res_1_position)));
				native_surface_energy_fold_burial += ((gammas3_1[seg_res[res_2_position]]*S1_native(res_2_position)+gammas3_2[seg_res[res_2_position]]*S2_native(res_2_position)+gammas3_3[seg_res[res_2_position]]*S3_native(res_2_position)));

				//determine which distance to use (based on whether one or both of the residues is a GLY)
				if ((seg_res[res_1_position]!=residues.find("GLY"))&&(seg_res[res_2_position]!=residues.find("GLY"))) {
				  rij_ = rij_cb_cb(res_1_position,res_2_position); 
				}
				else if ((seg_res[res_1_position]==residues.find("GLY"))&&(seg_res[res_2_position]!=residues.find("GLY"))) {
				  rij_ = rij_ca_cb(res_1_position,res_2_position); 
				}
				else if ((seg_res[res_1_position]!=residues.find("GLY"))&&(seg_res[res_2_position]==residues.find("GLY"))) {
				  rij_ = rij_cb_ca(res_1_position,res_2_position); 
				}
				else {
				  rij_ = rij_ca_ca(res_1_position,res_2_position); 
				}

				//get native energy for contact - DIRECT (well1)
				native_surface_energy_fold = ( 0.25 * (1+tanh(7*(rij_-well_1_start))) * (1+tanh(7*(well_1_end-rij_))) * gammas1_well_1_f[seg_res[res_1_position]][seg_res[res_2_position]] );

				//get native energy for contact - DIRECT and WATER (well2)
				double water_fraction = ( 0.5 * (1-tanh(5*(pi[res_1_position]-2.6))) * 0.5 * (1-tanh(5*(pi[res_2_position]-2.6))) );
				double buried_fraction = (1-water_fraction);
				native_surface_energy_fold += ( 0.25 * (1+tanh(5*(rij_-well_2_start))) * (1+tanh(5*(well_2_end-rij_))) * (water_fraction*gammas2_well_2_f[seg_res[res_1_position]][seg_res[res_2_position]] + buried_fraction*gammas1_well_2_f[seg_res[res_1_position]][seg_res[res_2_position]] ) );

				//get decoy energies for contact and burial
				for (restype1=0;restype1<surf_decoys;restype1+=1) {
					//get decoy burial terms
					native_surface_energy_fold_burial_rand_pi_res(restype1) = ((gammas3_1[rand_res_paira(contact_cnt3,restype1)]*S1_native(rand_pos_pi(res_1_position,restype1))+gammas3_2[rand_res_paira(contact_cnt3,restype1)]*S2_native(rand_pos_pi(res_1_position,restype1))+gammas3_3[rand_res_paira(contact_cnt3,restype1)]*S3_native(rand_pos_pi(res_1_position,restype1))));
					native_surface_energy_fold_burial_rand_pi_res(restype1) += ((gammas3_1[rand_res_pairb(contact_cnt3,restype1)]*S1_native(rand_pos_pi(res_2_position,restype1))+gammas3_2[rand_res_pairb(contact_cnt3,restype1)]*S2_native(rand_pos_pi(res_2_position,restype1))+gammas3_3[rand_res_pairb(contact_cnt3,restype1)]*S3_native(rand_pos_pi(res_2_position,restype1))));

					//get random rij term (contact distance)
					int rand_res1 = seg_res[ (int) (( (double)rand() / ((double) (RAND_MAX)+1))*native_chain_length) ];
					int rand_res2 = seg_res[ (int) (( (double)rand() / ((double) (RAND_MAX)+1))*native_chain_length) ];
					while (native_contact_map(rand_res1,rand_res2)!=1) {
						rand_res1 = seg_res[ (int) (( (double)rand() / ((double) (RAND_MAX)+1))*native_chain_length) ];
						rand_res2 = seg_res[ (int) (( (double)rand() / ((double) (RAND_MAX)+1))*native_chain_length) ];
					}
					double rand_rij_cb_cb=rij_cb_cb(rand_res1,rand_res2);
					double rand_rij_ca_cb=rij_ca_cb(rand_res1,rand_res2);
					double rand_rij_cb_ca=rij_cb_ca(rand_res1,rand_res2);
					double rand_rij_ca_ca=rij_ca_ca(rand_res1,rand_res2);

					//determine which distance to use (based on whether one or both of the residues is a GLY)
					if ((rand_res_paira(contact_cnt3,restype1)!=residues.find("GLY"))&&(rand_res_pairb(contact_cnt3,restype1)!=residues.find("GLY"))) {
					  rand_rij_ = rand_rij_cb_cb;
					}
					else if ((rand_res_paira(contact_cnt3,restype1)==residues.find("GLY"))&&(rand_res_pairb(contact_cnt3,restype1)!=residues.find("GLY"))) {
					  rand_rij_ = rand_rij_ca_cb;
					}
					else if ((rand_res_paira(contact_cnt3,restype1)!=residues.find("GLY"))&&(rand_res_pairb(contact_cnt3,restype1)==residues.find("GLY"))) {
					  rand_rij_ = rand_rij_cb_ca;
					}
					else {
					  rand_rij_ = rand_rij_ca_ca;
					}

					//get decoy energies for contact - DIRECT (well1)
					native_surface_energy_fold_rand_pi_rij_res(restype1) = ( 0.25 * (1+tanh(7*(rand_rij_-well_1_start))) * (1+tanh(7*(well_1_end-rand_rij_))) * gammas1_well_1_f[rand_res_paira(contact_cnt3,restype1)][rand_res_pairb(contact_cnt3,restype1)] );

					//get decoy energies for contact - DIRECT and WATER (well2)
					double rand_water_fraction = ( 0.5 * (1-tanh(5*(pi[rand_pos_pi(res_1_position,restype1)]-2.6))) * 0.5 * (1-tanh(5*(pi[rand_pos_pi(res_2_position,restype1)]-2.6))) );
					double rand_buried_fraction = (1-rand_water_fraction);
					native_surface_energy_fold_rand_pi_rij_res(restype1) += ( 0.25 * (1+tanh(5*(rand_rij_-well_2_start))) * (1+tanh(5*(well_2_end-rand_rij_))) * (rand_water_fraction*gammas2_well_2_f[rand_res_paira(contact_cnt3,restype1)][rand_res_pairb(contact_cnt3,restype1)] + rand_buried_fraction*gammas1_well_2_f[rand_res_paira(contact_cnt3,restype1)][rand_res_pairb(contact_cnt3,restype1)] ) );

				} //end of loop over residue types (looping over restype1)

				//Print info abt contact
				int res1 = res_1_position; int res2 = res_2_position;

				//contact only
				decoy_mean_fold = gsl_stats_mean(native_surface_energy_fold_rand_pi_rij_res.data(),1,surf_decoys);
				decoy_std_fold = gsl_stats_sd(native_surface_energy_fold_rand_pi_rij_res.data(),1,surf_decoys);
				cout << "CONT\t" << res1 << "\t" << res2 << "\t" << native_surface_energy_fold << "\t" << decoy_mean_fold << "\t" << ((native_surface_energy_fold-decoy_mean_fold)/decoy_std_fold) << "\t" << seg_res[res1] << "\t" << seg_res[res2] << "\t" << residue_percent_sas[res1] << "\t" << residue_percent_sas[res2] << "\t"  <<cont_to_type[res1_res2_to_cont(res1,res2)] << endl;

				//burial only - both residues coupled
				decoy_mean_fold = gsl_stats_mean(native_surface_energy_fold_burial_rand_pi_res.data(),1,surf_decoys);
				decoy_std_fold = gsl_stats_sd(native_surface_energy_fold_burial_rand_pi_res.data(),1,surf_decoys);
				cout << "CONT_BURIAL\t" << res1 << "\t" << res2 << "\t" << native_surface_energy_fold_burial << "\t" << decoy_mean_fold << "\t" << ((native_surface_energy_fold_burial-decoy_mean_fold)/decoy_std_fold) << "\t" << seg_res[res1] << "\t" << seg_res[res2] << "\t" << residue_percent_sas[res1] << "\t" << residue_percent_sas[res2] << "\t" << cont_to_type[res1_res2_to_cont(res1,res2)] << endl;

				//contact and burial (both)
				//Prepare 'both' arrays
				Array<double,1> native_surface_energy_fold_both_pi_rij_res_temp(surf_decoys);
				for (restype1=0;restype1<surf_decoys;restype1+=1) {
					native_surface_energy_fold_both_pi_rij_res_temp(restype1) = (native_surface_energy_fold_rand_pi_rij_res(restype1) + native_surface_energy_fold_burial_rand_pi_res(restype1));
				} // restype1 loop
				double native_both = (native_surface_energy_fold+native_surface_energy_fold_burial);
				decoy_mean_fold = gsl_stats_mean(native_surface_energy_fold_both_pi_rij_res_temp.data(),1,surf_decoys);
				decoy_std_fold = gsl_stats_sd(native_surface_energy_fold_both_pi_rij_res_temp.data(),1,surf_decoys);
				cout << "CONT_BOTH\t" << res1 << "\t" << res2 << "\t" << native_both << "\t" << decoy_mean_fold << "\t" << ((native_both-decoy_mean_fold)/decoy_std_fold) << "\t" << seg_res[res1] << "\t" << seg_res[res2] << "\t" << residue_percent_sas[res1] << "\t" << residue_percent_sas[res2] << "\t" << cont_to_type[res1_res2_to_cont(res1,res2)] << endl;

			} //end if(res_it_3<res_it_4)
			contact_cnt3++;
		} //end if (native_contact_map>0)
		++res_2_position;
	} //end of res_it_4 iterator
	++res_1_position;
} //end of res_it_3 iterator

++i;
}  //end of main()

