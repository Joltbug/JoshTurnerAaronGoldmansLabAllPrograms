#! perl

use 5.010;

use strict;
use warnings;
use threads;

my @args = @ARGV;

#to run use pearl LucaSearch.pl nameofsearchinputfile nameofoutputfile nameoflucapediafile
#the input  file cannot be the same as the output file
sub searchLuca{ 
	
	my @uniref = @_; 
	my $done = 0;	
	my $inStudy = "";
	#declare variables, and take in any arguments

	open my $lucaPedia, $args[2] or die "Problem opening the searchfile :$!";
	#open the given lucapedia file

	#this loop searches the lucapedia file for the uniref# given
	while (defined(my $luca = <$lucaPedia>) and (not $done)){
		my @terms = split /\t/ , $luca;
		if ($uniref[0] eq $terms[0]){
			#tell the loop its done then check the 8 studies to see which include it
			$done ++;
			for my $c (1 .. $#terms){
				if($terms[$c] eq "+"){ $inStudy = $inStudy . "1";}
				if($terms[$c] eq "-"){ $inStudy = $inStudy . "0";}
				if($terms[$c] eq "-\n"){ $inStudy = $inStudy . "0";}
			}
		}	 
	}
	if(not $done){ $inStudy = "00000000";}
	# if you did not find the number use the default then return
	return "$uniref[0]($inStudy)";
}


open my $toSearch, $args[0] or die "Problem opening the searchedfile :$!";
open my $output, '>', $args[1] or die "Problem opening the outputfile :$!";

while (defined(my $line = <$toSearch>)){
	async {
	my @words = split /,/ , $line;
	my @refs = split /\|/ , $words[0];
	my $pipe =0;
	foreach my $a (@refs){
		if($a eq "Uniref50"){
			#if the line is the header line output our own header
			print $output "UnirRef50_#######(Harris Mirkin Delaye Yang Wang Srinivasan Ranea Weiss)"
			
		}
		else{
			if($pipe){ print $output "|";}
			print $output searchLuca($a);	
			$pipe++;
		}		
	}
	for my $b (1 .. $#words){
		#output the rest of the information on the line
		print $output ",$words[$b]";
	}
	}
}
$_->join() for threads->list;
(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst) = localtime();
die "process finished at $hour:$min:$sec";

