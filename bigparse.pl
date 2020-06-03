#! perl

use 5.010;

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
if($bigfilelist[$a] =~ m/Dir/){
	system("cd $bigfilelist[$a]");
        #declare vars
        my $files = `ls`;
        my @filelist = split('\n',$files);
        #system("python ETE3update.py");


	for my $g (0 ..$#filelist){
                #for any file with COG in its name
                if($filelist[$g] =~ m/BlastResult/){
                        open my $resultfile, $filelist[$g] or die "Problem opening a results file: $!";

                        my @results = ();
                        my @genii = ();
                        my @species = ();
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
                                my $lineage = `python ETE3use.py $txid`;
                                chop $lineage;
                                chop $lineage;
                                my @txds = split (/,/, $lineage);
				my $foo = reverse($txds[0]);
  				chop($foo);
  				$txds[0] = reverse($foo);
				my $genus = "NA";
				my $species = "NA";
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
				$_ = $_ . "\t" . $genus . "\t" . $species;
                        }

                        foreach ( @above60 ){
                                if($addable<10){
                                        if (not ($_ =~ /NA/)){
                                                my @info = split (/\t/, $_);
                                                my @info = split (/\t/, $_);
                                                if (not ( grep( /^$info[-2]$/, @genii ) )) {
                                                        my @info = split (/\t/, $_);
                                                        my $id = $info[1];
                                                        if($id =~ /\|/){
                                                                my @idbreak = split(/\|/,$id);
                                                                $id = $idbreak[1];
                                                        }
                                                        print "Found a result in genus 60: " . $id . "\n";
                                                        push(@results, $id);
                                                        push(@genii,$info[-2]);
                                                        push(@species, $info[-1]);
                                                        $addable++;
                                                }
                                        }
                                }
                        }
                        foreach ( @above60 ){
                                if($addable<10){
                                        if (not ($_ =~ /NA/)){
                                                my @info = split (/\t/, $_);
                                                if (not ( grep( /^$info[-1]$/, @species ) )) {
                                                        my $id = $info[1];
                                                        if($id =~ /\|/){
                                                                my @idbreak = split(/\|/,$id);
                                                                $id = $idbreak[1];
                                                        }
                                                        print "Found a result in species 60: " . $id . "\n";
                                                        push(@results, $id);
                                                        push(@genii,$info[-2]);
                                                        push(@species, $info[-1]);
                                                        $addable++;
                                                }
                                        }
                               }
                        }
                        foreach ( @above60 ){
                                if($addable<10){
                                        if (not ($_ =~ /NA/)){
                                                my @info = split (/\t/, $_);
                                                if (not ( grep( /^$info[-1]$/, @species ) )) {
                                                        my $id = $info[1];
                                                        if($id =~ /\|/){
                                                                my @idbreak = split(/\|/,$id);
                                                                $id = $idbreak[1];
                                                        }
                                                        print "Found a result in species 60: " . $id . "\n";
                                                        push(@results, $id);
                                                        push(@genii,$info[-2]);
                                                        push(@species, $info[-1]);
                                                        $addable++;
                                                }
                                        }
                                }
                        }
                        foreach ( @above60 ){
                                if($addable<10){
                                        my @info = split (/\t/, $_);
                                        my $id = $info[1];
                                                        if($id =~ /\|/){
                                                                my @idbreak = split(/\|/,$id);
                                                                $id = $idbreak[1];
                                                        }
                                        print "Found a result in last chance 60: " . $id . "\n";
                                        push(@results, $id);
                                        push(@genii,$info[-2]);
                                        push(@species, $info[-1]);
                                        $addable++;
                                }
                        }

                        foreach ( @above40 ){
                                my @info = split (/\t/, $_);
                                my $txid = SplitSemi($info[2]);
                                my $lineage = `python ETE3use.py $txid`;
                                chop $lineage;
                                chop $lineage;
                                my @txds = split (/,/, $lineage);
				my $foo = reverse($txds[0]);
  				chop($foo);
  				$txds[0] = reverse($foo);
				my $genus = "NA";
				my $species = "NA";
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
				$_ = $_ . "\t" . $genus . "\t" . $species;
                        }
			
                        foreach ( @above40 ){
                                if($addable<10){
                                        if (not ($_ =~ /NA/)){
                                                my @info = split (/\t/, $_);
                                                if (not ( grep( /^$info[-2]$/, @genii ) )) {
                                                        my @info = split (/\t/, $_);
                                                        my $id = $info[1];
                                                        if($id =~ /\|/){
                                                                my @idbreak = split(/\|/,$id);
                                                                $id = $idbreak[1];
                                                        }
                                                        print "Found a result in genus 40: " . $id . "\n";
                                                        push(@results, $id);
                                                        push(@genii,$info[-2]);
                                                        push(@species, $info[-1]);
                                                        $addable++;
                                                }
                                        }
                                }
                        }
                        foreach ( @above60 ){
                                if($addable<10){
                                        if (not ($_ =~ /NA/)){
                                                my @info = split (/\t/, $_);
                                                if (not ( grep( /^$info[-1]$/, @species ) )) {
                                                        my $id = $info[1];
                                                        if($id =~ /\|/){
                                                                my @idbreak = split(/\|/,$id);
                                                                $id = $idbreak[1];
                                                        }
                                                        print "Found a result in species 40: " . $id . "\n";
                                                        push(@results, $id);
                                                        push(@genii,$info[-2]);
                                                        push(@species, $info[-1]);
                                                        $addable++;
                                                }
                                        }
                                }
                        }

                        foreach ( @above40 ){
                                if($addable<10){
                                                my @info = split (/\t/, $_);
                                                my $id = $info[1];
                                                if($id =~ /\|/){
                                                         my @idbreak = split(/\|/,$id);
                                                         $id = $idbreak[1];
                                                }
                                                print "Found a result in last chance 40: " . $id . "\n";
                                                push(@results, $id);
                                                push(@genii,$info[-2]);
                                                push(@species, $info[-1]);
                                                $addable++;
                                }
                        }
                        my $output = "blastdbcmd -outfmt %f -db " . $dbLoc . " -out " . $filelist[$g] . "Parsed -entry ";

                        foreach(@results){
                                $output = $output . $_. ",";
                        }

                        system($output);
                }
        }
	system("cd ..");
}
}



