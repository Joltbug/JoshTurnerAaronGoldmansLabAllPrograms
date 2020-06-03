#! perl

use 5.010;

use strict;
use warnings;


my @args = @ARGV;
				
for my $a(5..1000000){
	print "\" trying taxid:" . $a . "\" \n";
        my $putinf = 'echo '. $a . ' > tax';
	system("$putinf");
	my $out = 'Taxid:' . $a . 'test';
	my $blast =  '-query /home/students/jturner2/NCBI/NR/HomoTest  -db /home/students/jturner2/NewNR/nr_v5 -out ' . $out . " -outfmt \"6 qcovs sseqid sscinames\" -max_target_seqs 100 -evalue 10e-3 -word_size 6 -taxidlist tax";
        print $blast . "\n";
        system("blastp $blast");
        system("rm tax");
}
