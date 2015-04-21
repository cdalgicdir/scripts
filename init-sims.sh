#! /bin/bash

NSLOTS=4
maindir="/mnt/data/cdalgicdir/SIMS/EALA-cg/CA-AB-mapping"
hom=`pwd`
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

    del_pids=()
    for i in `seq 0 ${#statuslist[@]}`; do
	[[ ${statuslist[$i]} == 1 ]] && del_pids+=(${pidlist[$i]})
    done
    echo ${del_pids[@]}
}

checkstatus () {
    new_job="$(jobs -n)"
    [ -n "$new_job" ] && pid=$! || pid=
    pidlist+=($pid)

    nn=`jobs -p | wc -l`
    if [[ $nn -ge $NSLOTS ]]; then
	del_pids=$(waitfor_pidlist $pidlist)
	for del in ${del_pids[@]}; do
	    pidlist=(${pidlist[@]/$del})
	done
    fi
}

checkstatus_nopid () {
    new_job="$(jobs -n)"
    [ -n "$new_job" ] && pid=$! || pid=
    nn=`jobs -p | wc -l`

    while [[ $nn -ge $NSLOTS ]]; do
	sleep 10
	nn=`jobs -p | wc -l`
    done
}

###################################################################
# DO STUFF
###################################################################

for j in 1 3 4; do
    scalej=`echo "$j / 10" | bc -l | awk '{printf "%.1f", $0}'`
    newdir2="tablepx${scalej}"
    mkdir -p $newdir2 && pushd $newdir2
    cp $hom/* .
    awk -v i=$scalej '{print $1,0,0,0,0,$6*i,$7*i}' $hom/tablep.xvg > tablep.xvg
for i in `seq 1 20`; do
    scale=`echo "$i / 10" | bc -l | awk '{printf "%.1f", $0}'`
    newdir="dih_CACACACAx${scale}"
    mkdir $newdir && pushd $newdir
    for f in ${flist[@]}; do
	ln -s ../$f .
    done
    awk -v i=$scale '{print $1,$2*i,$3*i}' ../table_dih_CA-CA-CA-CA-fit.xvg > table_d6.xvg
    bash $maindir/run.sh &

###################################################################
# END OF DO STUFF
###################################################################

    checkstatus_nopid
    
    popd
done
popd
done

