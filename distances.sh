#!/bin/bash

while getopts "s:f:i:" OPTION
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
		i)
			echo The value of -i is $OPTARG
			timeinterval=$OPTARG
			;;
	esac
done
until [ $startsnap -gt $endsnap ]; do
	# execute g_dist, print out distance between given index groups 
	# (input via groups.txt so no manual interaction for every single run is needed)
	g_dist -s pull-25.tpr -f conf${startsnap}.gro -n index.ndx -o dist${startsnap}.xvg < groups.txt &>/dev/null
	# parse generated .xvg file into awk and print the timestep and distance into summary-distances.dat
	awk '/^[^@#]/ {print $1 " " $2}' dist${startsnap}.xvg >> summary-distances.dat
	# delete previously generated .xvg file
	rm dist${startsnap}.xvg
	# increment counter
	let startsnap=$startsnap+$timeinterval
done
echo Hooray! Finished!
