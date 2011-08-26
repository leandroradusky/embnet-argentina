#!/bin/bash
X=1
Z=0
L="$(grep -c "" $1)"
while [ $X -le $L ]
do
        Y=$((Z+1))
        grep -n "" $1 | awk -F ":" '($1=='$X'){print $2}' | awk '{ print "select "1+$1".CA, "1+$2".CA;\nCONNECT single; CONNECT "$3" ",$4=="solid"?"single":"translucent"," radius 0."$5";"}' 
	Z=$((Z+2))
        X=$((X+1))
done
