#!/bin/bash

grep "PER" ${1}_config | awk '{print $2"\t"$5}' > ${1}_config_res
grep "CONT_BOTH" ${1}_config | awk '{print $2"\t"$3"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11}' > ${1}_config_cont

grep "RES_CONT_BOTH" ${1}_mutational | awk '{print $2"\t"$5"\t"$6"\t"$7}' > ${1}_mutational_res

#in this line mjenik included the contact type by adding the 7th column to the resume _cont file
grep "^CONT_BOTH" ${1}_mutational | awk '{print $2"\t"$3"\t"$6"\t"$7}' > ${1}_mutational_cont

paste ${1}_config_res ${1}_mutational_res | awk '{print $1"\t"$2"\t"$4"\t"$5"\t"$6}' > ${1}_res

#in this line mjenik included the mutational contact type at the end , after the configurational one, by adding the 12th col.
paste ${1}_config_cont ${1}_mutational_cont | awk '{print $1"\t"$2"\t"$3"\t"$11"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$12}' > ${1}_cont

#If I woul like to have a .well file, do this ... grep "CONT_BOTH" ${1}_config | awk '{print $2"\t"$3"\t"$11}' > ${1}.well

#paste ${1}_conts ${1}.well > ${1}_cont

rm ${1}_config_res ${1}_config_cont ${1}_mutational_res ${1}_mutational_cont ${1}_conts
