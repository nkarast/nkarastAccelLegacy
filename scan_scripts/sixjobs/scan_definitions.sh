#!/bin/bash

source ./scan_utils.sh


#################
## Definitions ##
#################

## MASK
export template_mask=qb_template.mask

## SCAN PARAMETERS
export SCAN_EMIT="2.5"
export TUNESPLIT="0.005"
# - nominal
export mask_prefix=qb_BaselineNominal_C15_En${SCAN_EMIT}_D${TUNESPLIT}_below
export SCAN_X="064 057 051 046 040 035 031 026 023 018 015"
# - ultimate
#export mask_prefix=qb_BaselineUltimate_C7_En${SCAN_EMIT}_D${TUNESPLIT}
#export SCAN_X="040 036 032 029 025 022 019 016 015"
#export SCAN_Y=$(seq -w 0.2990 0.0020 0.3270)
export SCAN_Y=$(seq -w 0.3270 0.0020 0.3370)

make_mask_names mask_list "$SCAN_X" "$SCAN_Y"

## PATHS
export sixdesk_path=/afs/cern.ch/user/n/nkarast/work/SixDesk/utilities/bash/
export sixdb_path=/afs/cern.ch/project/sixtrack/SixDesk_utilities/dev/utilities/externals/SixDeskDB/

##################
##  PRINT OUT   ##
##################
echo '   SCAN DEFINITIONS SETTINGS'
echo '--------------------------------'
echo 'TEMPLATE MASK : '${template_mask}
echo 'MASK PREFIX   : '${mask_prefix}
echo 'X             : '${SCAN_X}
echo 'Y             : '${SCAN_Y}
echo 'Z             : '${SCAN_Z}
echo 'SIXDESK PATH  : '${sixdesk_path}
echo 'SIXDB PATH    : '${sixdb_path}
