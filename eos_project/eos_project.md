---
layout: post
---

## EOS Project

For the needs of storage space an EOS project space had been created.

The name of the project is : **lhc-beambeam** and can be found under : **/eos/project/l/lhc-beambeam/**

## Contents of Project Space

The idea behind the project space is to store the full input files used, as well as the results of our DA study. The project space had been requested by myself (nkarast) and will be formally maintained by Yannis after my departure. The initial hard disk space of 100 TB had been requested, but can be extended upon request and need.

### CERNBox Groups
In order to control the ACLs of the project space, several e-groups had been created.
The e-groups can be modified using the [e-groups page](https://e-groups.cern.ch).
- [cernbox-project-lhc-beambeam-admins](https://e-groups.cern.ch/e-groups/Egroup.do?egroupId=10289173&AI_USERNAME=NKARAST&searchField=0&searchMethod=1&searchValue=lhc-beambeam&pageSize=30&hideSearchFields=false&searchMemberOnly=false&searchAdminOnly=false&AI_SESSION=fuSOXpAnqRbiyJY-jYczBi_84Yx7y0Ccu_1fO_jx1AmivbETWDOy!2132884607!1574346592524): The administrators of the project
- [cernbox-project-lhc-beambeam-readers](https://e-groups.cern.ch/e-groups/Egroup.do?egroupId=10289174&AI_USERNAME=NKARAST&searchField=0&searchMethod=1&searchValue=lhc-beambeam&pageSize=30&hideSearchFields=false&searchMemberOnly=false&searchAdminOnly=false&AI_SESSION=fuSOXpAnqRbiyJY-jYczBi_84Yx7y0Ccu_1fO_jx1AmivbETWDOy!2132884607!1574346592524) The accounts that have read access
- [cernbox-project-lhc-beambeam-writers](https://e-groups.cern.ch/e-groups/Egroup.do?egroupId=10289175&AI_USERNAME=NKARAST&searchField=0&searchMethod=1&searchValue=lhc-beambeam&pageSize=30&hideSearchFields=false&searchMemberOnly=false&searchAdminOnly=false&AI_SESSION=fuSOXpAnqRbiyJY-jYczBi_84Yx7y0Ccu_1fO_jx1AmivbETWDOy!2132884607!1574346592524) The accounts that have write access.

### Project Webpage

A webpage directory had also been requested for the project. So far it has never be used. However you can easily update the html file under: `/eos/project/l/lhc-beambeam/www/website/index.html`, which will update the webpage: [lhc-beambeam.web.cern.ch](lhc-beambeam.web.cern.ch).

I had requested the webpage to be valid until Nov. 2020 (need to be manually updated if needed via the CERN's Web Services) and transfered the ownership to `yannis`.

### Project Contents

The initial project contents include

- a `public` folder
- a `sixtrack` folder

The `sixtrack` folder contains two subdirectories
- `HL-LHC`
- `LHC`

which are used as workspaces for studies concerning either LHC or HiLumi. As we usually exploit the `sixdesk` environment the workspaces are structured in zipped directories of the subfolder structure required by the `sixdesk` environment. For example a study called `TS_v13` (which contains the `sixjobs` and `track` folders) would be structured as:

- HL-LHC
  -  scratch0
    - TS_v13.zip
    - cronlogs/
      - TS_v13.zip
    - sixdesklogs/
      - TS_v13.zip
    - sixtrack_input/
      - TS_v13.zip
    - work/
      - TS_v13.zip


### Backup scripts

Some mock-up backup scripts have been included in the GitHub repository under the eos_project folder.
- [backupEOS.sh](https://github.com/nkarast/nkarastAccelLegacy/blob/master/eos_project/backupEOS.sh)
- [removeDirs.sh](https://github.com/nkarast/nkarastAccelLegacy/blob/master/eos_project/removeDirs.sh)
- [unzipFromEOS.sh](https://github.com/nkarast/nkarastAccelLegacy/blob/master/eos_project/unzipFromEOS.sh)

You can copy these scripts under your local `scratch0` folder.

You need to edit the study names in the included for loop, as well as if the target directory is the project's `HL-LHC` or `LHC` directories. Running the backup script it will create a zip (higher compression) file of all the required folders and copy them to the appropriate EOS directories. Similarly you can use the scripts to remove/delete the files from your work directory and also unzip from EOS to the local work directory.


### Having a sneak peek

Do you know that you can have a sneak peek within the zipped files without having to extract the full folder?

Let's take as an example the study in the `/eos/project/l/lhc-beambeam/sixtrack/HL-LHC/scratch0/TS_v13.zip`. Open an (i)python prompt.
```python
import zipfile
archive = zipfile.ZipFile("/eos/project/l/lhc-beambeam/sixtrack/HL-LHC/scratch0/TS_v13.zip", "r")

# the files that are in the zip:
archive.namelist()

# find a specific file if you kinda know its name:
[mfile for mfile in archive.namelist() if "scan_" in mfile]

# read/print out a single file
archive.read("TS_v13/sixjobs/scan_definitions.sh")

# extract a single file:
archive.extract("TS_v13/sixjobs/scan_definitions.sh")
# a path will be print out which states where the file has been extracted
```



### Disclaimer
The code is provided as is. - nkarast 2019
