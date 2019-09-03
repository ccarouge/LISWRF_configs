#!/bin/bash
#PBS -m ae
#PBS -M c.carouge\@unsw.edu.au
#PBS -P w35
#PBS -q copyq
#PBS -l walltime=05:30:00
#PBS -l mem=2000MB
#PBS -l ncpus=1
#PBS -j oe
#PBS -l wd
#PBS -l other=gdata

## Copy exp0
#echo Copy exp0
#rsync -vrLt  -e "ssh -c blowfish -i /home/561/ccc561/.ssh/id_rsa_file_transfer" z3368490@maelstrom.ccrc.unsw.edu.au:data43/z3368490/LIS_WRF/ssgw_exp/exp0 /g/data1/w35/ccc561/LIS_WRF/ssgw_exp/.

## Catch error
#set es=$?
#[ $es -ne 0 ] && exit $es
#echo exp0 done!


##-------------------------
## Copy exp2
#echo Copy exp2
#rsync -vrLt  -e "ssh -c blowfish -i /home/561/ccc561/.ssh/id_rsa_file_transfer" z3368490@maelstrom.ccrc.unsw.edu.au:data43/z3368490/LIS_WRF/ssgw_exp/exp2 /g/data1/w35/ccc561/LIS_WRF/ssgw_exp/.
#
## Catch error
#set es=$?
#[ $es -ne 0 ] && exit $es
#echo exp2 done!
#
#
##-------------------------
## Copy no_evap decks
#echo Copy no_evap decks
#rsync -vrLt  -e "ssh -c blowfish -i /home/561/ccc561/.ssh/id_rsa_file_transfer" z3368490@maelstrom.ccrc.unsw.edu.au:data43/z3368490/LIS_WRF/ssgw_exp/no_evap/decks /g/data1/w35/ccc561/LIS_WRF/ssgw_exp/no_evap/.
#
## Catch error
#set es=$?
#[ $es -ne 0 ] && exit $es
#echo no_evap decks done!
#
#
##-------------------------
## Copy no_wetcanop decks
#echo Copy no_wetcanop decks
#rsync -vrLt  -e "ssh -c blowfish -i /home/561/ccc561/.ssh/id_rsa_file_transfer" z3368490@maelstrom.ccrc.unsw.edu.au:data43/z3368490/LIS_WRF/ssgw_exp/no_wetcanop/decks /g/data1/w35/ccc561/LIS_WRF/ssgw_exp/no_wetcanop/.
#
## Catch error
#set es=$?
#[ $es -ne 0 ] && exit $es
#echo no_wetcanop decks done!
#
#
##-------------------------
## Copy CAM decks
#echo Copy CAM decks
#rsync -vrLt  -e "ssh -c blowfish -i /home/561/ccc561/.ssh/id_rsa_file_transfer" z3368490@maelstrom.ccrc.unsw.edu.au:data43/z3368490/LIS_WRF/ssgw_exp/CAM/decks /g/data1/w35/ccc561/LIS_WRF/ssgw_exp/CAM/.
#
## Catch error
#set es=$?
#[ $es -ne 0 ] && exit $es
#echo CAM decks done!


#-------------------------
# Copy bench
echo Copy bench
rsync -vrLt  -e "ssh -c blowfish -i /home/561/ccc561/.ssh/id_rsa_file_transfer" z3368490@maelstrom.ccrc.unsw.edu.au:data43/z3368490/LIS_WRF/bench /g/data1/w35/ccc561/LIS_WRF/.

# Catch error
set es=$?
[ $es -ne 0 ] && exit $es
echo bench done!
