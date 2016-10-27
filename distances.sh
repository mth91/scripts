#!/bin/bash

while getopts "s:f:" OPTION
do
	case $OPTION in
		s)
			echo The value of -s is $OPTARG
			startsnap=$OPTARG
			;;
		f)
			echo The value of -f is $OPTARG
			endsnap=$OPTARG
			;;
	esac
done
until [ $startsnap -gt $endsnap ]; do
	g_dist -s md-tr2.tpr -f conf${startsnap}.gro -n index.ndx -o dist${startsnap}.xvg < groups.txt &>/dev/null
	let startsnap=startsnap+1
done
echo Hooray! Finished!
