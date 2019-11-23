#!/bin/sh

source ./scan_definitions.sh

#################

cnt=0

for mask in $mask_list
do
        echo
        echo "####################################################"
        echo "###   CHECKING STUDY: $mask"
        echo "####################################################"
        echo

        $sixdesk_path/set_env.sh -d $mask
        python -c "import sys; sys.path.append('/afs/cern.ch/project/sixtrack/SixDesk_utilities/pro/utilities/externals/SixDeskDB/'); import sixdeskdb;
sys.exit(sixdeskdb.SixDeskDB.from_dir('./studies/$mask/').check_results(update_work=True))"
        if [ $? -ne 1 ]
        then
                ((++cnt))
                $sixdesk_path/run_six.sh -d $mask -i
        else
                echo " ### OK !"
        fi
done
echo $cnt
