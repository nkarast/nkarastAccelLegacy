#!/bin/bash

SOURCE="/eos/project/l/lhc-beambeam/sixtrack/HL-LHC/scratch0/"
DESTINATION="/afs/cern.ch/work/n/nkarast/HL-LHC/scratch0/"

for study in "CO_inj_v13" #"QIMO_v13" "TS_inj_v13" "XI_v13" "TS_v13_PRAB" "QB_v13"
do
    echo "Getting study from EOS : ["${study}"]"
    unzip -vn ${SOURCE}/${study}.zip -d ${DESTINATION}/$study  | tee unzip_${study}.log
    sleep 5
    #unzip -vn $DESTINATION/cronlogs/${study}.zip cronlogs/${study}/  | tee zip_cronlogs_${study}.log
    #sleep 5
    #unzip -vn $DESTINATION/sixdesklogs/${study}.zip sixdesklogs/${study}/  | tee zip_sixdesklogs_${study}.log
    #sleep 5
    #unzip -vn $DESTINATION/sixtrack_input/${study}.zip sixtrack_input/${study}/  | tee zip_sixtrack_input_${study}.log
    #sleep 5 
    #unzip -vn $DESTINATION/work/${study}.zip work/${study}/  | tee zip_work_${study}.log
    #sleep 5
done
