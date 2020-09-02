#!/usr/bin/env nextflow
/* compile1.nf - Nextflow file for workshop example. */

/*
vim: syntax=groovy
-*- mode: groovy;-*-
*/

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
