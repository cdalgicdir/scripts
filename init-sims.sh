#! /bin/bash

NSLOTS=2
maindir="/mnt/data/cdalgicdir/SIMS/EALA-cg/CA-AB-mapping"
hom=`pwd`
flist=`ls | egrep -v "table_d6.xvg|init-sims.sh"`

waitforpid () {
    pid=$1
    delay=10
    status=0
    while [ "$status" == "0" ]; do
	sleep $delay
	ps -p$pid 2>&1 > /dev/null
	status=$?
	echo "Waiting for $pid..."
    done
}

checkstatus () {
    nn=`jobs -p | wc -l`
    new_job="$(jobs -n)"
    [ -n "$new_job" ] && pid=$! || pid=

    if [[ $nn -ge $NSLOTS ]]; then
	waitforpid ${pidlist[0]}
    fi
}

###################################################################
# DO STUFF
###################################################################

for i in 1 2 3; do
    scale=`echo "$i / 10" | bc -l | awk '{printf "%.1f", $0}'`
    newdir="dih_CACACACAx${scale}"
    mkdir $newdir && pushd $newdir
    for f in ${flist[@]}; do
	ln -s $hom/$f .
    done
    awk -v i=$scale '{print $1,$2*i,$3*i}' ../table_dih_CA-CA-CA-CA-fit.xvg > table_d6.xvg
    grompp -f nvt-cg.mdp -c -n -p
    bash $maindir/run.sh &

    checkstatus
    
    popd
done

