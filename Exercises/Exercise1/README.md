# Exercise 1: Building a blast database

BLAST is a program that searches a biological sequence database very rapidly.
In this exercise you'll write a nextflow workflow to download some protein 
sequence data and format it into a blast-able database.

The steps are:

1. Download the amino acid sequence data file:
```bash
wget https://ftp.ncbi.nih.gov/blast/db/FASTA/pdbaa.gz
```

2. Uncompress the data:
```bash
gunzip pdbaa.gz
```

3. Format the raw data into a BLAST database:
```bash
module load blast
makeblastdb -in pdbaa -input_type fasta -dbtype prot -out pdbaa
```

Files created will be:
```bash
pdbaa.pdb
pdbaa.phr
pdbaa.pin
pdbaa.pot
pdbaa.psq
pdbaa.ptf
pdbaa.pto
```

Write a workflow with three processes that download, uncompress, and format
the database following the steps described above. The output from the
workflow can simply be the message written to standard output by the 
makeblastdb command. However, for the 7 files produced by makeblast to be
published, all 7 output files must be sent to a channel as the output of
the database formatting process.
