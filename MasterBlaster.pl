#! perl

use 5.010;

use lib '/home/students/jturner2/bioperl-live/lib';
#use lib '/home/students/jturner2/Parallel-ForkManager-2.02/lib';
#use lib '/home/students/jturner2/Moo-2.003004/lib';
#use lib '/home/students/jturner2/Module-Runtime-0.016/lib';

use strict;
use warnings;
use Bio::SeqIO;
use Parallel::ForkManager;

my @args = @ARGV;

my $manager = Parallel::ForkManager->new(10);

my $inseq = Bio::SeqIO->new(-file   => "uniprot_trembl.dat",-format => "swiss", );

open my $metalfile, "Combined-EGGNOGgroupsUNIREF-withENZ-LEN-TAX-Corrected13June2019-AppendedCofactors-Clusters-All.csv" or die "Problem opening the spreadfile: $!";

my %Accs;

while (defined(my $line = <$metalfile>)){
	my @info = split(/\,/, $line);
	my @members = split(/\|/, $info[13]);	
	for my $g (0 .. $#members){
		my ($SwissAcc) = $members[$g] =~ /(\A[^\)\]]*\()/;
		chop $SwissAcc;
		my $suffix = $info[-1];
		chop $suffix;
		$suffix = $suffix . $info[-2];
		$Accs{$SwissAcc} = $suffix;
		print $SwissAcc . " : " . $Accs{$SwissAcc} . "\n"; 
	}
}

$Accs{"Q6GZX4"} = "Test";
$Accs{"Q6GZX3"} = "Test";
$Accs{"Q197F8"} = "Test";

ACCNUM:
while (my $seq = $inseq->next_seq) {
	$manager->start and next ACCNUM;
	if (exists($Accs{$seq->accession_number()})){
		my $seqout = Bio::SeqIO->new( -file => ">" .$Accs{$seq->accession_number()} . "_" .$seq->accession_number() . ".fsa", -format => 'Fasta',);
		$seqout->write_seq($seq);
		print $seq->accession_number() . " Found one\n";
	}
	$manager->finish;
}

$manager->wait_all_children;

my $files = `ls`;
my @filelist = split('\n',$files);
my $loc = `pwd`;
chomp $loc;

for my $g (0 ..$#filelist){
	#for any file with COG in its name
        if($filelist[$g] =~ m/\.fsa/){
		my $EBlast = "blastp -outfmt \"6 sseqid qcovs bitscore evalue sstart send \" -max_target_seqs 1 -db " . $loc . "/E_Coli -out " . $filelist[$g]. "Eresult -query " . $filelist[$g];
		my $HaloBlast = "blastp -outfmt \"6 sseqid qcovs bitscore evalue sstart send \" -max_target_seqs 1 -db " . $loc . "/Halorubrum_Aidingense -out " . $filelist[$g]. "Hresult -query " . $filelist[$g]; 
		print $EBlast . "\n";
                print $HaloBlast . "\n";
		system($HaloBlast);
		system($EBlast); 
	}
}

