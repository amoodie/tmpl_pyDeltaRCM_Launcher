# imports
import matplotlib
matplotlib.use('Agg')

import os
import sys
import numpy as np

import pyDeltaRCM


# config from command line:
#   note filename is argv[0]
if (len(sys.argv)-1) < 2:
    raise RuntimeError('Must supply args')
elif (len(sys.argv)-1) == 2:
    timestr = sys.argv[1]
    timeval = sys.argv[2]
    deposit = None
elif (len(sys.argv)-1) == 3:
    timestr = '--time'
    timeval = 0
    deposit = sys.argv[3]
else:
    raise RuntimeError('Too many args')


# parse supplied arguments and determine the pathway to follow for writing the
#  script
if not (timestr in ['--timesteps', '--time']):
    raise ValueError('Invalid `timestr` argument.')

try:
    timeval = float(timeval)
except Exception as e:
    raise ValueError('Could not convert `timeval` to numeric.')

if not (deposit is None):
    _deposit_flag = True
else:
    _deposit_flag = False


# configure the preprocessor (where matrix expansion occurs)
tsteps_placeholder = 1
pp = pyDeltaRCM.preprocessor.Preprocessor(
    './setup/config.yaml', timesteps=tsteps_placeholder, dry_run=True)


# make the Launcher job list (paramlist)
job_list = os.path.join('launch', 'launch_joblist')
f = open(job_list, "w")


# write job commands to the joblist file
if (_deposit_flag is False):
    for j in pp.file_list:
        f.write(' '.join(('pyDeltaRCM',
                          '--config', str(j),
                          timestr, str(timeval),
                          '\n')))

else:
    whch_SLR = np.where([i.strip() == 'SLR' for i in pp.matrix_table_header.split(',')])[0][0]
    for j, job in enumerate(pp.file_list):
        # compute the timesteps required to reach deposit thickness for each job
        job_SLR = pp.matrix_table[j, whch_SLR]
        endtime = float(deposit) / float(job_SLR)
        f.write(' '.join(('pyDeltaRCM',
                          '--config', str(job),
                          '--time', str(endtime),
                          '\n')))


# close the file
f.close()
