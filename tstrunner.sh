#!/bin/bash
#
#	AUTHOR - Raman Sailopal
#
#	Pass the name of line label/routine as the the first parameter, a 1
#	as the second parameter to delete existing JOBEXAM files and 1 as the
#	the third parameter to run the test runner against baseline figures
#
if [[ "$1" == "" ]]
then
	echo "Pass a routine to run as the first parameter"
	exit
fi
if [[ "$2" == "1" ]]
then
	rm -f *JOBEXAM*
fi
if [[ "$3" == "1" ]]
then
        linlab=$(awk -F [\(^] '{ print $1 }' <<< "$1")
        rout=$(awk -F [\(^] '{ print $2 }' <<< "$1")
        if test -e "baseline/"$linlab"_"$rout
        then
         	cp "baseline/"$linlab"_"$rout $linlab"_"$rout"_JOBEXAM_BASELINE"
        else
		echo "file - baseline/"$linlab"_"$rout" doesn't exist"
		exit
	fi
fi
ydb <<< "D strt^%TSTRUNNER(\"$1\")"
