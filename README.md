# JoshTurnerAaronGoldmansLabAllPrograms
This is a repository of all of the programs that I have written while in Aaron's lab, including methods of use, original purpose, and any other info. Note that many of these are incredibly specific, and thus may be more helpful as a jumping off point rather than simply using them. I have included pbs scripts if they have a greater function than simply running a program or downloading information.

JOSH TURNER - AARON GOLDMAN'S LAB - ALL PROGRAMS DOCUMENTATION

	This is a guide to all of the programs that I have written while in Aaron's lab, including methods of use, original purpose, and any other info. Note that many of these are incredibly specific, and thus may be more helpful as a jumping off point rather than simply using them. I have included pbs scripts if they have a greater function than simply running a program or downloading information.

Contents:

GENERAL/UNCATEGORIZED:
bigparse.pl
check.pl
combine.pl
dubcheck.py
Hammer.pl
hammeraudit.py - come back to 
LucaAdd.pl
LucaSearch.pl
MasterBlaster.pl
ParallelLucaSearch.pl
ParalleSwisprotReadinTest.pl
split.pbs
submit.sh
success.py
testPar.pl



SUPER PHYLA BLASTING AND PARSING:
basicParser.cpp
basicParserv1.1.cpp
CogBlast.pl
ComplexParser.cpp
ETE3update.py
ETE3use2.py
ETE3use.py
ETE3use3.py
FINALPIPELINE.pbs
parse.pl
rename.pl
ReplaceTaxIDsBLASTwithGenusSpecies.py



RELATED TO BUILDING BLAST DBS:
*_Genomic.py
*_Mitochondrion.py
*_Plastid.py
Make*Db.sh
Parse_Accessions2Taxid_*.py


DOCUMENTATION BEGINS:

GENERAL/UNCATEGORIZED:

bigparse.pl
	This is an unfinished program which was intended to be able to parse any numeber of blast results if they were in COG folders in the directory from which it was run, this was to avoid having to run parse.pl from the command line from within these cog folders. 
	IT DOES NOT FUNCTION
	If you are able to write perl well, and feel like you want to look at this mess, by all means have a go at making it work
	This program would attempt to run a similar subprogram to parse.pl from within any directory That has "Dir" anywhere in its name

check.pl
	This program looks for an input file names.txt and tries to delete any files that are listed in it, by line, and have BlastResultParsed in the name
	This can be modified to be any string required
	This program was originally used to remove erroneous results from a parse after a mistake in testing it

combine.pl
	This program takes any amount of csvs containing the words AppendedCofactors, in the format and prints them to an outfile, hardcoded, with no duplicates in the 3 column
	It also appends the metal and protein from the originating AppendedCofactors file to the line
	ex: Combined-EGGNOGgroupsUNIREF-withENZ-LEN-TAX-Corrected13June2019-AppendedCofactors-Clusters-Zinc-ATP.csv would append zinc,ATP
	This was designed to work on files sent by AJ with names similar to the example

dubcheck.py
	This program, written by AJ not me, looks for all non .py files in a directory and checks to see if there are any duplicate fasta entries in a given file, if there is it will print it out

hammeraudit.py
	This program looks for all files that have size greater than 0 and then prints out their names and the rank according to NCBI of the name

Hammer.pl
	This program will take the file HomoTest, and then blast it against every single taxid from 5 to 1000000
	It was designed to run in tandem with hammeraudit, as a means of brute force testing the new taxid search in blast v5
	This did work but man was it slightly silly

LucaAdd.pl
	This program takes a metal cofactor csv file and a specially modified lucapedia file and meshes them appending to each line a total number of times each uniref in an eggnog family appears in the 8 lucapedia studies, a non duplicate number of how many of the 8 the line appears in and an average lucapedia appearances per Uniref member
	This program is designed to work on Combined-EGGNOGgroupsUNIREF-withENZ-LEN-TAX-Corrected13June2019-AppendedCofactors-Clusters-All.csv and LucaPedia-PresentOnly_GOTermsRef_ProtFams_GOTermsAllRev.csv as the lucapedia file

LucaSearch.pl
	to run this program use "pearl LucaSearch.pl nameofsearchinputfile nameofoutputfile nameoflucapediafile"
	the input  file cannot be the same as the output file
	This program looks for all the unirefclusters in the search file in lucapedia and then puts a sequence of 8 0s, +s, or -s, for the studies in which the uniref appear
	order of program is UnirRef50_#######(Harris Mirkin Delaye Yang Wang Srinivasan Ranea Weiss)
	ex: UnirRef50_A01920(+-++-+++)

MasterBlaster.pl
	This program goes through uniprot_trembl.dat and a Metal Cofactor csv file, pulls out any trembl sequences that are in the csv and makes fasta files of them, and then it blasts them into halorubrum and E.coli
	It does all this in parallel, but due to the size of trembl takes ages; as of writing this program has been running for 9713 hours in computing time or roughly 2 months real time, and assuming it was linear speed, it is hypothesized to take 2 full years real time to finish
	Requires Parallel::ForkManager and Bio::SeqIO

ParallelLucaSearch.pl
	This program does the same thing as LucaSearch.pl but in parallel
	it never quite lived up to expectations but is slightly faster
	to run this program use "pearl LucaSearch.pl nameofsearchinputfile nameofoutputfile nameoflucapediafile"
	the input  file cannot be the same as the output file
	This program looks for all the unirefclusters in the search file in lucapedia and then puts a sequence of 8 0s, +s, or -s, for the studies in which the uniref appear
	order of program is UnirRef50_#######(Harris Mirkin Delaye Yang Wang Srinivasan Ranea Weiss)
	ex: UnirRef50_A01920(+-++-+++)

ParalleSwisprotReadinTest.pl
	A predecessor to the MasterBlaster.pl script, it reads in a swissprot format file swiss.dat and outputs all entries in it in fasta format, in parallel

split.pbs
	This program will split a trembl.dat file into manageable 567468 line chunks, so that one can compute over them

submit.sh
	This program outputs to the stdout a list of qsub commands for all parse.pbs files that are in any subdirectory of the current directory.
	This can be copied and pasted into the command line to submit all of them
	This program is helpful when submitting parses after running CogBlast.pl
	In general it is a good base to create semi auto submittal of large amounts of qsubs, if you change the echo  "qsub $elem"/parse.pbs line to whatever qsubs you are attempting to submit


success.py
	A nonsense program to test if jobs are submitting or python is working, will infintely print 1

testPar.pl
	A basic test of the Parallel::ForkManager library, which will print 2* n for all n < 1000000 to a single outfile. This can be modified to encompass all types of parallel computing.


	


SUPER PHYLA BLASTING AND PARSING:

basicParser.cpp
basicParserv1.1.cpp
	These parsers take in a single blast result and select 10 results, trying to have different species first, then genera, then the top 10 in sort result
	the input file must be changed in the code, as is the output, and the blast results must be in the outfmt "6 qcovs sseqid sscinames"
	These programs are directly inferior to ComplexParser.cpp, which itself is directly inferior to parse.pl

CogBlast.pl
	This program blasts a large amount of information according to certain guidelines
	This program requires BLAST v5 2.9.0 to be installed, no guarantees on newer versions and a v5 database
	This program will look for certain files in the directory as base input:
		dbLoc = any file with dbLoc in the name, this gives the location of the local blast NRv5 database as the first and only line in the file
		ArchaeaTaxids = any file with ArchaeaTaxids in the name, this is a list of all taxids to be used as categories for blasting, such as superphyla or phyla, into which the Archaea query will be blasted, one per line
		BacteriaTaxids = any file with BacteriaTaxids in the name, this is a list of all taxids to be used as categories for blasting, such as superphyla or phyla, into which the bacteria query will be blasted, one per line
		EukaryaTaxids = any file with EukaryaTaxids in the name, this is a list of all taxids to be used as categories for blasting, such as superphyla or phyla, into which the Eukarya query will be blasted, one per line
	It will also take any number of files with COG in the name as input in the format: 
		ArchaeaQuerySeqAccesionID
		BacteriaQuerySeqAccesionID
		EukaryaQuerySeqAccesionID
	This program will create a directory for each COG file, into which it will put the results of taxid blasts as follows in outfmt "6 qcovs sseqid staxids pident length":
		The Archaea Query Seq into all ArchaeaTaxids
		The Bacteria Query Seq into all BacteriaTaxids 
		The Eukarya Query Seq into all EukaryaTaxids 
	This program must be able to read write and execute in the directory in which it was run

ComplexParser.cpp
	This parser runs in much the same matter as the two basicParser.ccp programs, but over a hardcoded array of files
	This parser takes in files, and tries to select 10 results, trying to have different species first, then genera, then the top 10 in sort result
	the input files must be changed in the code, as is the output, and the blast results must be in the outfmt "6 qcovs sseqid sscinames"
	Naming convention for input data COG####_SuperFamily_SuperPhyla_BlastResults
	Naming convention for COG####_SuperFamily_SuperPhyla_verboseSelection
	SuperPhylya is one of Archea, Bacteria, eukaryota, mitochondrion, or plastid
	SuperPhyla can be recipblast which meant searching the archea sequence in bacteria and vice versa
	This program is directly inferior to parse.pl


ETE3update.py
	This program will update the ETE3 module for python.

ETE3use.py
	This helper program for parse.pl will take one argument, a taxid, and print the taxid lineage of that taxid according to NCBI, requires ETE3

ETE3use2.py
	This helper program for parse.pl will take one argument, a taxid, and print out the rank of that taxid according to NCBI, requires ETE3

ETE3use3.py
	This helper program for parse.pl will take argument, a taxid, and translate it to english names for that taxid according to NCBI, requires ETE3

FINALPIPELINE.pbs
	This pbs script will blast a bunch of queries according to a set of files, listed as follows:
		archeaBlasts.txt - a list of all the databases for the archea query to be blasted into
		bacteriaBlasts.txt - a list of all the databases for the bacteria query to be blasted into
		eukaryaBlasts.txt - a list of all the databases for the eukarya query to be blasted into
		archaea - a file withe the fasta information of the archaea query
		bacteria - a file withe the fasta information of the archaea query
		eukarya - a file withe the fasta information of the archaea query
	It will also specially blast the Eukarya mitochondrion and Plastid - hardcoded
	the last point means this is not completely inferior to CogBlast.pl, but it is otherwise completely inferior
	this will also run ComplexParser.cpp after the blasts
parse.pl
	This parser take in a blast results and selects 10 results, trying to have different species first, then genera, then the top 10 in sort result for all of them 
 	This program will look through the directroy from which it is run and try to parse any file that has BlastResult anywhere in the name
	The procedure stated above will be run on all results that are about 60% query coverage first and then all results that are above 40% query coverage
	This program also looks for a file dbloc in the current directory, which contains one line, the location of the Blast dbv5
	The output of this program will be the orginal results files, but with Parsed added to the end
	This program requires the helper programs ETE3update.py, ETE3use.py, ETE3use2.py, and ETE3use3.py, as well as a fully installed blast suite

rename.pl
	This program will look through the current directory and for all files with Parsed in the name, 
	It will attempt to convert any string of digits, surrounded by underscores, in the name of the file to txids using the final taxid in the lineage, and the 3rd taxid in the lineage
	It will rename all files to this new conversion
	This program requires ETE3use.py, and ETE3use3.py

ReplaceTaxIDsBLASTwithGenusSpecies.py
	This program, written by AJ not me, will go through every file that has _BlastR in the name, and take any txids in the file, line by line, and try to convert them to genus and species, with UNKNOWN handling and sp. handling.
	This works to enable the parsing done in ComplexParser.cpp
	

RELATED TO BUILDING BLAST DBS:

*_Genomic.py
*_Mitochondrion.py
*_Plastid.py
	These three types of program have the same function, named differently so they could be submitted silmultaneously
	The * in these programs names is any superphyla. This program requires an accesions2taxid file from the ncbi website, which is specified on the third line as the atot variable
	The source file is a list of all accession numbers, the outfile is whatever you like 
	These are hardcoded in the first and second lines respectively
	These program will create a tsv of all accession numbers in the input in the first column, with their associated taxids in the second column
	These program is slow and not directly useful

Make*DB.sh
	The * is a super phyla or group to be made into a db
	These sh files are basically different variants of programs to make blast dbs for a given set of taxids, taking in a tsvc of all sequences in the taxid, with the accesion first column and taxid second column
	They take in a list of all ids as a txt file in the form *Ids.txt, one id per file

Parse_Accessions2Taxid_*.py
	The * is a superphyla. 
	This program, written by AJ not me, will take an accessions2taxid file, downloaded from NCBI and output a tsv of all accesions for a given taxid, including desecndants, in terms of taxonomic lineage.
	The target taxid and name can be modified in the program


