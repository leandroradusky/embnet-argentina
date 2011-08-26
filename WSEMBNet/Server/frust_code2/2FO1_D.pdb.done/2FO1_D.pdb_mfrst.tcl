set sel14 [atomselect top "resid 15 and name CA"]
set sel16 [atomselect top "resid 17 and name CA"]
# get the coordinates
lassign [atomselect0 get {x y z}] pos1
lassign [atomselect1 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style solid width 2
set sel14 [atomselect top "resid 15 and name CA"]
set sel17 [atomselect top "resid 18 and name CA"]
# get the coordinates
lassign [atomselect2 get {x y z}] pos1
lassign [atomselect3 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style solid width 2
set sel48 [atomselect top "resid 49 and name CA"]
set sel51 [atomselect top "resid 52 and name CA"]
# get the coordinates
lassign [atomselect4 get {x y z}] pos1
lassign [atomselect5 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style solid width 2
set sel10 [atomselect top "resid 11 and name CA"]
set sel14 [atomselect top "resid 15 and name CA"]
# get the coordinates
lassign [atomselect6 get {x y z}] pos1
lassign [atomselect7 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style dashed width 2
set sel15 [atomselect top "resid 16 and name CA"]
set sel17 [atomselect top "resid 18 and name CA"]
# get the coordinates
lassign [atomselect8 get {x y z}] pos1
lassign [atomselect9 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style dashed width 2
set sel29 [atomselect top "resid 30 and name CA"]
set sel32 [atomselect top "resid 33 and name CA"]
# get the coordinates
lassign [atomselect10 get {x y z}] pos1
lassign [atomselect11 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style dashed width 2
set sel31 [atomselect top "resid 32 and name CA"]
set sel34 [atomselect top "resid 35 and name CA"]
# get the coordinates
lassign [atomselect12 get {x y z}] pos1
lassign [atomselect13 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style dashed width 2
set sel32 [atomselect top "resid 33 and name CA"]
set sel39 [atomselect top "resid 40 and name CA"]
# get the coordinates
lassign [atomselect14 get {x y z}] pos1
lassign [atomselect15 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style dashed width 2
set sel34 [atomselect top "resid 35 and name CA"]
set sel36 [atomselect top "resid 37 and name CA"]
# get the coordinates
lassign [atomselect16 get {x y z}] pos1
lassign [atomselect17 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style dashed width 2
set sel37 [atomselect top "resid 38 and name CA"]
set sel39 [atomselect top "resid 40 and name CA"]
# get the coordinates
lassign [atomselect18 get {x y z}] pos1
lassign [atomselect19 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style dashed width 2
set sel45 [atomselect top "resid 46 and name CA"]
set sel51 [atomselect top "resid 52 and name CA"]
# get the coordinates
lassign [atomselect20 get {x y z}] pos1
lassign [atomselect21 get {x y z}] pos2
# draw a green line between the two atoms
draw color red
draw line $pos1 $pos2 style dashed width 2
set sel5 [atomselect top "resid 6 and name CA"]
set sel8 [atomselect top "resid 9 and name CA"]
# get the coordinates
lassign [atomselect22 get {x y z}] pos1
lassign [atomselect23 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel6 [atomselect top "resid 7 and name CA"]
set sel8 [atomselect top "resid 9 and name CA"]
# get the coordinates
lassign [atomselect24 get {x y z}] pos1
lassign [atomselect25 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel7 [atomselect top "resid 8 and name CA"]
set sel9 [atomselect top "resid 10 and name CA"]
# get the coordinates
lassign [atomselect26 get {x y z}] pos1
lassign [atomselect27 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel8 [atomselect top "resid 9 and name CA"]
set sel11 [atomselect top "resid 12 and name CA"]
# get the coordinates
lassign [atomselect28 get {x y z}] pos1
lassign [atomselect29 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel8 [atomselect top "resid 9 and name CA"]
set sel12 [atomselect top "resid 13 and name CA"]
# get the coordinates
lassign [atomselect30 get {x y z}] pos1
lassign [atomselect31 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel16 [atomselect top "resid 17 and name CA"]
set sel19 [atomselect top "resid 20 and name CA"]
# get the coordinates
lassign [atomselect32 get {x y z}] pos1
lassign [atomselect33 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel19 [atomselect top "resid 20 and name CA"]
set sel22 [atomselect top "resid 23 and name CA"]
# get the coordinates
lassign [atomselect34 get {x y z}] pos1
lassign [atomselect35 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel22 [atomselect top "resid 23 and name CA"]
set sel26 [atomselect top "resid 27 and name CA"]
# get the coordinates
lassign [atomselect36 get {x y z}] pos1
lassign [atomselect37 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel23 [atomselect top "resid 24 and name CA"]
set sel26 [atomselect top "resid 27 and name CA"]
# get the coordinates
lassign [atomselect38 get {x y z}] pos1
lassign [atomselect39 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel26 [atomselect top "resid 27 and name CA"]
set sel29 [atomselect top "resid 30 and name CA"]
# get the coordinates
lassign [atomselect40 get {x y z}] pos1
lassign [atomselect41 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel26 [atomselect top "resid 27 and name CA"]
set sel30 [atomselect top "resid 31 and name CA"]
# get the coordinates
lassign [atomselect42 get {x y z}] pos1
lassign [atomselect43 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel27 [atomselect top "resid 28 and name CA"]
set sel30 [atomselect top "resid 31 and name CA"]
# get the coordinates
lassign [atomselect44 get {x y z}] pos1
lassign [atomselect45 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel30 [atomselect top "resid 31 and name CA"]
set sel33 [atomselect top "resid 34 and name CA"]
# get the coordinates
lassign [atomselect46 get {x y z}] pos1
lassign [atomselect47 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel31 [atomselect top "resid 32 and name CA"]
set sel33 [atomselect top "resid 34 and name CA"]
# get the coordinates
lassign [atomselect48 get {x y z}] pos1
lassign [atomselect49 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel47 [atomselect top "resid 48 and name CA"]
set sel50 [atomselect top "resid 51 and name CA"]
# get the coordinates
lassign [atomselect50 get {x y z}] pos1
lassign [atomselect51 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel50 [atomselect top "resid 51 and name CA"]
set sel54 [atomselect top "resid 55 and name CA"]
# get the coordinates
lassign [atomselect52 get {x y z}] pos1
lassign [atomselect53 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel52 [atomselect top "resid 53 and name CA"]
set sel55 [atomselect top "resid 56 and name CA"]
# get the coordinates
lassign [atomselect54 get {x y z}] pos1
lassign [atomselect55 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel54 [atomselect top "resid 55 and name CA"]
set sel57 [atomselect top "resid 58 and name CA"]
# get the coordinates
lassign [atomselect56 get {x y z}] pos1
lassign [atomselect57 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel55 [atomselect top "resid 56 and name CA"]
set sel58 [atomselect top "resid 59 and name CA"]
# get the coordinates
lassign [atomselect58 get {x y z}] pos1
lassign [atomselect59 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel56 [atomselect top "resid 57 and name CA"]
set sel59 [atomselect top "resid 60 and name CA"]
# get the coordinates
lassign [atomselect60 get {x y z}] pos1
lassign [atomselect61 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel57 [atomselect top "resid 58 and name CA"]
set sel60 [atomselect top "resid 61 and name CA"]
# get the coordinates
lassign [atomselect62 get {x y z}] pos1
lassign [atomselect63 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel57 [atomselect top "resid 58 and name CA"]
set sel61 [atomselect top "resid 62 and name CA"]
# get the coordinates
lassign [atomselect64 get {x y z}] pos1
lassign [atomselect65 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style solid width 1
set sel3 [atomselect top "resid 4 and name CA"]
set sel5 [atomselect top "resid 6 and name CA"]
# get the coordinates
lassign [atomselect66 get {x y z}] pos1
lassign [atomselect67 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel3 [atomselect top "resid 4 and name CA"]
set sel7 [atomselect top "resid 8 and name CA"]
# get the coordinates
lassign [atomselect68 get {x y z}] pos1
lassign [atomselect69 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel5 [atomselect top "resid 6 and name CA"]
set sel7 [atomselect top "resid 8 and name CA"]
# get the coordinates
lassign [atomselect70 get {x y z}] pos1
lassign [atomselect71 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel6 [atomselect top "resid 7 and name CA"]
set sel9 [atomselect top "resid 10 and name CA"]
# get the coordinates
lassign [atomselect72 get {x y z}] pos1
lassign [atomselect73 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel7 [atomselect top "resid 8 and name CA"]
set sel11 [atomselect top "resid 12 and name CA"]
# get the coordinates
lassign [atomselect74 get {x y z}] pos1
lassign [atomselect75 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel7 [atomselect top "resid 8 and name CA"]
set sel13 [atomselect top "resid 14 and name CA"]
# get the coordinates
lassign [atomselect76 get {x y z}] pos1
lassign [atomselect77 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel8 [atomselect top "resid 9 and name CA"]
set sel10 [atomselect top "resid 11 and name CA"]
# get the coordinates
lassign [atomselect78 get {x y z}] pos1
lassign [atomselect79 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel9 [atomselect top "resid 10 and name CA"]
set sel11 [atomselect top "resid 12 and name CA"]
# get the coordinates
lassign [atomselect80 get {x y z}] pos1
lassign [atomselect81 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel19 [atomselect top "resid 20 and name CA"]
set sel21 [atomselect top "resid 22 and name CA"]
# get the coordinates
lassign [atomselect82 get {x y z}] pos1
lassign [atomselect83 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel19 [atomselect top "resid 20 and name CA"]
set sel23 [atomselect top "resid 24 and name CA"]
# get the coordinates
lassign [atomselect84 get {x y z}] pos1
lassign [atomselect85 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel21 [atomselect top "resid 22 and name CA"]
set sel26 [atomselect top "resid 27 and name CA"]
# get the coordinates
lassign [atomselect86 get {x y z}] pos1
lassign [atomselect87 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel23 [atomselect top "resid 24 and name CA"]
set sel25 [atomselect top "resid 26 and name CA"]
# get the coordinates
lassign [atomselect88 get {x y z}] pos1
lassign [atomselect89 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel23 [atomselect top "resid 24 and name CA"]
set sel27 [atomselect top "resid 28 and name CA"]
# get the coordinates
lassign [atomselect90 get {x y z}] pos1
lassign [atomselect91 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel24 [atomselect top "resid 25 and name CA"]
set sel26 [atomselect top "resid 27 and name CA"]
# get the coordinates
lassign [atomselect92 get {x y z}] pos1
lassign [atomselect93 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel26 [atomselect top "resid 27 and name CA"]
set sel28 [atomselect top "resid 29 and name CA"]
# get the coordinates
lassign [atomselect94 get {x y z}] pos1
lassign [atomselect95 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel28 [atomselect top "resid 29 and name CA"]
set sel33 [atomselect top "resid 34 and name CA"]
# get the coordinates
lassign [atomselect96 get {x y z}] pos1
lassign [atomselect97 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel33 [atomselect top "resid 34 and name CA"]
set sel35 [atomselect top "resid 36 and name CA"]
# get the coordinates
lassign [atomselect98 get {x y z}] pos1
lassign [atomselect99 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel33 [atomselect top "resid 34 and name CA"]
set sel37 [atomselect top "resid 38 and name CA"]
# get the coordinates
lassign [atomselect100 get {x y z}] pos1
lassign [atomselect101 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel33 [atomselect top "resid 34 and name CA"]
set sel38 [atomselect top "resid 39 and name CA"]
# get the coordinates
lassign [atomselect102 get {x y z}] pos1
lassign [atomselect103 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel42 [atomselect top "resid 43 and name CA"]
set sel44 [atomselect top "resid 45 and name CA"]
# get the coordinates
lassign [atomselect104 get {x y z}] pos1
lassign [atomselect105 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel43 [atomselect top "resid 44 and name CA"]
set sel47 [atomselect top "resid 48 and name CA"]
# get the coordinates
lassign [atomselect106 get {x y z}] pos1
lassign [atomselect107 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel44 [atomselect top "resid 45 and name CA"]
set sel47 [atomselect top "resid 48 and name CA"]
# get the coordinates
lassign [atomselect108 get {x y z}] pos1
lassign [atomselect109 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel45 [atomselect top "resid 46 and name CA"]
set sel50 [atomselect top "resid 51 and name CA"]
# get the coordinates
lassign [atomselect110 get {x y z}] pos1
lassign [atomselect111 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel48 [atomselect top "resid 49 and name CA"]
set sel50 [atomselect top "resid 51 and name CA"]
# get the coordinates
lassign [atomselect112 get {x y z}] pos1
lassign [atomselect113 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel50 [atomselect top "resid 51 and name CA"]
set sel52 [atomselect top "resid 53 and name CA"]
# get the coordinates
lassign [atomselect114 get {x y z}] pos1
lassign [atomselect115 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel50 [atomselect top "resid 51 and name CA"]
set sel53 [atomselect top "resid 54 and name CA"]
# get the coordinates
lassign [atomselect116 get {x y z}] pos1
lassign [atomselect117 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel50 [atomselect top "resid 51 and name CA"]
set sel55 [atomselect top "resid 56 and name CA"]
# get the coordinates
lassign [atomselect118 get {x y z}] pos1
lassign [atomselect119 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel52 [atomselect top "resid 53 and name CA"]
set sel54 [atomselect top "resid 55 and name CA"]
# get the coordinates
lassign [atomselect120 get {x y z}] pos1
lassign [atomselect121 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel53 [atomselect top "resid 54 and name CA"]
set sel55 [atomselect top "resid 56 and name CA"]
# get the coordinates
lassign [atomselect122 get {x y z}] pos1
lassign [atomselect123 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel53 [atomselect top "resid 54 and name CA"]
set sel57 [atomselect top "resid 58 and name CA"]
# get the coordinates
lassign [atomselect124 get {x y z}] pos1
lassign [atomselect125 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel54 [atomselect top "resid 55 and name CA"]
set sel56 [atomselect top "resid 57 and name CA"]
# get the coordinates
lassign [atomselect126 get {x y z}] pos1
lassign [atomselect127 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel54 [atomselect top "resid 55 and name CA"]
set sel58 [atomselect top "resid 59 and name CA"]
# get the coordinates
lassign [atomselect128 get {x y z}] pos1
lassign [atomselect129 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel55 [atomselect top "resid 56 and name CA"]
set sel57 [atomselect top "resid 58 and name CA"]
# get the coordinates
lassign [atomselect130 get {x y z}] pos1
lassign [atomselect131 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel55 [atomselect top "resid 56 and name CA"]
set sel59 [atomselect top "resid 60 and name CA"]
# get the coordinates
lassign [atomselect132 get {x y z}] pos1
lassign [atomselect133 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel56 [atomselect top "resid 57 and name CA"]
set sel58 [atomselect top "resid 59 and name CA"]
# get the coordinates
lassign [atomselect134 get {x y z}] pos1
lassign [atomselect135 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel57 [atomselect top "resid 58 and name CA"]
set sel59 [atomselect top "resid 60 and name CA"]
# get the coordinates
lassign [atomselect136 get {x y z}] pos1
lassign [atomselect137 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel58 [atomselect top "resid 59 and name CA"]
set sel60 [atomselect top "resid 61 and name CA"]
# get the coordinates
lassign [atomselect138 get {x y z}] pos1
lassign [atomselect139 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel58 [atomselect top "resid 59 and name CA"]
set sel61 [atomselect top "resid 62 and name CA"]
# get the coordinates
lassign [atomselect140 get {x y z}] pos1
lassign [atomselect141 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel58 [atomselect top "resid 59 and name CA"]
set sel62 [atomselect top "resid 63 and name CA"]
# get the coordinates
lassign [atomselect142 get {x y z}] pos1
lassign [atomselect143 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel59 [atomselect top "resid 60 and name CA"]
set sel61 [atomselect top "resid 62 and name CA"]
# get the coordinates
lassign [atomselect144 get {x y z}] pos1
lassign [atomselect145 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
set sel59 [atomselect top "resid 60 and name CA"]
set sel62 [atomselect top "resid 63 and name CA"]
# get the coordinates
lassign [atomselect146 get {x y z}] pos1
lassign [atomselect147 get {x y z}] pos2
# draw a green line between the two atoms
draw color green
draw line $pos1 $pos2 style dashed width 1
mol modselect 0 top "all"
mol modstyle 0 top newcartoon
mol modcolor 0 top colorid 15
