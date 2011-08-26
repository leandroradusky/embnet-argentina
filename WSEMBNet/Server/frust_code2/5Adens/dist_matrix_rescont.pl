#!/usr/bin/perl -w
# calculates the distance from CA res to every 'virtual particle'! of contacts
# from a frstr report file

use strict;
use Getopt::Std;

# make sure command line argments okay
if ($#ARGV == -1) {
    &usage() and exit -1;
}

# defaults and global variables
my $coor_file;
my $cont_file;
my $numres;
my $numcont;

# evaluate any flags that may change the default values
&getopts('i:j:', \my %opts);

# residue coordinate file
if (defined $opts{'i'}) {
    $coor_file = $opts{'i'};
} else {
    &usage() and exit;
}

# contact coordinate file
if (defined $opts{'j'}) {
    $cont_file = $opts{'j'};
} else {
    &usage() and exit;
}


# open coordinate file
open(COOR, "$coor_file")
    or die "Unable to open $coor_file.";

my $iline = 0;
my @seginfo = ();
my $iatom = 0;

# get the xyz residues
while (my $cline = <COOR>) {
    my @line = split (" ", $cline); shift(@line); shift(@line);
        my $x = shift(@line);
	my $y = shift(@line);
	my $z = shift(@line);
    $iatom = $iatom + 1;

#printf (" res="); printf $iatom; printf (" x="); printf $x; printf (" y="); printf $y; printf (" z="); printf $z; printf (" \n");

	push(@seginfo,"$iatom:$x:$y:$z");
    $numres = $iatom
    }

close (COOR);

#open contacts file
open(CONT, "$cont_file")
    or die "Unable to open $coor_file.";

$iline = 0;
my @continfo = ();
$iatom = 0;

# get the xyz residues
while (my $cline = <CONT>) {
    my @line = split (" ", $cline); shift(@line); shift(@line);
    my $x = shift(@line);
    my $y = shift(@line);
    my $z = shift(@line);
    $iatom = $iatom + 1;

#printf (" res="); printf $iatom; printf (" x="); printf $x; printf (" y="); printf $y; printf (" z="); printf $z; printf (" \n");

    push(@continfo,"$iatom:$x:$y:$z");
    $numcont = $iatom
    }

close (CONT);

# get distances
for (my $i = 0; $i < @seginfo; $i++) {
    for (my $j = 0; $j < @continfo; $j++) {
	(my $a1, my $x1, my $y1, my $z1) = split(":", $seginfo[$i]);
	(my $a2, my $x2, my $y2, my $z2) = split(":", $continfo[$j]);
	my $dist = calc_dist($x1, $y1, $z1, $x2, $y2, $z2);
	printf("%.2f ", $dist);
    }
    print "\n";
}

sub calc_dist {
    my $ax = shift;
    my $ay = shift;
    my $az = shift;

    my $bx = shift;
    my $by = shift;
    my $bz = shift;

    my $dist;

    my $mx = $bx - $ax;
    my $my = $by - $ay;
    my $mz = $bz - $az;

    $dist = sqrt($mx*$mx + $my*$my + $mz*$mz);

    return $dist;
 }



sub usage {
    print STDERR << "EOF";

 -i       : residue frstration file with CA x,y,z
 -j       : contact frstration file with vp x,y,z


EOF
}
