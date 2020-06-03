#! perl

use 5.010;

use strict;
use warnings;

my @args = @ARGV;
my $inseq = Bio::SeqIO->new(-file   => "test.dat",
                            -format => "swiss", );
my $seqout = Bio::SeqIO->new( -file   => ">test.fsa",
                              -format => 'Fasta',
                            );
my $manager = Parallel::ForkManager->new(10);

ACCNUM:	
while (my $seq = $inseq->next_seq) {
   $manager->start and next ACCNUM;
   $seqout->write_seq($seq);
   $manager->finish;
}
$manager->wait_all_children;
