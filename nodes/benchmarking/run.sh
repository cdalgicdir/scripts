#! /bin/bash

submitfile="xsubmit"
tprfile="topol.tpr"
NAME="benchmark"
ntrials=4
cpus=(1 2 4 8 12 16 20 24 32 48 64 96 128 216 256)
additionalfiles=("plumed.dat" "coil.pdb")
filestobecopied=("$tprfile" "$submitfile" ${additionalfiles[@]})

for j in `seq 1 $ntrials`;do
    mkdir trial-$j
    for f in ${filestobecopied[@]}; do cp $f trial-$j;done
    pushd trial-$j
	for i in ${cpus[@]}; do
	    mkdir ncore-$i
	    pushd ncore-$i
	    for f in ${filestobecopied[@]}; do cp ../$f .;done
	    sed -i 's/BSUB -n.*$/BSUB -n '$i'/' $submitfile
	    sed -i 's/BSUB -J.*$/BSUB -J '${NAME}'/' $submitfile
	    bsub < $submitfile
	    popd
	done
    popd
done
