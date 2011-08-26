#!/usr/bin/perl -w
# calculates the CA location of virtual particle in a contact
# from frstr report files

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
my $temp;

# evaluate any flags that may change the default values
&getopts('i:j:', \my %opts);

# residue file
if (defined $opts{'i'}) {
    $coor_file = $opts{'i'};
} else {
    &usage() and exit;
}

# contact file
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

# get the xyz
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

# open contact file
open(CONT, "$cont_file")
    or die "Unable to open $cont_file.";

my $icont = 0;
my $numcont = 0;
my @continfo = ();

# get contact resnum
while (my $cline = <CONT>) {
    my @line = split (" ", $cline);
        my $res1 = shift(@line);
	my $res2 = shift(@line);
	my $frst = shift(@line);
    $icont = $icont + 1;

#printf (" cont="); printf $icont; printf (" res1="); printf $res1; printf (" res2="); printf $res2; printf (" \n");

	push(@continfo,"$icont:$res1:$res2:$frst");
    $numcont = $icont
    }

close (COOR);


for (my $i = 0; $i < @continfo; $i++) {
	(my $a1, my $id1, my $id2, my $frst) = split(":", $continfo[$i]);
	(my $a2, my $x1, my $y1, my $z1) = split(":", $seginfo[$id1]);
	(my $a3, my $x2, my $y2, my $z2) = split(":", $seginfo[$id2]);
	my @pos = calc_pos($x1, $y1, $z1, $x2, $y2, $z2);
	printf $i; printf (" "); printf $id1; printf (" "); printf $id2; printf (" "); printf $frst; printf (" "); printf @pos;
    print "\n";
}

sub calc_pos {
    my $ax = shift;
    my $ay = shift;
    my $az = shift;

    my $bx = shift;
    my $by = shift;
    my $bz = shift;

    my @dist;

    my $mx = ($bx + $ax) / 2;
    my $my = ($by + $ay) / 2;
    my $mz = ($bz + $az) / 2;

#for printing coord in pdb format
#    printf ("%.3f",$mx); printf ("  %.3f",$my);printf ("  %.3f",$mz); printf ("  1.00 42.00"); print "\n";
    push(@dist, "$mx $my $mz");


    return @dist;
 }



sub usage {
    print STDERR << "EOF";

 -i       : residue frst file with CA x,y,z
 -j       : contact frstration file


EOF
}
