from ete3 import NCBITaxa
import sys
ncbi = NCBITaxa()
print(ncbi.get_rank(sys.argv[1]))
