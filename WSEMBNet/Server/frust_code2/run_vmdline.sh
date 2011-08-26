#!/bin/bash
X=1
Z=0
L="$(grep -c "" $1)"
while [ $X -le $L ]
do
        Y=$((Z+1))
	grep -n "" $1 | awk -F ":" '($1=='$X'){print $2}' | awk '{print "set sel"$1" [atomselect top \"resid "1+$1" and name CA\"]\nset sel"$2" [atomselect top \"resid "1+$2" and name CA\"]\n# get the coordinates\nlassign [atomselect'$Z' get {x y z}] pos1\nlassign [atomselect'$Y' get {x y z}] pos2\n# draw a green line between the two atoms\ndraw color "$3"\ndraw line $pos1 $pos2 style "$4" width "$5""}' 
	Z=$((Z+2))
        X=$((X+1))
done
