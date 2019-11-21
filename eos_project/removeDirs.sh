#!/bin/bash

for study in "CO_inj_v13" "DeltapScan" "FL_wire_v13" "InjErr" "ITCorrFailB30" "KFL_wire_v13" "nCO_inj" "OctCorrectors" "QIMO_v13" "qNb_rATSCoupling_v13" "QonX8_lhcb_v13" "TS_FL_wire_v13" "TS_lhcb_v13" "TS_v14" "XBI_errors" "XBI_fixDisp_v13" "XBI_v13_posPol"
do
	echo "#####################################"
	echo "## REMOVING STUDY" $study
	echo "#####################################"

	rm -rfv $study
	rm -rfv cronlogs/$study
	rm -rfv sixdesklogs/$study
	rm -rfv sixtrack_input/$study
	rm -rfv work/$study
	sleep 2
done
