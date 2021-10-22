process {
    executor='slurm'
    queue='kingspeak-shared'
    account='chpc'
    cpus = 1
    cache=true
    time="0:10:00"
    publishDir='.'
}
