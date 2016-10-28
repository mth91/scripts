#!/bin/bash

while getopts "s:f:i:n:" OPTION
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
		n)
			echo The project name is $OPTARG
			projectname=$OPTARG
			;;
	esac
done

until [ $startpoint -gt $endpoint ]; do
	grompp -f md-vibration.mdp -c npt-${projectname}-${startpoint}.gro -t npt-${projectname}-${startpoint}.cpt -p topol.top -n index.ndx -o md-${projectname}-${startpoint}.tpr
	send_MD_job -q "-l nodes=1:amd:ppn=8,vmem=4gb,mem=4gb,walltime=12:00:00" md-${projectname}-${startpoint}
	let startpoint=$startpoint+$timeinterval
	#startpoint=$(($startpoint + $timeinterval))
done

