#!/usr/bin/env nextflow
/* rnaseq.nf - Nextflow file for rnaseq benchmark example. */

/*
vim: syntax=groovy
-*- mode: groovy;-*-
*/

params.annotation_url='ftp://ftp.ensembl.org/pub/release-98/gtf/saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.98.gtf.gz'
params.annotation_file='Saccharomyces_cerevisiae.R64-1-1.98.gtf'

params.genome_url="ftp://ftp.ensembl.org/pub/release-98/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"
params.genome_fasta="Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa"

params.genome_dir="Genome"


process download_annotation {
	output:
		file params.annotation_file into annotation_ch
	script:
		"""
		wget ${params.annotation_url}
		gunzip `basename ${params.annotation_url}`
		"""
}


process download_genome {
	output:
		file params.genome_fasta into genome_ch
	script:
		"""
		wget ${params.genome_url}
		gunzip `basename ${params.genome_url}`
		"""
}

process index_genome {
	input: 
		file annotation_file from annotation_ch
		file genome_file from genome_ch
	output:
		file params.genome_dir into result
	script:
		"""
		module load star/2.7.1a
		mkdir -p ${params.genome_dir}
		STAR --runMode genomeGenerate \
			--runThreadN 5 \
			--genomeDir ${params.genome_dir} \
			--genomeFastaFiles ${genome_file} \
			--sjdbGTFfile ${annotation_file} \
			--genomeSAindexNbases 10 \
			--sjdbOverhang 100
		"""
}

result.subscribe { println "$it" }

/*

process download_one_sample {
	input:
	output:
	script:
}

process align_one_sample {
	input:
	output:
	script:
}

process qc_on_sample {
	input:
	output:
	script:
}

process raw_sample_qc {
	input:
	output:
	script:
}

process align_all_samples {
	input:
	output:
	script:
}

process make_sampledata_file {
	input:
	output:
	script:
}

process summarized_qc {
	input:
	output:
	script:
}

process differential_expression_analysis {
	input:
	output:
	script:
}

process analysis_complete {
	input:
	output:
	script:
}

process all_done {
	input:
	output:
	script:
}
*/

/*
hello_world_c = Channel.fromPath("hello_world.c")
hello_world_h = Channel.fromPath("hello_world.h")
a_h = Channel.fromPath("a.h")
b_h = Channel.fromPath("b.h")

process compile {
	input:
		file hello_world_c_file from hello_world_c
		file hello_world_h_file from hello_world_h
		file a_h_file from a_h
		file b_h_file from b_h
	output:
		file "hello_world.o" into result
	script:
		"""
		module load gcc/4.9.2
		echo "Compiling $hello_world_c_file"
		gcc -c $hello_world_c_file
		"""
}

process ls {
	input:
		file hello_world_o from result
	output:
		stdout ls_output
	script:
		"ls -l $hello_world_o"
}

result.subscribe { println "$it" }
*/
