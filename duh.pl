#!/usr/bin/perl -w
use strict;

print "Case ID,Gender,Has Mutation,Expression,CNV,Days to Death,Variant Classification,disease,gene\n";

while(<>){
    my ($disease, $gene,) = split(/ /);
    open CSVFILE, "< $_" or die "can't open datafile: $!";
    while(<CSVFILE>){
	chomp;
	next if /Case ID/;
	print "$_,$disease,$gene\n";
    }
}
