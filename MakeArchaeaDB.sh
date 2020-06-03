#! /bin/bash
#PBS -j oe
#PBS -o archaeaout
#PBS -N Archaea
#PBS -l nodes=1:ppn=1

cd $HOME/NCBI/SpecialDBS/
awk -F"\t" '{print $1}' Archaea_Acc.txt > JustAccArchaea.txt
blastdbcmd -db $HOME/NCBI/NR/nr -entry_batch $HOME/NCBI/SpecialDBS/JustAccArchaea.txt -target_only -out - | gzip -c > $HOME/NCBI/SpecialDBS/nr.Archaea.fa.gz
gunzip $HOME/NCBI/SpecialDBS/nr.Archaea.fa.gz
makeblastdb -in $HOME/NCBI/SpecialDBS/nr.Archaea.fa -input_type fasta -dbtype prot -parse_seqids -taxid_map $HOME/NCBI/SpecialDBS/Archaea_Acc.txt


