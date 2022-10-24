process {
    executor='slurm'
    queue='notchpeak-shared-short'
    cpus = 1
    cache=true
    time="0:10:00"
    publishDir='.'
    clusterOptions = '-A notchpeak-shared-short'
}
