#!/usr/bin/env nextflow

/*
vim: syntax=groovy
*/
// That comment above tells the vim editor to color code this using the 
// groovy language rules.

// Comments are java-style, and can either be one-liners, which 
// follow the double-slash "//" ...

/* 
Or comments can cross multiple lines and are surrounded by the slash-star
and star-slash.
*/

// Set some parameters for our workflow.
params.cflags="-c"
params.lnflags="-o"
params.executable_name="add_em_up"

// Create a channel that will provide input to our first process.
c_file_channel = Channel.fromPath("*.c")

// This process will compile one .c file into a corresponding .o file.
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
	publishDir '.', mode:'copy'
	module 'gcc/8.3.0'
	input:
		file dot_o_files from o_file_channel.collect()
	output:
		file params.executable_name into executable_channel
	script:
		"""
		gcc ${params.lnflags} ${params.executable_name} ${dot_o_files}
		"""
}

executable_channel.subscribe { println "Compiled $it" }

/*
Run the example with the command "./compile.nf" or "nextflow run compile.nf"
and then notice how all the result files are symbolic links into the work
directories.

Then uncomment the publishDir statement in the link process and rerun it.
*/
