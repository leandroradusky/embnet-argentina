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

#now we generate 2D statistics figures
export GDFONTPATH=/usr/share/fonts/truetype/ttf-bitstream-vera
cd "$1".done
$FRUST_HOME/5Adens/get_frstCA_dist.sh `basename $1 .pdb` > /dev/null
mut_dat=res_mf_vp_sphere5A_`basename $1 .pdb`.dat
echo $mut_dat
echo 'set grid; set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 10 size 520,420; set output "'$mut_dat'.png"; plot "./'$mut_dat'" using 1:2 title "type 1", "./'$mut_dat'" using  1:3 title "type 2", "./'$mut_dat'" using  1:4 title "type 3" ; ' 
echo 'set grid; set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 10 size 520,420; set output "'$mut_dat'.png"; plot "./'$mut_dat'" using 1:2 title "type 1", "./'$mut_dat'" using  1:3 title "type 2", "./'$mut_dat'" using  1:4 title "type 3" ; ' | gnuplot -


#here we egnerate the stacked histogram
echo 'set grid;set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 10 size 520,420;set output "'$mut_dat'_stacked.png";set key invert reverse Left outside;set auto x;set style data histogram;set style histogram rowstacked;set style fill solid border -1;set boxwidth 0.75;plot "./'$mut_dat'"  using (column(2)):xtic(1) t 2 title "type 1" , "" using (column(3))  t 3 title "type 2", "" using (column(4)) t 4 title "type 3"'
echo 'set grid;set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 10 size 520,420;set output "'$mut_dat'_stacked.png";set key invert reverse Left outside;set auto x;set style data histogram;set style histogram rowstacked;set style fill solid border -1;set boxwidth 0.75;plot "./'$mut_dat'"  using (column(2)):xtic(1) t 2 title "type 1" , "" using (column(3))  t 3 title "type 2", "" using (column(4)) t 4 title "type 3"' | gnuplot -

#now we generate the map plot
awk '($9 == 1) {print $1 , $2}' "$target"_cont > "$target"_1.dat
awk '($9 == 2) {print $1 , $2}' "$target"_cont > "$target"_2.dat
awk '($9 == 3) {print $1 , $2}' "$target"_cont > "$target"_3.dat
map_size=$((6 * `grep ' CA ' $target | wc -l`))
echo 'set grid; set nokey; set terminal png nocrop enhanced font Vera 10 size '$((60+$map_size))','$((30+$map_size))'; set size square; set output "'$target'_map.png"; set pointsize 0.5 ; plot "'$target'_1.dat" using 1:2 pt 5 lt rgb "green" , "'$target'_2.dat" using  1:2 pt 5 lt rgb "grey", "'$target'_3.dat" using  1:2 pt 5 lt rgb "red"; '
echo 'set grid; set nokey; set terminal png nocrop enhanced font Vera 10 size '$((60+$map_size))','$((30+$map_size))'; set size square; set output "'$target'_map.png"; set pointsize 0.5 ; plot "'$target'_1.dat" using 1:2 pt 5 lt rgb "green" , "'$target'_2.dat" using  1:2 pt 5 lt rgb "grey", "'$target'_3.dat" using  1:2 pt 5 lt rgb "red"; ' | gnuplot -

time1=`date +%s`
interval=`expr $time1 - $time0`
echo "Done $1 of $aminosize redidues in $interval seconds" 


