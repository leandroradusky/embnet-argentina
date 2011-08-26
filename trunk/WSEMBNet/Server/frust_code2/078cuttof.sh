#!/bin/bash

FRUST_HOME=`dirname "$0"`

awk '($1!= "" && $4>=0.78 && $9!=3){print $1"\t"$2"\tgreen\tsolid\t1"}' ${1}_cont > ${1}_cont_gt1
awk '($1!= "" && $4>=0.78 && $9==3){print $1"\t"$2"\tgreen\tdashed\t1"}' ${1}_cont > ${1}_cont_gt1_w
awk '($1!= "" && $4<=-1 && $9==3){print $1"\t"$2"\tred\tdashed\t2"}' ${1}_cont > ${1}_cont_lt-1_w
awk '($1!= "" && $4<=-1 && $9!=3){print $1"\t"$2"\tred\tsolid\t2"}' ${1}_cont > ${1}_cont_lt-1
#awk '($1!= "" && $4>-1 && $4<0.78 && $9==3){print $1"\t"$2"\tyellow\tdashed"}' ${1}_cont > cont_gt-1lt1_w
#awk '($1!= "" && $4>-1 && $4<0.78 && $9!=3){print $1"\t"$2"\tyellow\tsolid"}' ${1}_cont > cont_gt-1lt1
cat ${1}_cont_lt-1* ${1}_cont_gt1* >  ${1}_minmax.dat
$FRUST_HOME/run_vmdline.sh ${1}_minmax.dat > ${1}_mfrst.tclr
$FRUST_HOME/run_jmolline.sh ${1}_minmax.dat > ${1}_mfrst.jmolr
echo "mut_cont"

awk '($1!= "" && $3>=0.78 && $9!=3){print $1"\t"$2"\tgreen\tsolid\t1"}' ${1}_cont > ${1}_cont_gt1
awk '($1!= "" && $3>=0.78 && $9==3){print $1"\t"$2"\tgreen\tdashed\t1"}' ${1}_cont > ${1}_cont_gt1_w
awk '($1!= "" && $3<=-1 && $9==3){print $1"\t"$2"\tred\tdashed\t2"}' ${1}_cont > ${1}_cont_lt-1_w
awk '($1!= "" && $3<=-1 && $9!=3){print $1"\t"$2"\tred\tsolid\t2"}' ${1}_cont > ${1}_cont_lt-1
#awk '($1!= "" && $3>-1 && $3<0.78 && $9==3){print $1"\t"$2"\tyellow\tdashed"}' ${1}_cont > cont_gt-1lt1_w
#awk '($1!= "" && $3>-1 && $3<0.78 && $9!=3){print $1"\t"$2"\tyellow\tsolid"}' ${1}_cont > cont_gt-1lt1
cat ${1}_cont_lt-1* ${1}_cont_gt1* >  ${1}_minmax.dat
$FRUST_HOME/run_vmdline.sh ${1}_minmax.dat > ${1}_cfrst.tclr
$FRUST_HOME/run_jmolline.sh ${1}_minmax.dat > ${1}_cfrst.jmolr
rm ${1}_cont_* ${1}_minmax.dat
echo "conf_cont"

cat << EOF > ${1}_colorit.tclr
mol modselect 0 top "all"
mol modstyle 0 top newcartoon
mol modcolor 0 top colorid 15
EOF

cat << EOF > ${1}_colorit.jmolr
select protein; cartoons;
connect delete;
spacefill off;
color background white;
EOF

cat ${1}_colorit.jmolr ${1}_cfrst.jmolr  > ${1}_cfrst.jmol
cat ${1}_colorit.jmolr ${1}_mfrst.jmolr  > ${1}_mfrst.jmol
cat ${1}_cfrst.tclr ${1}_colorit.tclr  > ${1}_cfrst.tcl
cat ${1}_mfrst.tclr ${1}_colorit.tclr  > ${1}_mfrst.tcl
rm  ${1}*.tclr ${1}*.jmolr

echo "done"
