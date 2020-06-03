import os
from Bio import SeqIO

directory = os.listdir(os.getcwd())
for f in directory:
    if ".py" not in f:
        sequenceNames = []
        for record in SeqIO.parse(f,"fasta"):
            name = record.name
            if name not in sequenceNames:
                sequenceNames.append(name)
            else:
                print f, name
