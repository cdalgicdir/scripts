#! /bin/bash

hom="$HOME/sketchmap/remd"

for g in 0.1 0.2 0.3 0.4; do
    for wg in 1 2 3 4; do
	dir="g$g-wg$wg"
	mkdir $dir; pushd $dir
	ln -s $hom/traj.xtc .
	ln -s $hom/topol.tpr .
	ln -s $hom/rama.formatted-rad.dat highd-dataset
	bash $hom/do-sketchmap.sh
	popd
    done
done

