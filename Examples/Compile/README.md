# Compile

compile.nf is a simple workflow that illustrates how
nextflow can function like make. This script compiles
each .c file into the corresponding .o file, and
then links them into an executable named "add_em_up".

Try running this script with or without caching enabled
to see how the caching behavior changes, and how the
workflow responds to changes in the workflow itself.
