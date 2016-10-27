#!/bin/bash

while getopts "s:f:i:" OPTION
do
	case $OPTION in
		s)
			echo The value of -s is $OPTARG
			startpoint=$OPTARG
			;;
		f)
			echo The value of -f is $OPTARG
			endpoint=$OPTARG
			;;
		i)
			echo The value of -i is $OPTARG
			timeinterval=$OPTARG
			;;
	esac
done

until [ $startpoint -gt $endpoint ]; do
	grompp -f md-vibration.mdp -c npt-tr2-u-${startpoint}.gro -t npt-tr2-u-${startpoint}.cpt -p topol.top -n index.ndx -o md-tr2-u-${startpoint}.tpr
	send_MD_job -q "-l nodes=1:amd:ppn=8,vmem=4gb,mem=4gb,walltime=12:00:00" md-tr2-u-${startpoint}
	let startpoint=$startpoint+$timeinterval
	#startpoint=$(($startpoint + $timeinterval))
done

