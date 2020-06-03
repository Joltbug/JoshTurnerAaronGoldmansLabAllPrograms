source = 'accesionsetc/Haptophyceae_AccList_Genomic.txt'
outfile = file('accesionsetc/Haptophyceae_Acc_Genomic.txt','w')



atot = "accesionsetc/1783275.prot.accession2taxid"



accessions = []

infile = open(source,"rb")

for line in infile:

    accessions.append(line.strip())



with open(atot) as data:

    next(data)

    for line in data:

        line = line.strip().split("\t")

        Version = line[1]

        if Version in accessions:

            Taxon = line[2]

            outfile.write(Version + "\t" + Taxon + "\n")

    outfile.close()

        

        







