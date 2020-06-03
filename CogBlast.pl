#! perl

use 5.010;

use strict;
use warnings;


my @args = @ARGV;

sub Slurp{
	my $filename =  $_[0];
	my $out = '';
	open my $file, $filename or die "Problem opening a Slurp File: $!";
	while (defined(my $line = <$file>)){
		$out = $out . $line;
	}
	return $out;
}
sub AntiNew{
	my @arr = $_[0];
	for my $a (0..$#_){
		chomp $_[$a];	
	}
}

        my $files = `ls`;
        my @filelist = split('\n',$files);
        my $AQuery = '';
        my $BQuery = '';
        my $EQuery = '';
        my $CogName = '';
        my $dbLoc = '';
	my $loc = `pwd`;
	chomp $loc;
        my @ArchaeaTaxids;
        my @BacteriaTaxids;
        my @EukaryaTaxids;

        for my $c (0..$#filelist){
                if($filelist[$c] =~ m/dbLoc/){
                        $dbLoc = Slurp($filelist[$c]);
                        chomp $dbLoc;
                }
                if($filelist[$c] =~ m/ArchaeaTaxids/){
                        my $TempArch = Slurp($filelist[$c]);
                        @ArchaeaTaxids = split('\n',$TempArch);
			AntiNew(@ArchaeaTaxids);
                }
                if($filelist[$c] =~ m/BacteriaTaxids/){
                        my $TempBac = Slurp($filelist[$c]);
                        @BacteriaTaxids = split('\n',$TempBac);
                        AntiNew(@BacteriaTaxids);
                }
                if($filelist[$c] =~ m/EukaryaTaxids/){
                        my $TempEu = Slurp($filelist[$c]);
                        @EukaryaTaxids = split('\n',$TempEu);
                        AntiNew(@EukaryaTaxids);
                }
        }


	for my $g (0 ..$#filelist){
                if($filelist[$g] =~ m/COG/){
                        $CogName = $filelist[$g];
                        system("mkdir Dir_$CogName");
			system("chmod 777 Dir_$CogName");
			open my $COGFile, $filelist[$g] or die "Problem opening a COGFile: $!";
                        my $counter = 0;
                        while (defined(my $line = <$COGFile>)){
                                if ($counter == 0){
					print $line;
					chomp $line;
                                        my $out = $loc . '/Dir_'. $CogName . '/ArchaeaQuery';
					my $blastdbcmd = '-outfmt %f -db ' . $dbLoc . ' -entry ' . $line . ' -out ' . $out;
                                    	system("blastdbcmd $blastdbcmd");
                                        $counter ++;
                                }
                                elsif ($counter == 1){
					print $line;
					chomp $line;
                                        my $out = $loc . '/Dir_'. $CogName . '/BacteriaQuery';
                                        my $blastdbcmd = '-outfmt %f -db ' . $dbLoc . ' -entry ' . $line . ' -out ' . $out;
                                        system("blastdbcmd $blastdbcmd");
                                        $counter ++;
                                }
                                elsif ($counter == 2){
					print $line;
					chomp $line;
                                        my $out = $loc . '/Dir_'. $CogName . '/EukaryaQuery';		
                                        my $blastdbcmd = '-outfmt %f -db ' . $dbLoc . ' -entry ' . $line . ' -out ' . $out;
                                        system("blastdbcmd $blastdbcmd");
                                        $counter ++;
                                }
                        }		
			
			for my $d(0..$#ArchaeaTaxids){
				print "\"" . $ArchaeaTaxids[$d] . "\" \n" ;
                                my $out = $loc . '/Dir_' . $CogName . '/' . $CogName . '_' . $ArchaeaTaxids[$d] . '_BlastResult';
                                my $query = $loc . '/Dir_' . $CogName . '/ArchaeaQuery';
				my $blast =  '-query ' .$query. ' -db ' . $dbLoc . ' -out ' . $out . " -outfmt \"6 qcovs sseqid staxids pident length\" -max_target_seqs 100 -evalue 10e-3 -word_size 6 -taxidlist " .$ArchaeaTaxids[$d].'.txds';
				print $blast . "\n";
                                system("blastp $blast");
                        }

			 for my $e(0..$#BacteriaTaxids){
				# go through all the Bacteria taxids and blast the query into them
                                print "\"" . $BacteriaTaxids[$e] . "\"";
                                my $out = $loc . '/Dir_' . $CogName . '/' . $CogName . '_' . $BacteriaTaxids[$e] . '_BlastResult';
                                my $query = $loc . '/Dir_' . $CogName . '/BacteriaQuery';
                                my $blast =  '-query ' .$query. ' -db ' . $dbLoc . ' -out ' . $out . " -outfmt \"6 qcovs sseqid staxids pident length\" -max_target_seqs 100 -evalue 10e-3 -word_size 6 -taxidlist " .$BacteriaTaxids[$e]. '.txds';
                               	print $blast . "\n";
                                system("blastp $blast");
                        }

                        for my $f(0..$#EukaryaTaxids){
				print "\"" . $EukaryaTaxids[$f] . "\"\n";
                                my $out = $loc . '/Dir_' . $CogName . '/' . $CogName . '_' . $EukaryaTaxids[$f] . '_BlastResult';
                                my $query = $loc . '/Dir_' . $CogName . '/EukaryaQuery';
				my $blast =  '-query ' .$query. ' -db ' . $dbLoc . ' -out ' . $out . " -outfmt \"6 qcovs sseqid staxids pident length\" -max_target_seqs 100 -evalue 10e-3 -word_size 6 -taxidlist " .$EukaryaTaxids[$f]. '.txds';
				print $blast . "\n";
                                system("blastp $blast");
                        }

                        print $CogName . ' Done blasting' . "\n";


                }
        }


