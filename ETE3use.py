from ete3 import NCBITaxa
import sys
ncbi = NCBITaxa()
print(ncbi.get_lineage(sys.argv[1]))
