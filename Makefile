# Edit the following lines for the specifics of the job to run
JOBNAME       = india
DESTDIR       = ${SCRATCH}

TIMESTR       = --timesteps
TIMEVAL	      = 500
DEPOSIT       = 0

MODULES       = python3
SLURMNNODES   = 1
SLURMNTASKS   = 36
SLURMQUEUE    = skx-dev
SLURMOUTFILE  = %j.out
SLURMERRFILE  = %j.err
SLURMWALLTIME = 00:59:00

GITSOFT       = pyDeltaRCM
GITURL        = https://github.com/DeltaRCM/pyDeltaRCM.git
GITBRANCH     = develop


##############################################################################
# Do not edit below this line

OUTDIR=${DESTDIR}/${JOBNAME}


setup : Makefile config.yaml
	@echo "Running setup for job:" $(JOBNAME)
	
	@echo "Copying and modifying config.yaml file..."
	@cat config.yaml | sed '/^out_dir:/d' | sed '1i+out_dir: ${OUTDIR}/output'> setup/config.yaml

	@echo "Configuring environment and setting up software..."
	@bash setup/setup_environment.sh ${GITSOFT} ${GITURL} ${GITBRANCH} ${MODULES}

	@echo "Copying and modifying Launcher Slurm file..."
	@bash setup/setup_launcher.sh ${JOBNAME} ${SLURMNNODES} ${SLURMNTASKS} ${SLURMQUEUE} ${SLURMOUTFILE} ${SLURMERRFILE} ${SLURMWALLTIME} ${OUTDIR}

	@echo "Running setup Python script for Launcher joblist..."
	./launch/softwarevenv/bin/python3 setup/setup_jobfile.py ${TIMESTR} ${TIMEVAL} ${DEPOSIT}

launch : setup
	@echo "Launching joblist with sbatch..."
	sbatch launch/launch_launcher.sh ${MODULES}


cleanup : 
	echo 'test'
	# copy files with srun over to $WORK

