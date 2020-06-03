#! perl

use 5.010;

use strict;
use warnings;


my @args = @ARGV;

my $bigfiles = `ls`;
my @filelist = split('\n',$bigfiles);
my $loc = `pwd`;
open( my $outfile , '>', "Combined-EGGNOGgroupsUNIREF-withENZ-LEN-TAX-Corrected13June2019-AppendedCofactors-Clusters-All.csv") or die "Counldnt open :$!";
print $outfile "working \n";
chomp $loc;
my @Fullout;

for my $a (0 ..$#filelist){
	if($filelist[$a] =~ m/AppendedCofactors/){
		open my $spreadfile, $filelist[$a] or die "Problem opening the spreadfile: $!";
		my ($metal) = $filelist[$a] =~ /(\w+\.)/;
		chop $metal;
		my ($protName) = $filelist[$a] =~ /(with[^E]\w+)/;
		print $metal ."\n";
		print $protName . "\n";
		while (defined(my $line = <$spreadfile>)){
                	my @info = split (/\,/, $line);
			if (not ( grep( /^$info[2]$/, @Fullout ) )) {
				push(@Fullout,$info[2]);
				chop $line;
				print $outfile ($line . "," . $metal . "," . $protName ."\n");
			}
		}
	}
}
close $outfile;


