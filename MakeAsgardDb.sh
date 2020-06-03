while read id; do
	awk -F"\t" '{print $1}' "$id"_Acc.txt > JustAcc"$id".txt
	blastdbcmd -db $HOME/NCBI/NR/nr -entry_batch $HOME/NCBI/SpecialDBS/JustAcc"$id".txt -target_only -out - | gzip -c > $HOME/NCBI/SpecialDBS/nr."$id".fa.gz
	gunzip $HOME/NCBI/SpecialDBS/nr."$id".fa.gz
	makeblastdb -in $HOME/NCBI/SpecialDBS/nr."$id".fa -input_type fasta -dbtype prot -parse_seqids -taxid_map $HOME/NCBI/SpecialDBS/"$id"_Acc.txt
done < ids.txt


