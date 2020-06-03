#! perl

#use 5.010;

use strict;
use warnings;


my @args = @ARGV;

sub Slurp{
	#this method converts an entire file into one string, including new lines
        my $filename =  $_[0];
        my $out = '';
        open my $file, $filename or die "Problem opening a Slurp File: $!";
        while (defined(my $line = <$file>)){
                $out = $out . $line;
        }
	return $out;
}

sub SplitSemi{
	my $str = $_[0];
        my @split = split (/;/, $str);
        return $split[0];
}

        #declare vars
        my $files = `ls`;
        my @filelist = split('\n',$files);
        my $dbLoc = '';
        my $loc = `pwd`;
        chomp $loc;
        system("python ETE3update.py");

        print(not (1));

        for my $c (0..$#filelist){
                if($filelist[$c] =~ m/dbLoc/){
                        # get the location of a database from any file that has dbLoc anywhere in its name
                        $dbLoc = Slurp($filelist[$c]);
                        chomp $dbLoc;
                }
        }

	for my $g (0 ..$#filelist){
                #for any file with BlastResult in its name
                if($filelist[$g] =~ m/BlastResult/){
                        open my $resultfile, $filelist[$g] or die "Problem opening a results file: $!";

		
		my %results;
		my %genii;
		my %species;
		my $addable = 0;
		my @above60 = ();
                my @above40 = ();
		
		while (defined(my $line = <$resultfile>)){
                                my @info = split (/\t/, $line);
                                my $id = $info[1];
                                if($id =~ /\|/){
                                        my @idbreak = split(/\|/,$id);
                                        $id = $idbreak[1];
                                }
                                my $dbcmd = "blastdbcmd -outfmt %l -db " . $dbLoc . " -entry " . $id;
                                my $tlength = `$dbcmd`;
                                my $tcovs = $info[-1] / $tlength * 100;
                               if(($tcovs>=60.0) && $info[0] >= 60.0 ){
                                        push(@above60,$line);
                                }
                                if(($tcovs>=40.0) && $info[0] >= 40.0 ){
                                        push(@above40,$line);
                                }
                }

		print "Above 60 : " . @above60 . "\n";
                        foreach ( @above60 ){
                                my @info = split (/\t/, $_);
                                my $txid = SplitSemi($info[2]);
                                print "Checking : " . $info[1]. "\n";
                                my $lineage = `python ETE3use.py $txid`;
                                chop $lineage;
                                chop $lineage;
                                my @txds = split (/,/, $lineage);
                                my $foo = reverse($txds[0]);
                                chop($foo);
                                $txds[0] = reverse($foo);
                                my $genus = "NA";
                                my $species = "NA";
				my $id = $_;
				if($id =~ /\|/){
                                	my @idbreak = split(/\|/,$id);
                                	$id = $idbreak[1];
                                }
                                foreach(@txds){
                                        my $rnk = "python ETE3use2.py " . $_;
                                        my $ranking = `$rnk`;
                                        if($ranking =~ /genus/){
                                                $genus = $_;
                                        }
                                }
                                foreach(@txds){
                                        my $rnk = "python ETE3use2.py " . $_;
                                        my $ranking = `$rnk`;
                                        if($ranking =~ /species/){
                                                $species = $_;
                                        }
                                }
                                $_ = $id . "\t" . $genus . "\t" . $species;
                        }
		foreach ( @above60 ){
                        if($addable<10){
				if (not ($_ =~ /NA/)){
					my @info = split (/\t/, $_);
					if(not(exists($results{$info[1]}))){
						if(not(exists($genii{$info[2]}))){
							print "Result found in 60 genii: " . $info[0] . "\n";
							$addable = $addable + 1;
							$results{$info[0]} = $info[0];
							$genii{$info[1]} = $info[1];
							$species{$info[2]} = $info[2];
						}
					}
				}
			}
		}
		foreach ( @above60 ){
                        if($addable<10){
				if (not ($_ =~ /NA/)){
					my @info = split (/\t/, $_);
					if(not(exists($results{$info[1]}))){
						if(not(exists($species{$info[3]}))){
							print "Result found in 60 species: " . $info[0] . "\n";
							$addable = $addable + 1;
							$results{$info[0]} = $info[0];
							$genii{$info[1]} = $info[1];
							$species{$info[2]} = $info[2];
						}
					}
				}
			}
		}
		foreach ( @above60 ){
                        if($addable<10){
				if (not ($_ =~ /NA/)){
					my @info = split (/\t/, $_);
					if(not(exists($results{$info[1]}))){
							print "Result found in 60 last resort: " . $info[0] . "\n";
							$addable = $addable + 1;
							$results{$info[0]} = $info[0];
							$genii{$info[1]} = $info[1];
							$species{$info[2]} = $info[2];
					}
				}
			}
		}
		
		print "Above 40 : " . @above40 . "\n";
                        foreach ( @above40 ){
                                my @info = split (/\t/, $_);
                                my $txid = SplitSemi($info[2]);
                                print "Checking : " . $info[1]. "\n";
                                my $lineage = `python ETE3use.py $txid`;
                                chop $lineage;
                                chop $lineage;
                                my @txds = split (/,/, $lineage);
                                my $foo = reverse($txds[0]);
                                chop($foo);
                                $txds[0] = reverse($foo);
                                my $genus = "NA";
                                my $species = "NA";
				my $id = $_;
				if($id =~ /\|/){
                                	my @idbreak = split(/\|/,$id);
                                	$id = $idbreak[1];
                                }
                                foreach(@txds){
                                        my $rnk = "python ETE3use2.py " . $_;
                                        my $ranking = `$rnk`;
                                        if($ranking =~ /genus/){
                                                $genus = $_;
                                        }
                                }
                                foreach(@txds){
                                        my $rnk = "python ETE3use2.py " . $_;
                                        my $ranking = `$rnk`;
                                        if($ranking =~ /species/){
                                                $species = $_;
                                        }
                                }
                                $_ = $id . "\t" . $genus . "\t" . $species;
                        }
		foreach ( @above40 ){
                        if($addable<10){
				if (not ($_ =~ /NA/)){
					my @info = split (/\t/, $_);
					if(not(exists($results{$info[1]}))){
						if(not(exists($genii{$info[2]}))){
							print "Result found in 40 genii: " . $info[0] . "\n";
							$addable = $addable + 1;
							$results{$info[0]} = $info[0];
							$genii{$info[1]} = $info[1];
							$species{$info[2]} = $info[2];
						}
					}
				}
			}
		}
		foreach ( @above40 ){
                        if($addable<10){
				if (not ($_ =~ /NA/)){
					my @info = split (/\t/, $_);
					if(not(exists($results{$info[1]}))){
						if(not(exists($species{$info[2]}))){
							print "Result found in 40 species: " . $info[0] . "\n";
							$addable = $addable + 1;
							$results{$info[0]} = $info[0];
							$genii{$info[1]} = $info[1];
							$species{$info[2]} = $info[2];
						}
					}
				}
			}
		}
		foreach ( @above40 ){
                        if($addable<10){
				if (not ($_ =~ /NA/)){
					my @info = split (/\t/, $_);
					if(not(exists($results{$info[1]}))){
							print "Result found in 40 last resort: " . $info[0] . "\n";
							$addable = $addable + 1;
							$results{$info[0]} = $info[0];
							$genii{$info[1]} = $info[1];
							$species{$info[2]} = $info[2];
					}
				}
			}
		}
		
		my $output = "blastdbcmd -outfmt %f -db " . $dbLoc . " -out " . $filelist[$g] . "Parsed -entry ";

                foreach my $key (keys %results){
                	print $results{$key} ."\n";
                        $output = $output . $results{$key} . ",";
                }

                system($output);

		}
	}
		

