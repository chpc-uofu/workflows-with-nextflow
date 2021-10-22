# AK_temperature_plot

This example uses nextflow to plot temperature from NOAA for several
locations in Alaska:

```bash
locations = [ 
	"Aleknagik_1_NNE",
	"King_Salmon_42_SE",
	"Fairbanks_11_NE",
	"Sitka_1_NE",
]
```

Those locations are fed through a channel to a process that
generates URLs to download each data set using wget. Once the data
is present, all the data files (and a header file) are processed by
a script written in R.

Try running the script using either of the nextflow.config files, and
override the default settings in the workflow.

plot_data_rscript.nf is an (as yet unsuccessful) attempt to embed the R 
code in the nextflow process itself, but passing the values from the input channels is 
a challenge!
