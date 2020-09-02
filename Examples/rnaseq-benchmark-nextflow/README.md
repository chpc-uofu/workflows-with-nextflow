# rnaseq-benchmark-nextflow

This workflow performs an RNAseq gene expression analysis on a data set from the SRA, using R, DESeq,
and a handful of other tools.

- compile1.nf: old nextflow workflow "Makefile" example for my own reference.
- config.yaml: configuration file for the Snakemake version of this workflow.
- rnaseq.nf: Nextflow workflow that carries out the RNAseq analysis.
- Snakefile.benchmark: the Snakemake workflow on which this workflow is based. Here for my own reference.
