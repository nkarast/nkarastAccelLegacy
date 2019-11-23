#!/bin/sh

echo "Sourcing Scan Definitions..."
source scan_definitions.sh

echo 'Removing main lock...'
rm -rf studies/sixdesklock
rm -rf ./sixdesklock

echo "Removing study & htcondor sixdesklocks..."
for study in $mask_list 
do 
	rm -rf studies/${study}/sixdesklock
	rm -rf ${scratchdir}/work/${workspace}/${study}/htcondorjobs/jobs_logs/sixdesklock
done
echo 'done'
