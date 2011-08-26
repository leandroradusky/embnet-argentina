#!/bin/bash

for i in `cat seed.info`
do
time0=`date +%s`
aminosize=`grep ' CA ' $i | wc -l`
echo "Working on $i of $aminosize aminoacids..."
#./report_sas_only "$i" > "$i".sas
#./report_contacts_v0.1 well12_bounds_6.5_9.5_fixed "$i".sas "$i" > "$i".well
./run_config_quick.sh "$i" > "$i"_config
./run_mutational_pairwise_quick.sh "$i" > "$i"_mutational
./parse_output.sh "$i"
time1=`date +%s`
interval=`expr $time1 - $time0`
echo "$i $aminosize $interval" >> tiempos
mv "$i"* ./done/
done
