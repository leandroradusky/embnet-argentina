#!/bin/bash
#args: <coord (pdb) file> 

FRUST_HOME=`dirname "$0"`

$FRUST_HOME/report_sas_only $1 > ${1}.sas

nice -n 19 $FRUST_HOME/config_quick $FRUST_HOME/garyk_pnas_well12_direct_reordered $FRUST_HOME/garyk_pnas_well1direct_well2water_reordered $FRUST_HOME/gammas3 ${1}.sas 1000 $1 

