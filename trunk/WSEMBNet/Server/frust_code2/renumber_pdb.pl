#!/usr/bin/perl -w
# 9 June 98

# We have a file of PDB coordinates, but the atom or residue
# numbering needs fixing.
# We can then add (a possibly negative) offset to both the
# atom and residue fields of the file.

# Typically, we have some coordinates, but they are part of a
# larger structure, so we need to add an amount to both atom
# and residue numbers.

# Anything that is not an "ATOM" line is passed through
# un-mangled.

# rscid = $Id: renum_pdb.pl,v 1.1 1998/06/09 07:03:53 torda Exp $;

my $usage =
"usage: $0 infile outfile residue_offset [atom_offset]
       If infile or outfile is \"-\", then standard input/output is used\n";


#-------------------- fix_line     --------------------
# Given a PDB format ATOM record, add the offsets to
# the residue and atom fields.
# Normally, we would not like to use fixed parts of the
# line, but the whole point of the PDB format is that we are given:
# 
#ATOM     16  CE2 TRP     3      38.345  52.570  77.328  1.00 13.82           C
# and that columns 7-11 have the atom number and 23-26 the residue sequence
# number

sub fix_line {
    my $lref = shift;
    my $res_off = shift;
    my $at_off = shift;
    local ($ress);
    $ress = substr ($$lref, 22, 4);

        
    if ($res_off != 0) {
	my $x = $ress + $res_off;
	substr($$lref, 22, 4) = sprintf ("%4d", $x);
    }

    
    if ($at_off != 0) {
	my $ats = substr ($$lref, 6, 5);
	my $x = $ats + $at_off;
	substr ($$lref, 6, 5) = sprintf ("%5d", $x);
    }
}

#-------------------- main         --------------------
main {
    if ($#ARGV < 2) {
	local $a = $#ARGV + 1;
	print STDERR "Wrong number of args ($a)\n";
	die $usage; }
    my ($infile, $outfile, $res_off, $at_off);
    $infile = shift ; $outfile = shift; $res_off = shift;
    $at_off = 0;
    if (defined $ARGV[0]) {
	$at_off = shift }
    my ($inref, $outref);
    if ($infile eq '-') {
	$inref = \*STDIN;
    } else {
	open (INFILE, "<$infile") || die "Open fail on $infile. Stopping ";
	$inref = \*INFILE;
    }

    if ($outfile eq '-') {
	$outref = \*STDOUT;
    } else {
	open (OUTFILE, ">$outfile")
	    || die "Open fail on $outfile for writing. Stopping";
	$outref = \*OUTFILE;
    
#this is al pedo . but in the original script was outside this else and it beders when output is stdout
        print "Copying from $infile to $outfile, adding $res_off to every residue";
        if ($res_off != 0) {
	   print " and $at_off to every atom number\n" }
        else {
	   print ''; }
    }
    my $line;
    while (defined ($line = <$inref>)) {
	if (  ($line =~ /^ATOM/) ) {
            fix_line (\$line, $res_off, $at_off); } 
	print $outref $line;
    }

    exit 0;
}
