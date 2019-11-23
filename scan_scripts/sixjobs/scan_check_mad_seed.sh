#!/bin/sh

source ./scan_definitions.sh
source ./sixdeskenv
export study=${workspace}

#################i
rm -rf missingMad6t.txt

for mask in $mask_list
do

        echo "#########################################"
        echo "### STUDY : $study"
        echo "#########################################"
        echo "### CHEKCING FILES FOR: $mask"
	ms=${mask:(-2)}
	ms2=${ms#0}
	echo "++++++ Running for seed " $ms2

        export ok=true

        export fort2=${scratchdir}'/sixtrack_input/'${study}'/'${mask}'/fort.2_'$ms2'.gz'
        export fort16=${scratchdir}'/sixtrack_input/'${study}'/'${mask}'/fort.16_'$ms2'.gz'
        export fort8=${scratchdir}'/sixtrack_input/'${study}'/'${mask}'/fort.8_'$ms2'.gz'
        export mother1=${scratchdir}'/sixtrack_input/'${study}'/'${mask}'/fort.3.mother1'
        export mother2=${scratchdir}'/sixtrack_input/'${study}'/'${mask}'/fort.3.mother2'


        if [ ! -f $fort2 ]; then
                ok=false
        fi


        if [ ! -f $fort16 ]; then
                ok=false
        fi

        if [ ! -f $fort8 ]; then
                ok=false
        fi

        if [ ! -f $mother1 ]; then
                ok=false
        fi

        if [ ! -f $mother2 ]; then
                ok=false
        fi

        if $ok; then
                echo 'ok'
        else
                echo $mask >> missingMad6t.txt
        fi

done
