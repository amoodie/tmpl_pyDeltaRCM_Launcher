#!/bin/bash

## This script should be run on TACC to set up 
#  files and environments needed to run job with sbatch

# grab variables from from env before creating venv
GITSOFT=$1
GITURL=$2
GITBRANCH=$3
MODULES=$4

LOGFILE=setup/setup_environment.log
touch $LOGFILE


# load speced modules
module load $MODULES > $LOGFILE


# collect SOFTWARE ($GITSOFT) from GitHub
if [[ ! -d "launch/$GITSOFT" ]]
then
	echo "$GITSOFT not found, performing clone" >> $LOGFILE
	git clone $GITURL launch/$GITSOFT >> $LOGFILE
else
	echo "$GITSOFT found, performing git pull" >> $LOGFILE
	(cd launch/$GITSOFT && git pull origin $GITBRANCH) >> $LOGFILE
fi


# set up a virtual environment with python3
unset PYTHONHOME
# create the environment if it does not exist
if [[ ! -d "launch/softwarevenv" ]]
then
	virtualenv --system-site-packages launch/softwarevenv >> $LOGFILE
fi
# activate environment
. ./launch/softwarevenv/bin/activate
# prepare and check environment
export MPLBACKEND=Agg
if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "No VIRTUAL_ENV set" >> $LOGFILE
else
    echo "VIRTUAL_ENV is set" >> $LOGFILE
fi


# install SOFTWARE and dependencies
pip install -r launch/$GITSOFT/requirements.txt >> $LOGFILE
pip install -e launch/$GITSOFT/. >> $LOGFILE
