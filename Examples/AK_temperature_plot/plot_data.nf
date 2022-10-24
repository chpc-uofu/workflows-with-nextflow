#!/usr/bin/env nextflow
/*
vim: syntax=groovy
*/

/* plot_data.nf - workflow that downloads daily temperature data from NOAA and plots it using R. */

params.header_url = 'https://www1.ncdc.noaa.gov/pub/data/uscrn/products/daily01/HEADERS.txt'
params.data_url_base = 'https://www1.ncdc.noaa.gov/pub/data/uscrn/products/daily01/2020/CRND0103-2020-AK_'
params.figure_file = 'Rplot001.png'

/* Locations - these location names are embedded in the URL used to download the data. */
location_channel = Channel.fromList(["Aleknagik_1_NNE","King_Salmon_42_SE","Fairbanks_11_NE","Sitka_1_NE"])

/* data_url - constructs a URL to download data given the name of a location. */
process data_url {
	executor 'local'
	input:
		val location from location_channel
	output:
		stdout into data_url_channel
	script:
		"""
		echo ${params.data_url_base}${location}".txt"
		"""
}

/* download_data - downloads data from one location given its URL. */
process download_data {
	input:
		val url from data_url_channel
	output:
		file "*.txt" into data_channel
	script:
		"""
		wget ${url}
		"""
}

/* download_headers - downloads header file given its URL. */
process download_headers {
	output:
		file 'HEADERS.txt' into headers_channel
	script:
		"""
		wget ${params.header_url}
		"""
}

/* plot_data - creates plot of daily temperature data given a header file and some location data files. */
process plot_data {
	publishDir '.'
	module 'R'
	input:
		file header_file from headers_channel
		file data_files from data_channel.collect()
	output:
		file 'Rplot001.png' into result_channel
	script:
		"""
		Rscript ${baseDir}/bin/plot_files.r ${header_file} ${data_files}
		"""
}

result_channel.subscribe { println "Data plotted to file $it" }
