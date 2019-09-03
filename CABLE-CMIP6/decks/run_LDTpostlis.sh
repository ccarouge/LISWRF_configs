#!/bin/bash
#PBS -l walltime=2:30:00
#PBS -l mem=15GB
#PBS -l ncpus=1
#PBS -j oe
#PBS -q express
#PBS -l wd
#PBS -W umask=0022

codepath=/short/w35/ccc561/WRF/nuwrf_subtree/installs/cable_cmip6
if [ -x ${codepath}"/LDT" ]; then
    export PATH="${codepath}:${PATH}"
else
    echo "ERROR: LDT not found"
    exit 1
fi

module purge
module load dot pbs
module load nco

# Function to list all variables in a file using nco
function nclist { ncks -m ${1} | grep -E ':standard_name' | cut -f 1 -d ':' | sed 's/://' | sort ; }

# Post-process the output files. Copy some variables from LDT output 
# to LIS output
for dom in `eval echo {01..1}`
do
    echo Processing nest $dom

    echo Take last time step and remove time dimension
    ncks -O -d time,-1,-1,1 LIS_output/LIS.CABLE.1999050100.d01.nc LIS.HIST.nc
    ncwa -O -C -a time LIS.HIST.nc tmp.nc

    echo ncks -A -v TBOT,GREENNESS /short/w35/ccc561/WRF/run_nu-wrf_v8/CABLE-CMIP6/LIS_offline/lis_input.d${dom}.nc tmp.nc
    ncks -A -v TBOT,GREENNESS -d month,2,2 /short/w35/ccc561/WRF/run_nu-wrf_v8/CABLE-CMIP6/LIS_offline/lis_input.d${dom}.nc tmp.nc 
    if [ "$?" -ne "0" ]; then
	echo "Failed grabbing TBOT and GREENNESS"
	exit 1
    fi
    
    echo ncwa -C -a month tmp.nc tmp1.nc
    ncwa -O -C -a month tmp.nc tmp1.nc
    if [ "$?" -ne "0" ]; then
	echo "Failed removing month dimension"
	exit 1
    fi
    mv tmp1.nc tmp.nc
    
    echo ncrename -v TBOT,Tempbot_inst -v GREENNESS,Greenness_inst tmp.nc
    ncrename -v TBOT,Tempbot_inst -v GREENNESS,Greenness_inst tmp.nc
    if [ "$?" -ne "0" ]; then
	echo "Failed renaming variables"
	exit 1
    fi
    
    # List through variables and add scale_factor and add_offset attributes
    for var in `nclist tmp.nc`
    do
       echo $var
       ncatted -a scale_factor,$var,a,f,1. -a add_offset,$var,a,f,0. tmp.nc
       if [ "$?" -ne "0" ]; then
          echo "Failed adding attributes to variable "$var
          exit 1
       fi
    done

    ncatted --glb_att_add LANDCOVER_SCHEME="MODIS" tmp.nc
    mv tmp.nc LIS.HIST.d${dom}.nc
done

#ddt -connect ./LDT ldt.config.postlis
LDT ldt.config.postlis 
