#! perl

use 5.010;

use strict;
use warnings;


my @args = @ARGV;

open my $file, "Combined-EGGNOGgroupsUNIREF-withENZ-LEN-TAX-Corrected13June2019-AppendedCofactors-Clusters-All.csv" or die "Problem opening Combined File: $!";
open( my $outfile , '>', "Combined-EGGNOGgroupsUNIREF-withENZ-LEN-TAX-Corrected13June2019-AppendedCofactors-Clusters-All-LucaPediaed.csv") or die "Counldnt open :$!";

while (defined(my $line = <$file>)){
	my @combined = split( ',', $line);
	my @unirefs = split( /\|/, $combined[0]);
	my $luca = "";
	my $total = 0;
	my @lucaNums = (0,0,0,0,0,0,0,0);
	 
	foreach (@unirefs){
		my $temp = "";
		$temp = `grep '$_' LucaPedia-PresentOnly_GOTermsRef_ProtFams_GOTermsAllRev.csv`;
		if (not $temp eq ""){
			my @broken = split( ',' , $temp);
			$luca = $luca . $broken[9] . "|";
			$total += $broken[9];
			for (my $i = 0; $i < 8 ;$i++){
				if(($lucaNums[$i] == 0) and ($broken[$i+1] =~ /\+/)) {
					$lucaNums[$i] = 1;
				}
			}
		}
		else{
			$luca = $luca . "0|";
		}
	}
	my $aggregate = 0;
	for(my $i = 0; $i <8 ; $i++){
		$aggregate += $lucaNums[$i];
	}
	if (not $luca eq ""){
		print $outfile ($line . ",". $aggregate ."," . $total ."," . $total/(0 + @unirefs) . "\n");
	}
}
