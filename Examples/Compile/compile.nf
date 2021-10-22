#!/usr/bin/env nextflow

/*
vim: syntax=groovy
*/

params.cflags="-c"
params.lnflags="-o"
params.executable_name="add_em_up"

c_file_channel = Channel.fromPath("*.c")

process compile {
	module 'gcc/8.3.0'
	input: 
		file dot_c_file from c_file_channel
	output:
		file "*.o" into o_file_channel
	script:
		"""
		gcc ${params.cflags} ${dot_c_file}
		"""
}

process link {
	cache false
	module 'gcc/8.3.0'
	publishDir '.'
	input:
		file dot_o_files from o_file_channel.collect()
	output:
		file params.executable_name into result_channel
	script:
		"""
		gcc ${params.lnflags} ${params.executable_name} ${dot_o_files}
		"""
}

result_channel.subscribe { println "Compiled $it" }
