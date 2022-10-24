#!/usr/bin/env nextflow

// Set up a channel that emits the greeting:
input_channel = Channel.value("Hello, World!")

// This process will read the greeting from one channel,
// and echo the greeting to its standard output, which
// is captured by another channel.
process greet {
	input:
		val greeting from input_channel
	output:
		stdout into result_channel
	script:
		"""
		echo ${greeting}
		"""
}

// Subscribe to the process's output, and print whatever
// comes down the channel.
result_channel.subscribe { println "$it" }
