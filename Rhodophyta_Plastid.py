source = 'accesionsetc/Rhodophyta_AccList_Plastid.txt'
outfile = file('accesionsetc/Rhodophyta_Acc_Plastid.txt','w')



atot = "accesionsetc/200940.prot.accession2taxid"



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

        

        







