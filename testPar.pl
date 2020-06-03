#! perl

use 5.010;

use strict;
use warnings;
use Parallel::ForkManager;

my @args = @ARGV;
my $manager = Parallel::ForkManager->new(10);

open( my $outfile , '>', "test.out") or die "couldn't open the	testfile $!";


ACCNUM:	
for (0 .. 1000000) {
  	 $manager->start and next ACCNUM;
	 my $result = 2 * $_;
	 print $outfile ($result . "\n"); 
	 $manager->finish;
}
$manager->wait_all_children;
