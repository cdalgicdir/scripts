#! /bin/bash

hom=`pwd`
analysisdir=WHAM_analysis
mkdir $analysisdir
#copy necessary files to analysis directory
for d in d?.???
do
    rsync -avzr $d/4-PULL/topol.tpr $analysisdir/topol_$d.tpr
    rsync -avzr $d/4-PULL/pullf.xvg $analysisdir/pullf_$d.xvg
    #rsync -avzr $d/3-PULL/pullx.xvg $analysisdir/pullx_$d.xvg
done

pushd $analysisdir
#create necessary filelists
#for x in pullx_d*;do echo $x >> pullx-files.dat;done
for f in pullf_d*;do echo $f >> pullf-files.dat;done
for t in topol_d*;do echo $t >> tpr-files.dat;done

# analyse
divide=4

maxdist=3.8
mindist=0.84

init=0
final=100000

increment=$(((final-init)/divide))
begin=$init
end=$increment

#for i in `seq 1 $divide`; do
#    n=$((end/increment))
#    echo $begin $end $increment
#    g_wham -if pullf-files.dat -it tpr-files.dat -o $hom/profile_${n}of${divide}.xvg -hist $hom/histo_${n}of${divide}.xvg -bins 200 -b $begin -e $end -min $mindist -max $maxdist -nBootstrap 200 -bsres $hom/bsResult_${n}of${divide}.xvg -bsprof $hom/bsProfs_${n}of${divide}.xvg
#    begin=$((begin+increment))
#    end=$((end+increment))
#done

# all trajectory
g_wham -if pullf-files.dat -it tpr-files.dat -o $hom/profile.xvg -hist $hom/histo.xvg -bins 200 -nBootstrap 200 -bsres $hom/bsResult.xvg -bsprof $hom/bsProfs.xvg
popd

cp $analysisdir/pullf-files.dat names-histo.dat
sed -i 's/\(pullf_d\|.xvg\)//g' names-histo.dat 
