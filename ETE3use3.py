from ete3 import NCBITaxa
import sys
ncbi = NCBITaxa()
print(ncbi.get_taxid_translator([sys.argv[1]]))
