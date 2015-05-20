#! /bin/bash

SMAPDIR=$HOME/progs/toolkits/sketchmap
export PATH=$PATH:$SMAPDIR/bin:$SMAPDIR/utils

N=28
pi=6.283185
imix=0.0001

sigma=8
A=16
B=16
a=1
b=2
#mode="minmax" #staged (gamma,w_gamma parameters needed)
mode="staged"
gamma=$1
wgamma=$2

dimdist -D $N -P highd-dataset -pi $pi -maxd 15 -nbin 300 -wbin 0.05 -lowmem > highd-histo
#dimlandmark -D $N -n 1000 -pi $pi -mode $mode -w -lowmem < highd-dataset > highd-landmarks
dimlandmark -D $N -n 1000 -pi $pi -mode $mode -w -lowmem < highd-dataset > highd-landmarks -gamma $gamma -wgamma $wgamma
grep -v \# highd-landmarks | dimred -D $N -pi $pi -d 2 -w -center > lowd-mds
grep -v \# highd-landmarks | dimred -D $N -pi $pi -d 2 -w -center -init lowd-mds -grid 10.0,21,201 -preopt 50 -gopt 3 > lowd-gmds-metric
for imix in 0.1 0.01 0.001 0.0001 0.00001 0.000001 0.0000001 0.00000001 0.000000001; do grep --color=auto -v \# highd-landmarks | dimred -D $N -pi $pi -d 2 -w -center -init lowd-gmds-metric -grid 15.0,21,201 -fun-hd $sigma,$A,$B -fun-ld $sigma,$a,$b -imix $imix -preopt 50 -gopt 3 > lowd-gmds-smap_${imix};done
#grep --color=auto -v \# highd-landmarks | dimred -D $N -pi $pi -d 2 -w -center -init lowd-gmds-metric -grid 15.0,21,201 -fun-hd $sigma,$A,$B -fun-ld $sigma,$a,$b -imix $imix -preopt 50 -gopt 3 > lowd-gmds-smap_${imix}
ln -s lowd-gmds-smap_${imix} lowd-landmarks
# project
grep -v \# highd-landmarks > highd-landmarks.dat
dimproj -D $N -d 2 -P highd-landmarks.dat -p lowd-landmarks -pi $pi -w -grid 15.0,21,201 -fun-hd $sigma,$A,$B -fun-ld $sigma,$a,$b -cgmin 3 < highd-dataset > lowd-new

# to compute histogram
#dimdist -D $N -d 2 -w -P highd_landmarks.dat -p lowd_projection -pi 6.283185 -lowmem -gnuplot -maxd 15 50 -nbin 150 250 -wbin 0.2 > ddplot.histo

#sketch-map.sh
#echo -e "$N\ny\n" | sketch-map.sh

# analyze
for f in lowd-gmds-smap_0.*1;do gencorr $f;mv lowd-gmds-smap_0.corr ${f}.corr;ramaplot ${f}.corr -auto -png -t "${f}";done
convert -delay 50 lowd-gmds-smap_0.*png -loop 0 animate.gif

# projection
cat << EOF | gnuplot
set term pngcairo
set out "lowd-new-proj.png"
set title "$mode-g$gamma-wg$wgamma"
set palette functions (2*cos(gray*pi+pi/3)**4+cos(gray*pi+pi*0.66)**2)/3, 0.5*cos(gray*pi+pi*0.55)**8, (cos(gray*pi-pi/6)**4*2+cos(gray*pi+pi*0.66)**8)/3;set cbrange [-pi:pi]
plot '< paste lowd-new highd-dataset' u 1:2:15 w p pt 7 ps 0.1 lt pal not
EOF
