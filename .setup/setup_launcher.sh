#!/bin/bash

JOBNAME=$1
SLURMNNODES=$2
SLURMNTASKS=$3
SLURMQUEUE=$4
SLURMOUTFILE=$5
SLURMERRFILE=$6
SLURMWALLTIME=$7
OUTDIR=$8




cp .launch/launch_launcher.sh.template .launch/launch_launcher.sh

# replace vars from makefile
cd .launch
sed -i "s/_jobname_/$JOBNAME/g" launch_launcher.sh
sed -i "s/_nnodes_/$SLURMNNODES/g" launch_launcher.sh
sed -i "s/_ntasks_/$SLURMNTASKS/g" launch_launcher.sh
sed -i "s/_queue_/$SLURMQUEUE/g" launch_launcher.sh
sed -i "s+_outfile_+$OUTDIR/$SLURMOUTFILE+g" launch_launcher.sh
sed -i "s+_errfile_+$OUTDIR/$SLURMERRFILE+g" launch_launcher.sh
sed -i "s/_walltime_/$SLURMWALLTIME/g" launch_launcher.sh
