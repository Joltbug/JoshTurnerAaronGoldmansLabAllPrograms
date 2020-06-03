from ete3 import NCBITaxa
ncbi = NCBITaxa()

infile = "accesionsetc/5752.prot.accession2taxid"
pre = "accesionsetc/"

target_rank = 508458
target_name = 'Synergistetes'

outfile = file(target_name + '_Acc.txt','w')
with open(infile,"rb") as data:
	next(data)
	for line in data:
        	entry = line.strip().split("\t")
        	Taxon = entry[2]
        	Version = entry[1]
		try:
        		rank_list = ncbi.get_lineage(Taxon)
                        if target_rank in rank_list and Version.lower() != "na":
                                outfile.write(Version + "\t" + str(Taxon) + "\n")
		except:
			pass
	outfile.close()
