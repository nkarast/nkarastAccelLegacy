#!/bin/bash

DESTINATION="/eos/project/l/lhc-beambeam/sixtrack/HL-LHC/scratch0/"

for study in "CO_inj_v13" "DeltapScan" "FL_wire_v13" "InjErr" "ITCorrFailB30" "KFL_wire_v13" "nCO_inj" "OctCorrectors" "QIMO_v13" "qNb_rATSCoupling_v13" "QonX8_lhcb_v13" "TS_FL_wire_v13" "TS_lhcb_v13" "TS_v14" "XBI_errors" "XBI_fixDisp_v13" "XBI_v13_posPol"  
do
    echo "Compressing study and moving to eos : ["${study}"]"
    zip -vry $DESTINATION/${study}.zip ${study}/  | tee zip_${study}.log
    sleep 5
    zip -vry $DESTINATION/cronlogs/${study}.zip cronlogs/${study}/  | tee zip_cronlogs_${study}.log
    sleep 5
    zip -vry $DESTINATION/sixdesklogs/${study}.zip sixdesklogs/${study}/  | tee zip_sixdesklogs_${study}.log
    sleep 5
    zip -vry $DESTINATION/sixtrack_input/${study}.zip sixtrack_input/${study}/  | tee zip_sixtrack_input_${study}.log
    sleep 5 
    zip -vry $DESTINATION/work/${study}.zip work/${study}/  | tee zip_work_${study}.log
    sleep 5
done
