import os
import ete3
from ete3 import NCBITaxa
ncbi = NCBITaxa()
#ncbi.update_taxonomy_database()

directory = os.listdir(os.getcwd())
for val in directory:
	print(os.stat(val).st_size)
	if os.stat(val).st_size == 0:
		print(val)
		intval = int(val)
		intval = int(intval/10)
		print(intval)
		listval = [intval]
		print(listval)
		print(ncbi.get_rank(listval))	
