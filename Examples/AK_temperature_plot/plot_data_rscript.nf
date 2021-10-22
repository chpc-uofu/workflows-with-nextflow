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
	module 'R/4.0.2'
	publishDir '.'
	input:
		file header_file from headers_channel
		file data_files from data_channel.collect()
	output:
		file 'RPlot001.png' into result_channel
	script: 
		"""
		#!/usr/bin/env Rscript
		# plot_files.r : plots temperature data given a USCRN HEADERS.txt file and one 
		# or more data files.
		library(ggplot2)
		library(lubridate)

		# Function to convert date from yyyymmdd format to ordinal date.
		convert_date=function(date_yyyymmdd)
		{
			yday(as.Date(date_yyyymmdd,format="%Y%m%d"))
		}

		# Function to read header file.
		ReadHeaders=function(headerfile)
		{
			all_headers=as.matrix(read.table(headerfile))
			# The column names for the data files are located on row 2.
			headers=all_headers[2,]
			headers
		}

		# Get the command-line arguments.
		#args = commandArgs(trailingOnly=TRUE)

		# Read the header file.
		#headers=ReadHeaders(args[1])
		headers=ReadHeaders($header_file)

		# Read the subsequent files into a data frame.
		final_dataset = NULL
		#for ( datafile in args[-1] )
		for ( datafile in strsplit($data_files,",") )
		{
			# Read the data file into a data frame.
			dataset=read.table(datafile)
			# Assign names to the columns.
			names(dataset)=headers

			# Get the location name from the name of the file.
			location=tools::file_path_sans_ext(paste(strsplit(datafile,"_")[[1]][-1],collapse="_"))
			# Add location name to the data set.
			dataset$location=rep(location,dim(dataset)[1])

			# Replace any missing T_DAILY_MAX values with the value NA.
			dataset$T_DAILY_MAX[which(dataset$T_DAILY_MAX==-9999.0)]=NA

			# Add an ordinal date column.
			dataset$ordinal_date=convert_date(as.character(dataset$LST_DATE))

			# Concatenate data for this location to the final
			# dataset
			if ( is.null(final_dataset) )
				final_dataset=dataset
			else
				final_dataset=rbind(final_dataset,dataset)
		}

		# Open a PNG file for the plot.
		png()
		ggplot(data=final_dataset,aes(x=ordinal_date,y=T_DAILY_MAX,group=location))+geom_line(aes(color=location))
		dev.off()
		"""
}

result_channel.subscribe { println "Data plotted to file $it" }
