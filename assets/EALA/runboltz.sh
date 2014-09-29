#! /bin/bash

cat boltzmann.comms | csg_boltzmann --top ../topol.tpr --trj ../traj.xtc --cg "EALA.xml"

for f in bond*xvg ang*xvg imp*xvg dih*xvg time_*xvg; do
    if [[ $f == time_*xvg ]]; then
	awk 'BEGIN{pi=4.0*atan2(1,1)}{print $1,$2/pi*180}' $f > tmp
    else
	awk 'BEGIN{pi=4.0*atan2(1,1)}{print $1/pi*180,$2}' $f > tmp
    fi
    mv tmp $f
done

mkdir -p histograms time-data
mv time_*xvg time-data/
mv *xvg histograms/
