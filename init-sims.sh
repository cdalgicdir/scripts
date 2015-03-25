#! /bin/bash

NSLOTS=4
maindir="/mnt/data/cdalgicdir/SIMS/EALA-cg/CA-AB-mapping"
hom=`pwd`
#flist=`ls | egrep -v "table_d6.xvg|init-sims.sh"`
flist=`find . -maxdepth 1 -type f | egrep -v "table_d6.xvg|init-sims.sh"`
pidlist=()

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

waitfor_pidlist () {
    pidlist=$1
    delay=10
    statuslist=()
    while [[ ${statuslist[@]} != *1* ]]; do
	statuslist=()
	for pid in ${pidlist[@]}; do
	    sleep $delay
	    ps -p$pid 2>&1 > /dev/null
	    statuslist+=($?)
	done
    done

    for i in `seq ${#statuslist[@]}`; do
	[[ ${statuslist[$i]} == 1 ]] && echo ${pidlist[$i]}
    done
}

checkstatus () {
    nn=`jobs -p | wc -l`
    echo "NN $nn"
    new_job="$(jobs -n)"
    [ -n "$new_job" ] && pid=$! || pid=
    pidlist+=($pid)

    if [[ $nn -ge $NSLOTS ]]; then
	#waitforpid $pid
	del_pids=$(waitfor_pidlist $pidlist)
	for del in ${del_pids[@]}; do
	    pidlist=(${pidlist[@]/$del})
	done
    fi
}

###################################################################
# DO STUFF
###################################################################

for j in 1 3 4; do
    scalej=`echo "$j / 10" | bc -l | awk '{printf "%.1f", $0}'`
    newdir2="tablepx${scalej}"
    mkdir $newdir2 && pushd $newdir2
    cp ../* .
    awk -v i=$scalej '{print $1,0,0,0,0,$6*i,$7*i}' $hom/tablep.xvg > tablep.xvg
for i in `seq 1 20`; do
    scale=`echo "$i / 10" | bc -l | awk '{printf "%.1f", $0}'`
    newdir="dih_CACACACAx${scale}"
    mkdir $newdir && pushd $newdir
    for f in ${flist[@]}; do
	ln -s ../$f .
    done
    awk -v i=$scale '{print $1,$2*i,$3*i}' ../table_dih_CA-CA-CA-CA-fit.xvg > table_d6.xvg
    grompp -f nvt-cg.mdp -c -n -p
    bash $maindir/run.sh &
    #sleep 60 &

    checkstatus
    
    popd
done
popd
done

