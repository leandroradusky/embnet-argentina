#!/bin/bash

FRUST_HOME=`dirname "$0"`

time0=`date +%s`
aminosize=`grep ' CA ' $1 | wc -l`
echo "Working on $1 of $aminosize aminoacids..."
#we filter the ATOM lines.
mkdir "$1".done

target="$1".done/`basename $1`
$FRUST_HOME/fixUniqueResNos "$1" > "$1"_filtered.tmp
$FRUST_HOME/renumResNo "$1"_filtered.tmp > $target
rm "$1"_filtered.tmp
cp $target "$1"_filtered.pdb

#./report_sas_only "$i" > "$i".sas
#./report_contacts_v0.1 well12_bounds_6.5_9.5_fixed "$i".sas "$i" > "$i".well
$FRUST_HOME/run_config_quick.sh "$target" > "$target"_config
$FRUST_HOME/run_mutational_pairwise_quick.sh "$target" > "$target"_mutational
$FRUST_HOME/parse_output.sh "$target"
$FRUST_HOME/078cuttof.sh "$target"



$FRUST_HOME/generate_graphs.sh "$1"

#tar -czf `dirname "$1"`.tgz `dirname "$1"`

time1=`date +%s`
interval=`expr $time1 - $time0`
echo "Done $1 of $aminosize redidues in $interval seconds" 

echo -e "\n$aminosize\n$interval" >> `dirname "$1"`/detail.log

#tar --exclude=stdout.log --exclude=start -czf `dirname "$1"`.tgz `dirname "$1"`
jobdir=`dirname "$1"`
workdir=$1.done
jobID=`basename "$jobdir"`
cache=`dirname "$jobdir"`

# MAKE A DUMMY DIR FOR FILE-SELECTION, DO THA DOWNLOAD FILES AND THEN CRASH IT
mkdir $jobdir/frustratometer_$jobID
# THY README
cp $cache/README $jobdir/frustratometer_$jobID/
# THY pdf
wkhtmltopdf -p http://proxy.uba.ar:8080 http://bioinf.qb.fcen.uba.ar/frustra/frustra_results.php?jobid=$jobID $jobdir/frustratometer_$jobID/$jobID.pdf
cp $jobdir/frustratometer_$jobID/$jobID.pdf $jobdir/
# try.pdb
cp $jobdir/*filtered.pdb $jobdir/frustratometer_$jobID/$jobID.pdb
# try.pdb_cfrst.tcl
cp $workdir/*pdb_cfrst.tcl $jobdir/frustratometer_$jobID/$jobID.pdb_cfrst.tcl
# try.pdb_mfrst.tcl
cp $workdir/*pdb_mfrst.tcl $jobdir/frustratometer_$jobID/$jobID.pdb_mfrst.tcl
# try.pdb_cont
cp $workdir/*pdb_cont $jobdir/frustratometer_$jobID/$jobID.pdb_cont
# res_cf_vp_sphere5A_try.dat
cp $workdir/res_cf_vp_sphere5A_*.dat $jobdir/frustratometer_$jobID/res_cf_vp_sphere5A_$jobID.dat
# res_mf_vp_sphere5A_try.dat
cp $workdir/res_mf_vp_sphere5A_*.dat $jobdir/frustratometer_$jobID/res_mf_vp_sphere5A_$jobID.dat
# try.pdb_res
cp $workdir/*.pdb_res $jobdir/frustratometer_$jobID/$jobID.pdb_res

tar -zcf $jobdir.tgz -C $jobdir/ frustratometer_$jobID
rm -rf $jobdir/frustratometer_$jobID/

#tar --exclude=stdout.log --exclude=start  -czf $jobdir.tgz -C $jobdir/.. `basename "$jobdir"`  
