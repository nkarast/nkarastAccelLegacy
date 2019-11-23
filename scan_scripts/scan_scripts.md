---
layout: post
---

# DA Scans

Over the years several Python and Bash scripts have been developed in order to make use of the SixDesk environment for our multi-parametric DA scans. In this post we explain the usual workflow and the mentality behind them. I am aware that new "pythonic" scripts are being developed, but I still trust the old Bash ones (NB: especially if in Python the exception handling is not perfomed properly).

# SixDesk

SixDesk utilities scripts can be found under: `/afs/cern.ch/project/sixtrack/SixDesk_utilities/pro/utilities/`
From these we mainly use the bash scripts for our setup.

For checking the Sixtrack studies and to extract the DA information, the SixDB is used:
`/afs/cern.ch/project/sixtrack/SixDesk_utilities/pro/utilities/externals/SixDeskDB/`



# Workflow

The scan scripts are placed within your `sixjobs` directory and they expect a `./mask/somemask.mask` file for the MADX part and the `./control_files/*` for the initial setup of the SixTrack part. Finally, a `./sixdeskenv` and `./sysenv` files (the same as SixDesk) are required.

The idea is the following
  1. that we use a "template mask" set up for our specific needs. Within this template mask we select the knobs that we will scan (let's assume intensity (`Npart` in the mask) and half-crossing angle (`xing15`)). We set these knobs to a handle value to be later replaced by a `sed` command. E.g. `Npart0 = %NPART * 1.0E11;`.
  2. Our scan scripts will take the template mask and create a new one for each point of the scan by replacing the handle values. The naming convention of the studies is (in case of only 2 scan variables): `[prefix]_[SCAN_VAR_1]_[SCAN_VAR_2]`
  3. Then for each mask generated an HTCondor job for the MADX part is submitted. The version of MADX is defined under the `sysenv` script. The MADX jobs generate the initial folder structure that SixDesk requires.
  4. For each generated `sixtrack_input` from the masks a SixTrack study is submitted with the initial conditions defined in `sixdeskenv` script.
  5. When all jobs are done we can use the `SixDB` to generate the DA output for our studies.


Let's see what each script does:

- `scan_utils.sh`: A set of functions to create the study names. *No need to edit this file.*

- `scan_definitions.sh` : This is the file where the template mask is defined as well as the AFS directory of the SixDesk and SixDB scripts. Finally the scan variable ranges are defined and a list (`mask_list`) of the study names is generated. *You need to edit this file.*

- `scan_make_input.sh`: This script runs a loop over the studies. It copies the template mask replacing the handle values with the appropriate ones and stores the mask under `./mask/[maskname].mask`. **Note that for some scans, e.g. intensity, crossing angle, emittance, seed the `sixdeskenv` file should also be changed.** When everything is done the script submits the MADX jobs. If there are failed/missing MADX jobs (see next script) running this script with the `miss` argument will re-run only the missing ones (i.e. `source scan_make_input.sh miss`). *You need to edit this file.*

- `scan_check_mad[_seed].sh`: This script checks the `sixtrack_input` directories created to make sure that all the files needed for the SixTrack studies are there. Two version exist, one that only checks the 1st seed (e.g. files named `fort.3_1.gz`) and one checking also for various seeds (expected to be in the study name). If some files are missing, a text file is generated containing in each line the name of the study which is not completed properly. This file can be then used with `scan_make_input.sh` and the `miss` argument to re-run only the missing studies. *Usually, no need to edit this file.*

- `scan_run_six.sh`: When MADX is done, this script loops over the studies and submits the SixTrack jobs. *No need to edit this file.*

- `scan_run_checkdb.sh`: This script uses `SixDB` to make sure that the SixTrack studies have been completed successfully. If a job has failed or is incomplete, it is automatically re-submitted. *No need to edit this file.*

- `scan_plot_sixdb.py`: This uses the `SixDB` to make a plot of the studies. You need to change the regular expression to match the naming of your study. In addition, the aesthetics of the plot can also be changed (labels, size, etc). *You need to edit this file.*

- `scan_remove_locks.sh`: Sometimes we mess things up. Especially if we kill a submit script. SixDesk generates lock files (named `sixdesklock`) in each folder it needs for its operation. If you kill a script and the lock is not removed you cannot rerun anything. This script runs over all the necessary folders of your studies to make sure that these locks are removed. *No need to edit this file.*

- `analyseDB.py`: A python script that makes use of SixDB but in the end stores a full dataframe in HDFS that contains all the necessary information to restore/rerun/remember your study. A bit complex, but meh... *You need to edit this file.*

- `setBigBird.sh`: This is a cheeky script that allows you to change your HTCondor scheduler (BigBird) in order to submit jobs in different schedulers. You source it and give it a BigBird number as argument and will export in your bash the necessary info. E.g. `source setBigBird.sh 15` will change your scheduler to bigbird15.cern.ch. **NB: You can only see the progress of the jobs in the scheduler that you are currently are assigned. So you need to change between schedulers using this script in order to `condor_q` your jobs in that sceduler.** *No need to edit this file.*
