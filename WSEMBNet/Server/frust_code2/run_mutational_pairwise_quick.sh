#!/bin/bash
#args: <coord (pdb) file> <sas info file>

FRUST_HOME=`dirname "$0"`

if [ -r ${1}.sas ]; then
   echo "WARNING: run_mutational...  Using the allready existat ${1}.sas"
else
   $FRUST_HOME/report_sas_only $1 > ${1}.sas
fi

$FRUST_HOME/report_seq_code $1 > ${1}.seq

#echo 'hola'
#echo $1
#echo ${1}


#nice -n 19 mutational_perres_quick well12_bounds_6.5_9.5_fixed garyk_pnas_well12_direct_reordered garyk_pnas_well1direct_well2water_reordered gammas3 $1.sas ${1}.seq 1000 $1

#nice -n 19 mutational_pairwise_quick well12_bounds_6.5_9.5_fixed garyk_pnas_well12_direct_reordered garyk_pnas_well1direct_well2water_reordered gammas3 ${1}.sas ${1}.seq 1000 $1 

nice -n 19 $FRUST_HOME/mutational_perres_quick $FRUST_HOME/garyk_pnas_well12_direct_reordered $FRUST_HOME/garyk_pnas_well1direct_well2water_reordered $FRUST_HOME/gammas3 $1.sas ${1}.seq 1000 $1

nice -n 19 $FRUST_HOME/mutational_pairwise_quick $FRUST_HOME/garyk_pnas_well12_direct_reordered $FRUST_HOME/garyk_pnas_well1direct_well2water_reordered $FRUST_HOME/gammas3 ${1}.sas ${1}.seq 1000 $1 

