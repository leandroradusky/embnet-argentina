// -*- Mode: C++; tab-width: 2; -*-
// vi: set ts=2:

//this reports the sequence of the protein in 'integer code' (0-19)

#include <ios> // needed for cout
#include <iostream>
#include <string>
#include <map>
#include <iomanip> //this allows manipulation of the output behaviour (from cout)

// the BALL kernel classes
#include <BALL/KERNEL/residue.h>
#include <BALL/KERNEL/system.h>
//#include <BALL/KERNEL/standardPredicates.h>
#include <BALL/DATATYPE/string.h>
// for calculating the SAS area numerically
#include <BALL/STRUCTURE/defaultProcessors.h>
#include <BALL/STRUCTURE/residueChecker.h>
#include <BALL/STRUCTURE/fragmentDB.h>
// reading and writing of PDB files
#include <BALL/FORMAT/PDBFile.h>

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
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

//this allows me to convert an integer (q here) into a char string to use as filename
static inline string IntTypeToStr(int x){
	std::ostringstream o;
	if (!(o << x)) printf("Error in conversion from int to string \n");
	return o.str();
}

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

int i=1;
// create a PDBFile object
PDBFile infile(argv[i]); i++;

// create a system
System S;
infile >> S; // read the contents of bpti.pdb into the system 
infile.close(); // close the file

ResidueIterator res_it_1;
for (res_it_1 = S.beginResidue(); res_it_1 != S.endResidue(); ++res_it_1) {
	cout << residues.find(res_it_1->getName()) << endl;
}

}


