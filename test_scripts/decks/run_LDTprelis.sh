#!/bin/bash

# Run LDT
#PBS -m ae
#PBS -M c.carouge\@unsw.edu.au
#PBS -P w35
#PBS -l walltime=2:20:00
#PBS -l mem=10GB
#PBS -l ncpus=1
#PBS -j oe
#PBS -q express
#PBS -l wd

codepath=/short/w35/ccc561/WRF/nuwrf/installs/nuwrf_v9_p0
if [ -x ${codepath}"/LDT" ]; then
    export PATH="${codepath}:${PATH}"
else
    echo "ERROR: LDT not found"
    exit 1
fi

module purge
module load dot pbs
module load openmpi/1.10.7
module load netcdf/4.3.3.1


# Run LIS
LDT ldt.config.prelis

