from ete3 import NCBITaxa
ncbi = NCBITaxa()
import os

suff = "esults"

directory = os.listdir(PATH/PATH/)
for f in directory:
	if "_BlastR" in f:
		outfile = file(f+suff,"w")
		with open(f,"rb") as data:
#the following loops over line in the infile, if you need to skip the first lin$
#       		next(data)
        		for line in data:
                		ranks_avail = {}
                		line = line.strip().split("\t")
                		taxid_string = line[1] # The [1] refers to $
                		rank_list = ncbi.get_lineage(taxid_string)
                		for item in rank_list:
                    			rank_types = ncbi.get_rank([item])
                			for rank in rank_types:
                        			rank_name = rank_types.get(item).encode("ascii","ignore")
                        			if rank_name == "genus":
                            				ranks_avail["genus"] = rank
                        			elif rank_name == "species":
                            				ranks_avail["species"] = rank
                		if "genus" not in ranks_avail and "species" not in ranks_avail:
                    			genus = "UNKNOWN" # a new thing to handle; unknonwn genus
                    			species = "sp." #unknown species is still "sp."
                		elif "genus" in ranks_avail and "species" not in ranks_avail:
                    			genus_dict = ncbi.get_taxid_translator([ranks_avail.get("genus")])
                    			for genus in genus_dict:
                        			genus = genus_dict.get(genus)
                    			species = "sp."
                		elif "genus" not in ranks_avail and "species" in ranks_avail:
                    			genus = "UNKNOWN"
                    			#This is an unusual case that we can avoid except on last pass, I think.
                    			species_dict = ncbi.get_taxid_translator([ranks_avail.get("species")])
                    			for species in species_dict:
                        			species = species_dict.get(species)
                        			species = species.replace(genus,"")
                		elif "genus" in ranks_avail and "species" in ranks_avail:
                    			genus_dict = ncbi.get_taxid_translator([ranks_avail.get("genus")])
                    			for genus in genus_dict:
                        			genus = genus_dict.get(genus)
                    			species_dict = ncbi.get_taxid_translator([ranks_avail.get("species")])
                    			for species in species_dict:
                        			species = species_dict.get(species)
                        			species = species.replace(genus,"")
                #could probably use "else" here, but hedging my bets that there could be other weird cases (not sure what...), which we will call "UNKNOWN/UNKNOWN"
                		else:
                    			genus = "UNKNOWN" # a new thing to handle; unknonwn genus
                    			species = "sp." #unknown species is still "sp."
                outfile.write(line[0] + "\t" + line[1] + "\t" + genus + "\t" + species + "\n")
                #format will be accession tab genus (including spaces if multiple words) tab species new line
                #The species column will not always be neat; some such as "sp. M765", which you can treat as unique, compared to "sp.", which isn't. Also multiple word species are OK, just compare them directly. 
		outfile.close()
