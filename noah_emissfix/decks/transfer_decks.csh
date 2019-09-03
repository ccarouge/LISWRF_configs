#!/bin/tcsh

if (0) then
    echo transfer run_LIS_1988_01 to LIS run directory
    scp run_LIS_1988_01 ccc561\@r-dm.nci.org.au:/home/561/ccc561/WRF/nu-wrf_v6-3.4.1-p1/run_lis/run_noah/.
    
    echo transfer model output files 
    scp MODEL_OUTPUT_LIST.TBL_d01 ccc561\@r-dm.nci.org.au:/home/561/ccc561/WRF/nu-wrf_v6-3.4.1-p1/run_lis/run_noah/.

endif

if (1) then
    echo transfer runwrf_1989_01_01.deck to WRFV3/run
    scp runwrf_1989_02_01.deck ccc561\@r-dm.nci.org.au:/home/561/ccc561/WRF/nu-wrf_v6-3.4.1-p1/WRFV3/run/run_noah/.

    if (1) then
	echo transfer model output to WRF
	scp MODEL_OUTPUT_LIST.TBL_d01 ccc561\@r-dm.nci.org.au:/home/561/ccc561/WRF/nu-wrf_v6-3.4.1-p1/WRFV3/run/run_noah/.
    endif
endif
