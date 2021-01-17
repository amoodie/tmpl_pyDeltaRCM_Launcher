import matplotlib
matplotlib.use('Agg')

import os

import pyDeltaRCM

timesteps = 500
pp = pyDeltaRCM.preprocessor.Preprocessor('./config.yaml', timesteps=timesteps, dry_run=True)

# make the Launcher job list (paramlist)
job_list = os.path.join('.launch', 'launch_joblist')

# add all paths
f = open(job_list, "w")
for j in pp.file_list:
    f.write(' '.join(('pyDeltaRCM',
                      '--config', str(j),
                      '--timesteps', str(timesteps),
                      '\n')))
f.close()
