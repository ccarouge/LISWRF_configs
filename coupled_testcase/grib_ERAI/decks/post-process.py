#!/usr/bin/python

import os
import os.path
import sys, argparse, shutil, subprocess

def set_pnmonth(year, month, nmonths=1, pmonths=1):
    """ Get the year and month of the current month (year/month) minus pmonth
    and plus nmonths. E.g: set_pnmonth(2003,4,nmonths=3,pmonths=2) returns
    ((2003,2),(2003,7))"""

    tmp = divmod(month+nmonths-1,12)
    nextm = tmp[1]+1
    nexty = year + tmp[0]

    tmp = divmod(month-pmonths-1,12)
    prevm = tmp[1]+1
    prevy = year + tmp[0]

    return ((prevy, prevm), (nexty, nextm))

#-------------------------------------------------------------------------------
# Read command-line arguments
#
#def main():
p_args = argparse.ArgumentParser(description='Condense LIS output'+        \
                                     'before storage')
p_args.add_argument('-s', '--start', type=int, nargs=2,                    \
                        help='first year and month', metavar=('YYYY','MM'))
p_args.add_argument('-e', '--end', type=int, nargs=2,                      \
                        help='last year and month', metavar=('YYYY','MM'))
p_args.add_argument('LSM',type=str,help='Name of the LSM to use')

p_args.add_argument('--debug', action='store_true', help='For debugging prints')

args = p_args.parse_args()

# Initialise year and month variables
cyear = args.start[0]
cmonth = args.start[1]

# Store initial directory to move around the directory tree.
cwd = os.getcwd()

# Add 1 month to the last month to make an easier ending condition
#prevm,nexm = set_pnmonth(*(args.end))
#eyear,emonth = nexm
eyear = args.end[0]
emonth = args.end[1]

print "Start: %4i %02i and End: %04i %02i"%(cyear, cmonth, eyear, emonth)
# Loop over months until we reach the last one
while (cyear != eyear or cmonth != emonth):

    print "Current: %4i %02i"%(cyear, cmonth)
    # Get next month
    prevm, nexm = set_pnmonth(cyear, cmonth)

    # If tmp/ directory exists, then remove. Create the directory in all cases
    if os.path.isdir("tmp"):
        shutil.rmtree("tmp")

#    # Create tmp/ directory if does not exist
#    if not os.path.isdir("tmp"):
#        os.mkdir("tmp")
    os.mkdir("tmp")

    # Move files to tmp/ repository. Current month and first file of next month
    print "cwd: %s"%cwd
    for root, dirs, files in os.walk(cwd):
        stryear = "%04i"%(cyear)
        strmonth = "%02i"%(cmonth)
        if root.endswith(stryear+strmonth,0,-2):
            for ff in files:
                if ff.endswith(".nc"):
                    if (args.debug):
                        print "Found ff: {0}".format(ff)
                    shutil.move(os.path.join(root, ff), "tmp")

        stryear = "%04i"%(nexm[0])
        strmonth = "%02i"%(nexm[1])
        if root.endswith(stryear+strmonth,0,-2):
            for ff in files:
                if ff.endswith("010000", 0, -7):
                    if (args.debug):
                        print "Found ff: {0}".format(ff)
                    shutil.move(os.path.join(root, ff), "tmp")


    # Enter tmp
    os.chdir("tmp")

    # Create a unlimited time dimension in each file
    print "Create time dimension"
    for ff in os.listdir("."):
        if (args.debug):
            print "Process file: {0}".format(ff)
        subprocess.call(['ncecat','-O','-u','time',ff,ff])
        ftime=ff.split(".")
        time = "time[$time]="+ftime[0]+"."
        subprocess.call(["ncap2", "-O", "-s", time, ff, ff])

    # Concatenate in a monthly file
    print "Concatenate in a monthly file"
    cmd = ["ncrcat"]
    dirlist = os.listdir(".")
    dirlist.sort()
    cmd.extend(dirlist)
    cmd.extend(["../" + ".".join([args.LSM,"%04i%02i0100"%(cyear,cmonth),"d01","nc"])])
    if (args.debug):
        print "nrcat command: {0}".format(cmd)
    subprocess.call(cmd)

    # Get next month
    cyear, cmonth = nexm

    # Go back to original directory
    os.chdir(cwd)

    # Remove tmp directory
    shutil.rmtree("tmp")

#    print "New month: %4i %02i"%(cyear, cmonth)


#if __name__ == "main":
#    print "we are here"
#    main()
