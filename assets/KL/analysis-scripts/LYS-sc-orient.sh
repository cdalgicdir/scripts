#! /bin/bash

trj="out.xtc"
gro="conf.gro"
ndx="lys-sc.ndx"
tpr="topol.tpr"
end=100

n=2

shift=17
make_ndx -f $gro -o $ndx << EOF
splitch 4
r LYS & 8
splitch $((shift+n+1))
q
EOF

for i in `seq 1 $n`; do
    echo Backbone_chain$i | g_traj -f $trj -s $tpr -n $ndx -com -ox coord-backbone-$i
    awk '{if ($1 !~ /^[#|@]/) print}' coord-backbone-$i.xvg > coord-backbone-$i.dat
    echo "LYS_&_SideChain_chain$i" | g_traj -f $trj -s $tpr -n $ndx -com -ox coord-nh3-$i
    awk '{if ($1 !~ /^[#|@]/) print}' coord-nh3-$i.xvg > coord-nh3-$i.dat
    paste coord-nh3-$i.dat coord-backbone-$i.dat > backbone-lyssc-$i.dat
    awk '{if ($1==$5) print $1,$6-$2,$7-$3,$8-$4}' backbone-lyssc-$i.dat > backbone-lyssc-diff-$i.dat
    rm coord-backbone-$i.dat coord-nh3-$i.dat
done

