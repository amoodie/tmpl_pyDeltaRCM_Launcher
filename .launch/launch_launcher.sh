#!/bin/bash
#
# Laucher batch script file for TACC systems (like Frontera, Stampede2, etc.)
#
#-------------------------------------------------------
# 
#         <------ Setup Parameters ------>
#
#SBATCH -J india
#SBATCH -N 1
#SBATCH -n 36
#SBATCH -p skx-dev
#SBATCH -o /scratch/india/%j.out
#SBATCH -e /scratch/india/%j.err
#SBATCH -t 00:59:00

#------------------------------------------------------

MODULES=$1

# setup the environment (needs to match how the software was built)
module load $MODULES
module load launcher
. ./softwarevenv/bin/activate
export MPLBACKEND=Agg


# configure the launcher options
export LAUNCHER_WORKDIR=`pwd`
export LAUNCHER_JOB_FILE=launcher_joblist

$LAUNCHER_DIR/paramrun
