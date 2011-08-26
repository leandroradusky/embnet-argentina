// Just report the sas area for the input file and send to standard out

// needed for cout
#include <iostream>
#include <string>
#include <map>

#include <gsl/gsl_statistics.h>

// the BALL kernel classes
#include <BALL/KERNEL/residue.h>
#include <BALL/KERNEL/system.h>
//#include <BALL/KERNEL/standardPredicates.h>
#include <BALL/MATHS/analyticalGeometry.h>
#include <BALL/DATATYPE/string.h>

// for calculating the SAS area numerically
#include <BALL/STRUCTURE/numericalSAS.h>
#include <BALL/STRUCTURE/defaultProcessors.h>
#include <BALL/STRUCTURE/residueChecker.h>
#include <BALL/STRUCTURE/fragmentDB.h>

// reading and writing of PDB files
#include <BALL/FORMAT/PDBFile.h>

// this class will allow me to use a hash-like object later
class NumberName
{
public:

//    typedef std::pair<std::string,int>; // needed for some
                                             // versions of VC++

    void insert(const std::string& name, int value)
    {
        theMap[name] = value;
    }

    int find(const std::string& name)
    {
        std::map<std::string,int>::iterator it = theMap.find(name);

        if (it != theMap.end())
            return it->second;
        else
            return -1;
    }

private:

    std::map<std::string,int> theMap;
};


// we use the BALL namespace  and the std namespace (for cout and endl)
using namespace BALL;
using namespace std;
using std::string;
using std::map;

float residue_area_1 = 0.0;
int i=1;

int main(int argc, char *argv[])
{

   /////////////////////////
   // Constants defined here
   //typedef std::string string;
   //typedef map<string, int> res;
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

   NumberName sas_residues;
   sas_residues.insert ( "ALA",114);
   sas_residues.insert ( "ARG",248);
   sas_residues.insert ( "ASN",155);
   sas_residues.insert ( "ASP",152);
   sas_residues.insert ( "CYS",145);
   sas_residues.insert ( "GLN",186);
   sas_residues.insert ( "GLU",183);
   sas_residues.insert ( "GLY",85);
   sas_residues.insert ( "HIS",183);
   sas_residues.insert ( "ILE",181);
   sas_residues.insert ( "LEU",186);
   sas_residues.insert ( "LYS",223);
   sas_residues.insert ( "MET",201);
   sas_residues.insert ( "PHE",198);
   sas_residues.insert ( "PRO",152);
   sas_residues.insert ( "SER",126);
   sas_residues.insert ( "THR",147);
   sas_residues.insert ( "TRP",223);
   sas_residues.insert ( "TYR",214);
   sas_residues.insert ( "VAL",156);

   // create a PDBFile object
   PDBFile infile(argv[i]);
   
   // create a system
   System S;

   // read the contents of bpti.pdb into the system 
   infile >> S;
   infile.close();

   // assign the radii defining the solvent accessible surface
   AssignRadiusProcessor rp("radii/PARSE.siz");
   S.apply(rp);

   // close the file
   infile.close();

   int native_chain_length = S.countResidues();

   //Preparing and determining the SAS for the complete protein
   HashMap<const Atom*, float> atom_areas;
   calculateSASAtomAreas(S, atom_areas, 1.5, 400);

   int res_0_position=0;
   ResidueIterator res_it_3;
   for (res_it_3 = S.beginResidue();
       res_it_3 != S.endResidue();
       ++res_it_3)
   {
	   residue_area_1 = 0.0;
           AtomIterator atom_it_res_3_sas;
	   for (atom_it_res_3_sas = res_it_3->beginAtom();
		atom_it_res_3_sas != res_it_3->endAtom();
                ++atom_it_res_3_sas)
           {
		//Get the SAS for this residue
           	if (atom_areas.has(&*atom_it_res_3_sas)) {
           	   // retrieve the atom area by its pointer
              	   residue_area_1 += atom_areas[&*atom_it_res_3_sas];
           	}
           }
           // print the surface area along with the residue name and ID
           //Log.info() << res_it_3->getName() << res_it_3->getID() << " ";
           if (residue_area_1 > 0.0)
           {
		//Log.info() << (residue_area_1/sas_residues.find(res_it_3->getName())) << "\t" << res_0_position << endl;
		//residue_percent_sas[res_0_position] = (residue_area_1/sas_residues.find(res_it_3->getName()));
		cout << (residue_area_1/sas_residues.find(res_it_3->getName())) << endl;
 	   }
           else
           {
        	//Log.info() << "buried" << endl;
		//residue_percent_sas[res_0_position] = 0;
		cout << "0" << endl;
           }
	++res_0_position;
   }
}

