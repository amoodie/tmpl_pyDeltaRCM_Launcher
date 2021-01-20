# pyDeltaRCM on TACC template

This repo contains (somewhat generalized) template scripts and files for configuring and executing many serial jobs on a supercomputer via the [TACC Launcher](https://github.com/TACC/launcher) utility.

The scripts are currently configured for running the pyDeltaRCM numerical delta model, but could be adapted as needed.

## Instructions

### clone and setup the folder
```
JOBNAME='nameofjobsuite'
git clone https://github.com/amoodie/tmpl_pyDeltaRCM_Launcher
mv tmpl_pyDeltaRCM_Launcher $JOBNAME
cd $JOBNAME
```

### configure jobs and models
Edit the parameters at the top of the `Makefile` to configure the setup of jobs and job scheduling.
Edit the `config.yaml` file for the actual pyDeltaRCM runs


### run the setup

```
make setup
```


### run the jobs via Launcher

```
make launch
```


## configuring for custom software

1. Change the github urls for the software you wish to run in the top of the `Makefile`.
1. Write a custom version of the `setup/setup_jobfile.py` for your script (in accordance with Launcher config)

## configuring for other HPC

1. Change environment variables (`$SCRATCH`) to appropriate directories on your HPC
1. Change use of `module load xxxx` in scripts to different platform if needed
1. Change the launch_launcher.sh.template as needed to configure jobs to run via scheduler (if not slurm)
