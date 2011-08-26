#!/bin/bash

FRUST_HOME=`dirname "$0"`

#for i in `cat seed.info`
#do
#mkdir $FRUST_HOME/done/$i
#cd $FRUST_HOME/done/$i
#mv $FRUST_HOME/data/"$i"* .
#echo "copying... " $i

i=$1

#parse out data res and cont
awk '($1 == "ATOM" && $3 == "CA"){print}' $i.pdb > lines.xyz
awk 'BEGIN { FS = "" } ($1 == "A") {print $31$32$33$34$35$36$37$38, $39$40$41$42$43$44$45$46, $47$48$49$50$51$52$53$54}' lines.xyz > coor.xyz
paste "$i".pdb_res coor.xyz > res_all_xyz
awk '{print $1, $3, $6, $7, $8}' res_all_xyz > res_id_frst_xyz_$i.dat
awk '{print $1, $2, $3}' "$i".pdb_cont > cont_ids_cfrst_$i.dat
awk '{print $1, $2, $4}' "$i".pdb_cont > cont_ids_mfrst_$i.dat

rm lines.xyz coor.xyz res_all_xyz

#get vps configurational
$FRUST_HOME/cont_vp_xyz.pl -i res_id_frst_xyz_$i.dat -j cont_ids_cfrst_$i.dat > vp_$i.dat
echo "getting vps"
awk '($4 >= 0.78){print $1, $3, $5, $6, $7}' vp_$i.dat > minfrst_vp_xyz_$i.dat
awk '($4 <= -1){print $1, $3, $5, $6, $7}' vp_$i.dat > maxfrst_vp_xyz_$i.dat
awk '($4 < 0.78 && $4 > -1){print $1, $3, $5, $6, $7}' vp_$i.dat > neufrst_vp_xyz_$i.dat
awk '{print $1, $3, $5, $6, $7}' vp_$i.dat > allfrst_vp_xyz_$i.dat

echo "calculating distances config"
$FRUST_HOME/dist_matrix_rescont.pl -i res_id_frst_xyz_$i.dat -j allfrst_vp_xyz_$i.dat > dist_ca_vp_all.dat
$FRUST_HOME/dist_matrix_rescont.pl -i res_id_frst_xyz_$i.dat -j minfrst_vp_xyz_$i.dat > dist_ca_vp_min.dat
$FRUST_HOME/dist_matrix_rescont.pl -i res_id_frst_xyz_$i.dat -j neufrst_vp_xyz_$i.dat > dist_ca_vp_neu.dat
$FRUST_HOME/dist_matrix_rescont.pl -i res_id_frst_xyz_$i.dat -j maxfrst_vp_xyz_$i.dat > dist_ca_vp_max.dat

wc "$i".pdb.sas | awk '{print $1}' > nress
nres=`cat nress`
j=1
while [ $j -le $nres ]
do
awk "(NR == "$j")" dist_ca_vp_all.dat |  tr ' ' '\n ' | awk '($1 > 1 && $1 < 5)' | wc | awk '{print $1}' > all
awk "(NR == "$j")" dist_ca_vp_min.dat |  tr ' ' '\n ' | awk '($1 > 1 && $1 < 5)' | wc | awk '{print $1}' > min
awk "(NR == "$j")" dist_ca_vp_neu.dat |  tr ' ' '\n ' | awk '($1 > 1 && $1 < 5)' | wc | awk '{print $1}' > neu
awk "(NR == "$j")" dist_ca_vp_max.dat |  tr ' ' '\n ' | awk '($1 > 1 && $1 < 5)' | wc | awk '{print $1}' > max
paste all min neu max > line
cat line >> cacho
j=$((j+1))
done
awk '($1 != 0){print NR, $1, $2, $3, $4, $2/$1, $3/$1, $4/$1}' cacho > res_cf_vp_sphere5A_$i.dat
awk '($1 == 0){print "residue " NR " has no contacts within 5A"}' cacho >> res_cf_vp_sphere5A_$i.dat

rm all min neu max line cacho nress minfrst_vp_xyz_$i.dat maxfrst_vp_xyz_$i.dat neufrst_vp_xyz_$i.dat allfrst_vp_xyz_$i.dat dist_ca_vp_*.dat vp_"$i".dat

#####
#get vps mutational
$FRUST_HOME/cont_vp_xyz.pl -i res_id_frst_xyz_$i.dat -j cont_ids_mfrst_$i.dat > vp_$i.dat

awk '($4 >= 0.78){print $1, $3, $5, $6, $7}' vp_$i.dat > minfrst_vp_xyz_$i.dat
awk '($4 <= -1){print $1, $3, $5, $6, $7}' vp_$i.dat > maxfrst_vp_xyz_$i.dat
awk '($4 < 0.78 && $4 > -1){print $1, $3, $5, $6, $7}' vp_$i.dat > neufrst_vp_xyz_$i.dat
awk '{print $1, $3, $5, $6, $7}' vp_$i.dat > allfrst_vp_xyz_$i.dat

echo "calculating distances mut"
$FRUST_HOME/dist_matrix_rescont.pl -i res_id_frst_xyz_$i.dat -j allfrst_vp_xyz_$i.dat > dist_ca_vp_all.dat
$FRUST_HOME/dist_matrix_rescont.pl -i res_id_frst_xyz_$i.dat -j minfrst_vp_xyz_$i.dat > dist_ca_vp_min.dat
$FRUST_HOME/dist_matrix_rescont.pl -i res_id_frst_xyz_$i.dat -j neufrst_vp_xyz_$i.dat > dist_ca_vp_neu.dat
$FRUST_HOME/dist_matrix_rescont.pl -i res_id_frst_xyz_$i.dat -j maxfrst_vp_xyz_$i.dat > dist_ca_vp_max.dat

wc "$i".pdb.sas | awk '{print $1}' > nress
nres=`cat nress`
j=1
while [ $j -le $nres ]
do
awk "(NR == "$j")" dist_ca_vp_all.dat |  tr ' ' '\n ' | awk '($1 > 1 && $1 < 5)' | wc | awk '{print $1}' > all
awk "(NR == "$j")" dist_ca_vp_min.dat |  tr ' ' '\n ' | awk '($1 > 1 && $1 < 5)' | wc | awk '{print $1}' > min
awk "(NR == "$j")" dist_ca_vp_neu.dat |  tr ' ' '\n ' | awk '($1 > 1 && $1 < 5)' | wc | awk '{print $1}' > neu
awk "(NR == "$j")" dist_ca_vp_max.dat |  tr ' ' '\n ' | awk '($1 > 1 && $1 < 5)' | wc | awk '{print $1}' > max
paste all min neu max > line
cat line >> cacho
j=$((j+1))
done

awk '($1 != 0){print NR, $1, $2, $3, $4, $2/$1, $3/$1, $4/$1}' cacho > res_mf_vp_sphere5A_$i.dat
awk '($1 == 0){print "residue " NR " has no contacts within 5A"}' cacho >> res_mf_vp_sphere5A_$i.dat

rm all min neu max line cacho nress minfrst_vp_xyz_$i.dat maxfrst_vp_xyz_$i.dat neufrst_vp_xyz_$i.dat allfrst_vp_xyz_$i.dat dist_ca_vp_*.dat vp_"$i".dat cont_ids_* res_id_frst*

echo $i
#done
