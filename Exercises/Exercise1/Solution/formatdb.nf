#!/usr/bin/env nextflow

/*
vim: syntax=groovy
*/

params.url = 'https://ftp.ncbi.nih.gov/blast/db/FASTA'
params.datafile = 'pdbaa.gz'
params.dbname = 'pdbaa'

dbname_channel = Channel.value(params.datafile)

process download {
	input:
		val filename from dbname_channel
	output:
		file params.datafile into seqfile_channel
	script:
		"""
		wget ${params.url}/${filename}
		"""
}

process uncompress {
	input:
		file gzipped_seqfile from seqfile_channel
	output:
		file params.dbname into dbinput_channel
	script:
		"""
		gunzip -c ${gzipped_seqfile} > ${params.dbname}
		"""
}

process format {
	module 'blast'
	publishDir '.', mode: 'link'
	input:
		file input_filename from dbinput_channel
	output:
		file 'pdbaa.pdb' into pdb_channel
		file 'pdbaa.phr' into phr_channel
		file 'pdbaa.pin' into pin_channel
		file 'pdbaa.pot' into pot_channel
		file 'pdbaa.psq' into psq_channel
		file 'pdbaa.ptf' into ptf_channel
		file 'pdbaa.pto' into pto_channel
		stdout into result_channel
	script:
		"""
		makeblastdb -in ${input_filename} -input_type fasta -dbtype prot -out ${params.dbname}
		"""
}

result_channel.subscribe { println "makeblastdb command output:\n$it" }
