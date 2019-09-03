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
#PBS -l other=gdata1a

codepath=/short/w35/ccc561/WRF/nuwrf_subtree/installs/cable_cmip6
if [ -x ${codepath}"/LDT" ]; then
    export PATH="${codepath}:${PATH}"
else
    echo "ERROR: LDT not found"
    exit 1
fi

module purge
module load dot pbs
module load openmpi/1.6
module load netcdf/4.3.3.1


# Run LIS
LDT ldt.config.prelis

cp LIS_offline/lis_input* /g/data1/w35/ccc561/LIS_WRF/CABLE-CMIP6/bdy_data

