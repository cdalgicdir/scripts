#! /bin/bash

trajfile='traj.xtc'
tpr='topol.tpr'
ndx='bb4ang.ndx'
n=4

for i in `seq 1 $n`; do
    #for g in p1a p1b p2a p2b p3a p3b p4a p4b; do
    for g in p${i}a p${i}b; do
	echo $g | g_traj -f $trajfile -s $tpr -n $ndx -com -ox coord-$g
	egrep -v "#|@" coord-$g.xvg > coord-$g.dat
    done
    paste coord-p${i}a.dat coord-p${i}b.dat > coord-p${i}-ab.dat
    awk '{print $1,$6-$2,$7-$3,$8-$4}' coord-p${i}-ab.dat > coord-p${i}-diff.xvg
    awk '{print $1,$2,$3,$4}' coord-p${i}-diff.xvg > coord-p${i}-diff.dat
    rm coord-p${i}[ab].dat coord-p${i}-ab.dat coord-p$i-diff.xvg
done

for i in `seq 1 $n`; do
    [[ $i == $n ]] && j=1 || j=$((i+1))
    angfile=ang_p${i}-p${j}.xvg
    distfile=dist_p${i}-p${j}.xvg
    distVangfile=distVang_p${i}-p${j}.xvg
    paste coord-p${i}-diff.dat coord-p${j}-diff.dat > coord-p${i}p${j}-diff.dat
    python calcangle.py coord-p${i}p${j}-diff.dat $angfile
    g_analyze -f $angfile -bw 1 -dist hist_${angfile}
    echo Backbone_chain$i Backbone_chain$j | g_dist -f $trajfile -o $distfile -s $tpr -n $ndx
    egrep -v "#|@" $distfile | awk '{print $2}' > ${distfile%.xvg}.dat
    awk '{print $1}' $angfile | paste ${distfile%.xvg}.dat - > ${distVangfile}
# correlation
    ###################################################################
    # only print columns with same no of lines
    awk '{if (NF==2) print}' ${distVangfile} > ${distVangfile}.tmp
    rm ${distVangfile} && mv ${distVangfile}.tmp ${distVangfile}
    ###################################################################
    gencorr ${distVangfile} 40
    cp ${distfile%.xvg}.dat ${distfile%.xvg}.dat.xvg
    g_analyze -f ${distfile%.xvg}.dat.xvg -bw 0.01 -dist hist_${distfile}
    rm ${distfile%.xvg}.dat.xvg 
done

#awk '{if (NR%13!=0)printf "%f ",$3," ";else print $3}' distVangle.corr > xxx 
