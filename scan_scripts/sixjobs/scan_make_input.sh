#!/bin/bash

source ./scan_definitions.sh

#################i
today=`date '+%d%m%Y'`
cp sixdeskenv backsix_sixdeskenv_${today}.bkp

if [ $# -eq 0 ]; then
	echo 'NKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKN'
        echo 'NKNKNKNKNK Running mask list from scan definitions.'
	echo 'NKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKN'
else
        if [ $1 == "miss" ]; then
		echo 'NKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKN'
	        echo 'NKNKNKNKNK Running mask list from missing files.   '
        	echo 'NKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKNKN'
		mask_list=`more missingMad6t.txt  | awk '{print $1}'`
	else
		echo " --------- UNRECOGNIZED ARGUMENT --------- BYE! :)"
		exit 1
        fi

fi



for mask in $mask_list
do
    echo
    echo "##########################################################"
    echo "### SETTING ENV AND RUNNING MAD FOR MASK: $mask"
    echo "##########################################################"
    echo

    get_pars_from_mask_name PARS $mask

    x=${PARS[0]}
    y=${PARS[1]}
    m_emit=${SCAN_EMIT}

    # This is for the nominal scenario 
    if [ $x == "064" ]; then
	mint=2.2
	mopt="opt_squeeze_640_3000_thin.madx"
    elif [ $x == "057" ]; then
        mint=2.1
	mopt="opt_squeeze_570_3000_thin.madx"
    elif [ $x == "051" ]; then
        mint=2.0
	mopt="opt_squeeze_510_3000_thin.madx"
    elif [ $x == "046" ]; then
        mint=1.9
	mopt="opt_460_460_460_460_thin.madx"
    elif [ $x == "040" ]; then
        mint=1.8
	mopt="opt_400_400_400_400_thin.madx"
    elif [ $x == "035" ]; then
        mint=1.7
	mopt="opt_350_350_350_350_thin.madx"
    elif [ $x == "031" ]; then
        mint=1.6
	mopt="opt_310_310_310_310_thin.madx"
    elif [ $x == "026" ]; then
        mint=1.5
	mopt="opt_260_260_260_260_thin.madx"
    elif [ $x == "023" ]; then
        mint=1.4
	mopt="opt_230_230_230_230_thin.madx"
    elif [ $x == "018" ]; then
        mint=1.3
	mopt="opt_180_180_180_180_thin.madx"
    elif [ $x == "015" ]; then
        mint=1.2
	mopt="opt_150_150_150_150_thin.madx"
    else
	echo "Unknown beta value!"
	#exit 1
    fi
    
    # This is for the ultimate scenario
    : '
    if [ $x == "040" ]; then
        mint=2.2
        mopt="opt_400_400_400_400_thin.madx"
    elif [ $x == "036" ]; then
        mint=2.1
        mopt="opt_360_360_360_360_thin.madx"
    elif [ $x == "032" ]; then
        mint=2.0
        mopt="opt_320_320_320_320_thin.madx"
    elif [ $x == "029" ]; then
        mint=1.9
        mopt="opt_290_290_290_290_thin.madx"
    elif [ $x == "025" ]; then
        mint=1.8
        mopt="opt_250_250_250_250_thin.madx"
    elif [ $x == "022" ]; then
        mint=1.7
        mopt="opt_220_220_220_220_thin.madx"
    elif [ $x == "019" ]; then
        mint=1.6
        mopt="opt_190_190_190_190_thin.madx"
    elif [ $x == "016" ]; then
        mint=1.5
        mopt="opt_160_160_160_160_thin.madx"
    elif [ $x == "015" ]; then
        mint=1.46
        mopt="opt_150_150_150_150_thin.madx"
    else
        echo "Unknown beta value!"
        #exit 1
    fi
    '



  
    cp mask/$template_mask mask/$mask.mask


    sed -i 's#%NPART#'$mint'E11#g' mask/$mask.mask
    sed -i 's#%OPTICS#'$mopt'#g' mask/$mask.mask
    sed -i 's#%D#'$TUNESPLIT'#g' mask/$mask.mask
    sed -i 's/%QX0/'$y'/g' mask/$mask.mask
    sed -i 's/%EMIT/2.50/g' mask/$mask.mask
  
    sed -i 's/export LHCDescrip=.*/export LHCDescrip='$mask'/' sixdeskenv
    sed -i 's/export xing=.*/export xing=250/' sixdeskenv
    sed -i 's/export bunch_charge=.*/export bunch_charge='$mint'e11/' sixdeskenv
    sed -i 's/export emit=.*/export emit=2.50/' sixdeskenv

    $sixdesk_path/set_env.sh -s #create study
    $sixdesk_path/mad6t.sh -c -o 0 > /dev/null #check
    if [ "$?" -ne "0" ]
    then
        rm -rf sixtrack_input/*
        $sixdesk_path/mad6t.sh -s -o 0 >&1 | grep 'job(s) submitted to cluster' &> /dev/null #submit
        if [ $? != 0 ]; then
            echo $mask >> errors_submitMAD_${today}.txt
        else
            echo ">>>>>> "${mask}" - - SUBMITTED OK"
        fi
    fi
done
