#! /bin/bash

confdir="7-PULL/confs"
#confdir="7-PULLback/confs"
hom=$(pwd)
host=`hostname`
host=${host:0:5}

#for i in `seq 0 4 32`; do
#for i in 0 9 20 32 38 45 55 62 ; do
for i in 73 ; do
    pushd $confdir
    dist=`grep conf$i.gro distances.dat | awk '{print $2}'`
    popd
    PULLDIR=$hom/d$dist
    [[ -d $PULLDIR ]] && echo "$PULLDIR exists! Exiting..." && exit 1
    mkdir $PULLDIR
    cp $confdir/conf$i.gro $PULLDIR/conf.gro
    cp index.ndx *itp topol.top pull.mdp $PULLDIR
    cp em.mdp nvt.mdp npt.mdp xsubmit-doEQ xsubmit-thread $PULLDIR
    pushd $PULLDIR
    #grompp -f pull.mdp -c conf.gro -n index.ndx -p topol.top 
    #cp ~/xsubmit-files/$host/xsubmit-thread $PULLDIR
    sed -i 's/-N.*$/-N d'$dist'/' xsubmit-thread
    sed -i 's/-N.*$/-N d'$dist'/' xsubmit-doEQ
    /opt/gridengine/bin/lx26-amd64/qsub xsubmit-doEQ
    popd
done
