#!/bin/bash
#PBS -l walltime=2:30:00
#PBS -l mem=15GB
#PBS -l ncpus=1
#PBS -j oe
#PBS -q express
#PBS -l wd
#PBS -W umask=0022

export NUWRF_DIR=/short/$PROJECT/$USER/WRF/nuwrf
source $NUWRF_DIR/raijin.cfg
module load intel-mkl/${EBVERSIONINTELMINFC}
module load nco/4.6.4

module load arm-forge

# Add path to source code
export NUWRF_DIR=/short/$PROJECT/$USER/WRF/nuwrf
if [ -x "${NUWRF_DIR}/installs/nuwrf_v9_p0/LDT" ]; then
    export PATH="${NUWRF_DIR}/installs/nuwrf_v9_p0:${PATH}"
else
    echo "ERROR: LDT not found"
fi


# Go to LDT_postlis directory
[ ! -d LDT_postlis ] && mkdir LDT_postlis
cd LDT_postlis
cp ../ldt.config.postlis .

# Post-process the output files. Copy some variables from LDT output 
# to LIS output
LIS_DIR=LIS_offline
LIS_output=OUTPUT/SURFACEMODEL/1999/19990601/LIS_HIST_199906010000
test_file=LIS_HIST_test
nnest=1

for dom in `eval echo {01..$nnest}`
do
    echo Processing nest $dom

    echo cp ../${LIS_DIR}/${LIS_output}.d${dom}.nc ${test_file}.d${dom}.nc
    cp ../${LIS_DIR}/${LIS_output}.d${dom}.nc ${test_file}.d${dom}.nc

    echo cp ../${LIS_DIR}/lis_input.d${dom}.nc lis_input.d${dom}.nc
    cp ../${LIS_DIR}/lis_input.d${dom}.nc lis_input.d${dom}.nc

    echo ncks -A -v TBOT,GREENNESS lis_input.d${dom}.nc ${test_file}.d${dom}.nc
    ncks -A -v TBOT,GREENNESS -d month,2,2 lis_input.d${dom}.nc ${test_file}.d${dom}.nc 
    if [ "$?" -ne "0" ]; then
	echo "Failed grabbing TBOT and GREENNESS"
	exit 1
    fi
    
    echo ncwa -C -a month ${test_file}.d${dom}.nc tmp.nc
    ncwa -C -a month ${test_file}.d${dom}.nc tmp.nc
    if [ "$?" -ne "0" ]; then
	echo "Failed removing month dimension"
	exit 1
    fi
    mv tmp.nc ${test_file}.d${dom}.nc
    
    echo ncrename -v TBOT,Tempbot_inst -v GREENNESS,Greenness_inst ${test_file}.d${dom}.nc
    ncrename -v TBOT,Tempbot_inst -v GREENNESS,Greenness_inst ${test_file}.d${dom}.nc
    if [ "$?" -ne "0" ]; then
	echo "Failed renaming variables"
	exit 1
    fi
    
    ncatted -a scale_factor,Greenness_inst,a,f,1. -a add_offset,Greenness_inst,a,f,0. ${test_file}.d${dom}.nc
    if [ "$?" -ne "0" ]; then
	echo "Failed adding attributes to variables"
	exit 1
    fi
done

#ddt -connect ./LDT ldt.config.postlis
LDT ldt.config.postlis 
