#! perl

use 5.010;

use strict;
use warnings;


my @args = @ARGV;

my $bigfiles = `ls`;
my @filelist = split('\n',$bigfiles);
my $loc = `pwd`;

open my $infile ,"names.txt" or die "problem opening names: $!";

for my $a (0 ..$#filelist){
        if($filelist[$a] =~ m/BlastResultParsed/){
		while (defined(my $line = <$infile>)){
			chop $line;
			if($filelist[$a] =~ $line){
				system("rm $filelist[$a]");
			}
		}
	}
}
