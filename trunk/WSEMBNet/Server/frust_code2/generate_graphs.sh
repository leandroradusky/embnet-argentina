#!/bin/bash

FRUST_HOME=`dirname "$0"`

aminosize=`grep ' CA ' $1 | wc -l`
echo "Graphing on $1 of $aminosize aminoacids..."
#we filter the ATOM lines.
mkdir "$1".done

target="$1".done/`basename $1`

#now we generate 2D statistics figures
export GDFONTPATH=/usr/share/fonts/truetype/ttf-bitstream-vera
cd "$1".done
$FRUST_HOME/5Adens/get_frstCA_dist.sh `basename $1 .pdb` > /dev/null
mut_dat=res_mf_vp_sphere5A_`basename $1 .pdb`.dat
con_dat=res_cf_vp_sphere5A_`basename $1 .pdb`.dat
echo $mut_dat
echo 'set key outside below; set grid; set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 10 size 520,420; set output "'$mut_dat'.png"; plot "./'$mut_dat'" using ($1):3 title "Minimally frustrated" with lp lt rgb "green", "./'$mut_dat'" using  ($1):4 title "Neutral" with lp lt rgb "grey", "./'$mut_dat'" using  ($1):5 title "Highly frustrated" with lp lt rgb "red" , "./'$con_dat'" using  ($1):2 title "Total" with lp lt rgb "black";' | gnuplot -
echo 'set key outside below; set grid; set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 10 size 520,420; set output "'$con_dat'.png"; plot "./'$con_dat'" using ($1):3 title "Minimally frustrated" with lp lt rgb "green", "./'$con_dat'" using  ($1):4 title "Neutral" with lp lt rgb "grey", "./'$con_dat'" using  ($1):5 title "Highly frustrated" with lp lt rgb "red" , "./'$con_dat'" using  ($1):2 title "Total" with lp lt rgb "black";' | gnuplot -

#here we egnerate the stacked histogram
map_size=$((6 * `grep ' CA ' $target | wc -l`))
xsize=$((4*$map_size))
ysize=$map_size
#if [ "$xsize" -le "520" ] ; then xsize=520; ysize=420;  fi
#echo 'set grid;set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 8 size '$xsize','$ysize';set output "'$mut_dat'_stacked.png";set key invert reverse Left outside;set auto x;set style data histogram;set style histogram rowstacked;set style fill solid border -1;set boxwidth 0.75;plot "./'$mut_dat'"  using (column(3)):xtic(1) t 2 title "Minimally frustrated" , "" using (column(4))  t 3 title "Neutral", "" using (column(5)) t 4 title "Highly frustrated"'
#echo 'set grid;set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 8 size '$xsize','$ysize';set output "'$mut_dat'_stacked.png";set key invert reverse Left outside;set auto x;set style data histogram;set style histogram rowstacked;set style fill solid border -1;set boxwidth 0.75;plot "./'$mut_dat'"  using (column(3)):xtic(1) t 2 title "Minimally frustrated" , "" using (column(4))  t 3 title "Neutral", "" using (column(5)) t 4 title "Highly frustrated"' | gnuplot -
#echo 'set grid;set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 8 size '$xsize','$ysize';set output "'$con_dat'_stacked.png";set key invert reverse Left outside;set auto x;set style data histogram;set style histogram rowstacked;set style fill solid border -1;set boxwidth 0.75;plot "./'$con_dat'"  using (column(3)):xtic(1) t 2 title "Minimally frustrated" , "" using (column(4))  t 3 title "Neutral", "" using (column(5)) t 4 title "Highly frustrated"' | gnuplot -

#here the small figure of the stacked one.
#echo 'set grid;set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 8 size 520,420;set output "'$mut_dat'_stacked_small.png";set key invert reverse Left outside;set xrange [0:]; set style data histogram;set style histogram rowstacked;set style fill solid;set boxwidth 0.75;plot "./'$mut_dat'"  using (column(3)) t 2 title "Minimally frustrated" , "" using (column(4))  t 3 title "Neutral", "" using (column(5)) t 4 title "Highly frustrated"'
#echo 'set grid;set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 8 size 520,420;set output "'$mut_dat'_stacked_small.png";set key invert reverse Left outside;set xrange [0:]; set style data histogram;set style histogram rowstacked;set style fill solid;set boxwidth 0.75;plot "./'$mut_dat'"  using (column(3)) t 2 title "Minimally frustrated" , "" using (column(4))  t 3 title "Neutral", "" using (column(5)) t 4 title "Highly frustrated"'  | gnuplot -
#echo 'set grid;set xlabel "Position"; set ylabel "Local frustration density (5A sphere)"; set terminal png nocrop enhanced font Vera 8 size 520,420;set output "'$con_dat'_stacked_small.png";set key invert reverse Left outside;set xrange [0:]; set style data histogram;set style histogram rowstacked;set style fill solid;set boxwidth 0.75;plot "./'$con_dat'"  using (column(3)) t 2 title "Minimally frustrated" , "" using (column(4))  t 3 title "Neutral", "" using (column(5)) t 4 title "Highly frustrated"'  | gnuplot -

#here we generate the distribution by proportion
if [ "$xsize" -le "520" ] ; then xsize=520; ysize=420;  fi
echo 'set grid;set xlabel "Position"; set ylabel "Density arround 5A sphere (%)"; set terminal png nocrop enhanced font Vera 8 size '$xsize','$ysize';set output "'$mut_dat'_stacked_prop.png";set key invert reverse Left outside;set auto x;set style data histogram;set style histogram rowstacked;set style fill solid border -1;set boxwidth 0.75;plot "./'$mut_dat'"  using (100.*$3/$2):xtic(1)  with histograms lc rgb "green" title "Minimally frustrated" , "" using (100.*$4/$2) with histograms lc rgb "grey" title "Neutral", "" using (100.*$5/$2)  with histograms lc rgb "red" title "Highly frustrated"' 
echo 'set yrange [0:100];set grid;set xlabel "Position"; set ylabel "Density arround 5A sphere (%)"; set terminal png nocrop enhanced font Vera 8 size '$xsize','$ysize';set output "'$mut_dat'_stacked_prop.png";set key invert reverse Left outside;set auto x;set style data histogram;set style histogram rowstacked;set style fill solid border -1;set boxwidth 0.75;plot "./'$mut_dat'"  using (100.*$3/$2):xtic(1)  with histograms lc rgb "green" title "Minimally frustrated" , "" using (100.*$4/$2) with histograms lc rgb "grey" title "Neutral", "" using (100.*$5/$2)  with histograms lc rgb "red" title "Highly frustrated"' | gnuplot -
echo 'set yrange [0:100];set grid;set xlabel "Position"; set ylabel "Density arround 5A sphere (%)"; set terminal png nocrop enhanced font Vera 8 size '$xsize','$ysize';set output "'$con_dat'_stacked_prop.png";set key invert reverse Left outside;set auto x;set style data histogram;set style histogram rowstacked;set style fill solid border -1;set boxwidth 0.75;plot "./'$con_dat'"  using (100.*$3/$2):xtic(1)  with histograms lc rgb "green" title "Minimally frustrated" , "" using (100.*$4/$2) with histograms lc rgb "grey" title "Neutral", "" using (100.*$5/$2)  with histograms lc rgb "red"  title "Highly frustrated"' | gnuplot -

#here the small figure of the distribution
echo 'set yrange [0:100];set key center top;set grid;set xlabel "Position"; set ylabel "Density arround 5A sphere (%)"; set terminal png nocrop enhanced font Vera 8 size 520,420;set output "'$mut_dat'_stacked_prop_small.png";set key invert reverse Left outside;set xrange [0:]; set style data histogram;set style histogram rowstacked;set style fill solid;set boxwidth 0.75;plot "./'$mut_dat'"  using (100.*$3/$2) t 2 title "Minimally frustrated", "" using (100.*$4/$2)  t 3 title "Neutral", "" using (100.*$5/$2) t 4 title "Highly frustrated"' 
echo 'set yrange [0:100];set key outside below;set grid;set xlabel "Position"; set ylabel "Density arround 5A sphere (%) "; set terminal png nocrop enhanced font Vera 8 size 520,420;set output "'$mut_dat'_stacked_prop_small.png";set xrange [0:]; set style data histogram;set style histogram rowstacked;set style fill solid;set boxwidth 0.75;plot "./'$mut_dat'"  using (100.*$3/$2)  with histograms lc rgb "green" title "Minimally frustrated", "" using (100.*$4/$2) with histograms lc rgb "grey" title "Neutral" , "" using (100.*$5/$2) with histograms lc rgb "red" title "Highly frustrated"'  | gnuplot -
echo 'set yrange [0:100];set key outside below;set grid;set xlabel "Position"; set ylabel "Density arround 5A sphere (%) "; set terminal png nocrop enhanced font Vera 8 size 520,420;set output "'$con_dat'_stacked_prop_small.png";set xrange [0:]; set style data histogram;set style histogram rowstacked;set style fill solid;set boxwidth 0.75;plot "./'$con_dat'"  using (100.*$3/$2) with histograms lc rgb "green" title "Minimally frustrated", "" using (100.*$4/$2) with histograms lc rgb "grey" title "Neutral", "" using (100.*$5/$2) with histograms lc rgb "red" title "Highly frustrated" '  | gnuplot -






#now we generate the maps plot
map_size=$((6 * `grep ' CA ' $target | wc -l`))
#first the contact well type map
awk '($9 == 1) {print $1 , $2}' "$target"_cont > "$target"_conf_type1.dat
awk '($9 == 2) {print $1 , $2}' "$target"_cont > "$target"_conf_type2.dat
awk '($9 == 3) {print $1 , $2}' "$target"_cont > "$target"_conf_type3.dat
echo 'set grid; set nokey; set terminal png nocrop enhanced font Vera 8 size '$((60+$map_size))','$((30+$map_size))'; set size square; set output "'$target'_weltype_map.png"; set pointsize 0.5 ; plot "'$target'_conf_type1.dat" using 1:2 pt 5 lt rgb "green" , "'$target'_conf_type2.dat" using  1:2 pt 5 lt rgb "grey", "'$target'_conf_type3.dat" using  1:2 pt 5 lt rgb "red"; ' | gnuplot -

#here we generate the frustration maps
echo 'set grid; set nokey; set terminal png nocrop enhanced font Vera 8 size '$((60+$map_size))','$((30+$map_size))'; set size square; set output "'$target'_mut_map.png"; set palette defined (-3 "red", 0 "grey", 3 "green");set cbrange [-3:3];set cblabel "Local Mutational Frustration Index";set pointsize 0.5 ; set view map; splot "'$target'_cont" using 1:2:4 with points pt 5 palette; ' | gnuplot -
echo 'set grid; set nokey; set terminal png nocrop enhanced font Vera 8 size '$((60+$map_size))','$((30+$map_size))'; set size square; set output "'$target'_conf_map.png"; set palette defined (-3 "red", 0 "grey", 3 "green");set cbrange [-3:3];set cblabel "Local Configurational Frustration Index";set pointsize 0.5 ; set view map; splot "'$target'_cont" using 1:2:3 with points pt 5 palette; ' | gnuplot -



# here the small maps
pointsize=0.15;
if [ "$map_size" -le "520" ] ; then pointsize=$((312/$map_size)); fi
echo 'set grid; set nokey; set terminal png nocrop enhanced font Vera 8 size 520,520; set size square; set output "'$target'_welltype_map_small.png"; set pointsize "'$pointsize'"; plot "'$target'_conf_type1.dat" using 1:2 pt 5 lt rgb "green" , "'$target'_conf_type2.dat" using  1:2 pt 5 lt rgb "grey", "'$target'_conf_type3.dat" using  1:2 pt 5 lt rgb "red";' | gnuplot -
#here we generate the small frustration maps
echo 'set grid; set nokey; set terminal png nocrop enhanced font Vera 8 size 520,520; set size square; set output "'$target'_mut_map_small.png"; set palette defined (-3 "red", 0 "grey", 3 "green");set cbrange [-3:3];set cblabel "Local Mutational Frustration Index";set pointsize '"$pointsize"' ; set view map; splot "'$target'_cont" using 1:2:4 with points pt 5 palette; ' | gnuplot -
echo 'set grid; set nokey; set terminal png nocrop enhanced font Vera 8 size 520,520; set size square; set output "'$target'_conf_map_small.png"; set palette defined (-3 "red", 0 "grey", 3 "green");set cbrange [-3:3];set cblabel "Local Configurational Frustration Index";set pointsize '"$pointsize"' ; set view map; splot "'$target'_cont" using 1:2:3 with points pt 5 palette; ' | gnuplot -




#now we take a snapshot
#we generate the tcl by adding two lines to the original tcl

cp "$target"_mfrst.tcl  "$target"_mfrst_snapshot.tcl
echo 'color Display Background white;' >> "$target"_mfrst_snapshot.tcl
#echo 'display resize 500 500;' >> "$target"_mfrst_snapshot.tcl
echo 'render TachyonInternal '"$target"'_mfrst_snapshot.tga; exit;' >> "$target"_mfrst_snapshot.tcl
vmd -dispdev none -e "$target"_mfrst_snapshot.tcl "$target"
#vmd -e "$target"_mfrst_snapshot.tcl "$target"
convert "$target"_mfrst_snapshot.tga -resize 520x520 "$target"_mfrst_snapshot.png
#rm "$target"_mfrst_snapshot.tcl "$target"_mfrst_snapshot.tga

cp "$target"_cfrst.tcl  "$target"_cfrst_snapshot.tcl
echo 'color Display Background white;' >> "$target"_cfrst_snapshot.tcl
#echo 'display resize 500 500;' >> "$target"_cfrst_snapshot.tcl
echo 'render TachyonInternal '"$target"'_cfrst_snapshot.tga; exit;' >> "$target"_cfrst_snapshot.tcl
vmd -dispdev none -e "$target"_cfrst_snapshot.tcl "$target"
convert "$target"_cfrst_snapshot.tga -resize 520x520 "$target"_cfrst_snapshot.png
#rm "$target"_cfrst_snapshot.tcl "$target"_cfrst_snapshot.tga

for archivo in *.png; do convert $archivo -scale 250 "s_${archivo}"; done



