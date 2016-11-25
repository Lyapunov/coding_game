#!/usr/bin/perl
use strict;
use warnings;
#use diagnostics;
use 5.20.1;

select(STDOUT); $| = 1; # DO NOT REMOVE

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

my $tokens;

chomp(my $text = <STDIN>);

my $all = "";
($all.=sprintf"%1.8b",ord $_) for (split"", $text);
#print $all;
my ($a,$b) = (1,1);

my %f = (1 => 1);
for (1..16) {
    ($a,$b)=($a+$b,$a);
    $f{$a} = 1;
}
#print join(",",sort keys %f);
my $z = 0;
my $q= 0;
#print $all;
for ( split"",$all) {
   if ($_ == 1 && $f{$z} ){
       $q++;
   }
   $z++;
}
print $q;
