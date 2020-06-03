#! perl

use 5.010;

use strict;
use warnings;


my @args = @ARGV;
my $bigfiles = `ls`;
my @bigfilelist = split('\n',$bigfiles);
my $dbLoc = '';
my $loc = `pwd`;
chomp $loc;
for my $c (0..$#bigfilelist){
        if($bigfilelist[$c] =~ m/dbLoc/){
		# get the location of a database from any file that has dbLoc anywhere in its name
		$dbLoc = Slurp($bigfilelist[$c]);
		chomp $dbLoc;
	}
}

for my $a (0 ..$#bigfilelist){
	if($bigfilelist[$a] =~ m/Parsed/){
		my ($txid) = $bigfilelist[$a] =~ /\_(\d+)\_/;
		my $lineage = `python ETE3use.py $txid`;
                chop $lineage;
                chop $lineage;
                my @txds = split (/,/, $lineage);
		my $foo = reverse($txds[0]);
  		chop($foo);
  		$txds[0] = reverse($foo);
		my $superphyla = `python ETE3use3.py $txds[-1]`;
		my ($smallsuperphyla) = $superphyla =~ /\'(.+)\'/;
		if($smallsuperphyla =~ /(.+\ [g])/){
			my ($temp) = $smallsuperphyla =~ /(.+\ [g])/;
			chop $temp;
			chop $temp;
			$smallsuperphyla = $temp;
		}
		 if($smallsuperphyla =~ /(.+\/)/){
                        my ($temp) = $smallsuperphyla =~ /(.+\/)/;
                        chop $temp;
                        $smallsuperphyla = $temp;
                }
		print $smallsuperphyla . "\n";
		my $superkingdom = `python ETE3use3.py $txds[2]`;
		my ($smallsuperkingdom) = $superkingdom =~ /\'(.+)\'/;
                print $smallsuperkingdom . "\n";		
		my ($pretro) = $bigfilelist[$a] =~ /(.+\.)/;
		chop $pretro;
		my $final = $pretro . "_" . $smallsuperkingdom . "_" . $smallsuperphyla . "_" . "BlastResultParsed";
		print $final . "\n";	
		my $cmd = "mv " . $bigfilelist[$a] . " " . $final;
		system($cmd);
	}
}
