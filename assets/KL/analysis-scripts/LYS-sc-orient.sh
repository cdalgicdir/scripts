#! /bin/bash

trj="traj.xtc"
gro="conf.gro"
ndx="nh3.ndx"
tpr="topol.tpr"

n=2

shift=17
make_ndx -f $gro -i $ndx << EOF
splitch 4
splitres $((shift+1))
24|25|26|27
name 36 p1a
28|29|30|31
name 37 p1b
splitres $((shift+2))
42|43|44|45
name 54 p2a
46|47|48|49
name 55 p2b
a NZ
splitch 56
q
EOF

for i in `seq 1 $n`; do
    for g in p${i}a p${i}b; do
        echo $g | g_traj -f $trj -s $tpr -n $ndx -com -ox coord-$g
        egrep -v "#|@" coord-$g.xvg > coord-$g.dat
    done
    paste coord-p${i}a.dat coord-p${i}b.dat > coord-p${i}-ab.dat
    awk '{print $1,$6-$2,$7-$3,$8-$4}' coord-p${i}-ab.dat > coord-p${i}-diff.xvg
    awk '{print $1,$2,$3,$4}' coord-p${i}-diff.xvg > coord-p${i}-diff.dat
    rm coord-p${i}[ab].dat coord-p${i}-ab.dat coord-p$i-diff.xvg
    echo NZ_chain$i | g_traj -f $trj -s $tpr -n $ndx -com -ox coord-nh3-$i
    awk '{if ($1 !~ /^[#|@]/) print $2,$3,$4}' coord-nh3-$i.xvg > coord-nh3-$i.dat
    paste coord-p${i}-diff.dat coord-nh3-$i.dat > a.tmp
    awk '{print $1,$5-$2,$6-$3,$7-$4}' a.tmp > backbone-nh3-diff.dat
    rm a.tmp
done

