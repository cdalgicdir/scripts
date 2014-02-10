#! /bin/bash

bondlist=('CN-CA' 'CA-CN' 'CA-L' 'CA-KC' 'KC-KN')
bondRlist=('0.2112' '0.196' '0.263' '0.259' '0.3194')
bondNlist=('14' '14' '8' '6' '6')
anglist=('CN-CA-CN' 'CA-CN-CA' 'CN-CA-L' 'L-CA-CN' 'CN-CA-KC' 'KC-CA-CN' 'CA-KC-KN')
dihlist=('CN-CA-CN-CA' 'CA-CN-CA-CN' 'CA-CN-CA-KC' 'CN-CA-KC-KN' 'CA-CN-CA-L')
implist=('CA-CN-CN-L' 'CA-CN-KC-CN')

mkdir -p histograms time-data

for i in `seq 0 $((${#bondlist[@]}-1))`; do
    for j in `seq 1 ${bondNlist[$i]}`; do
	b=${bondlist[$i]}
	r=${bondRlist[$i]}
	echo bond_${b}-$j | g_bond -f traj.xtc -s -n bonded.ndx -o bond_${b}-$j.xvg -d time_bond_${b}-$j.xvg -blen $r
	mv bond_${b}-$j.xvg histograms/
	mv time_bond_${b}-$j.xvg time-data/
    done
done

for i in `seq 0 $((${#bondlist[@]}-1))`; do
    b=${bondlist[$i]}
    r=${bondRlist[$i]}
    echo bond_${b} | g_bond -f traj.xtc -s -n bonded.ndx -o bond_${b}_avg.xvg -d time_bond_${b}.xvg -blen $r
    mv bond_${b}_avg.xvg histograms/
    mv time_bond_${b}.xvg time-data/
done

for a in ${anglist[@]}; do
    echo ang_${a} | g_angle -f traj.xtc -n bonded.ndx -type angle -od ang_${a}_avg.xvg -ov time_ang_${a}.xvg -all
    g_analyze -f time_ang_${a}.xvg -dist ang_${a}.xvg -bw 1
    python split-hists.py ang_${a}.xvg
    rm ang_${a}.xvg
    for f in `ls ang_${a}*.xvg`; do
	awk 'BEGIN{pi=4*atan2(1.0,1.0)}{if ($1 !~ /^[@|#]/) print $1/180*pi,$2*180/pi}' ${f} > ${f}.bak
	rm ${f}
	mv ${f}.bak ${f}
    done
    mv ang_${a}_avg.xvg ang_${a}-*.xvg histograms/
    mv time_ang_${a}.xvg time-data/
done

for d in ${dihlist[@]}; do
    echo dih_${d} | g_angle -f traj.xtc -n bonded.ndx -type dihedral -od dih_${d}_avg.xvg -ov time_dih_${d}.xvg -all
    g_analyze -f time_dih_${d}.xvg -dist dih_${d}.xvg -bw 1
    python split-hists.py dih_${d}.xvg
    rm dih_${d}.xvg
    for f in `ls dih_${d}*.xvg`; do
	awk 'BEGIN{pi=4*atan2(1.0,1.0)}{if ($1 !~ /^[@|#]/) print $1/180*pi,$2*180/pi}' ${f} > ${f}.bak
	rm ${f}
	mv ${f}.bak ${f}
    done
    mv dih_${d}_avg.xvg dih_${d}-*.xvg histograms/
    mv time_dih_${d}.xvg time-data/
done

for i in ${implist[@]}; do
    echo imp_${i} | g_angle -f traj.xtc -n bonded.ndx -type improper -od imp_${i}_avg.xvg -ov time_imp_${i}.xvg -all
    g_analyze -f time_imp_${i}.xvg -dist imp_${i}.xvg -bw 1
    python split-hists.py imp_${i}.xvg
    for f in `ls imp_${i}*.xvg`; do
	awk 'BEGIN{pi=4*atan2(1.0,1.0)}{if ($1 !~ /^[@|#]/) print $1/180*pi,$2*180/pi}' ${f} > ${f}.bak
	rm ${f}
	mv ${f}.bak ${f}
    done
    rm imp_${i}.xvg
    mv imp_${i}_avg.xvg imp_${i}-*.xvg histograms/
    mv time_imp_${i}.xvg time-data/
done

for i in `seq 1 11`; do
    echo dist-CNi-CNi4-${i}a dist-CNi-CNi4-${i}b | g_dist -f traj.xtc -n bonded.ndx -o time_dist_CNi-CNi4-$i
done

awk '{if ($1 !~ /^[@|#]/) print $2}' time_dist_CNi-CNi4-1.xvg > time_dist_CNi-CNi4.xvg
for f in time_dist_CNi-CNi4-[2-9].xvg  time_dist_CNi-CNi4-??.xvg; do
    awk '{if ($1 !~ /^[@|#]/) print $2}' $f | paste time_dist_CNi-CNi4.xvg - > out.tmp
    rm time_dist_CNi-CNi4.xvg
    mv out.tmp time_dist_CNi-CNi4.xvg
done

# generate average for timeline of distance
awk '{if ($1 !~ /^[@|#]/) {for (i=1;i<=NF;i++){x+=$i}{print $1,x/(NF-1);x=0.}}}' time_dist_CNi-CNi4.xvg > time_dist_CNi-CNi4_avg.xvg
# remove time column
awk '{for (i=1;i<=NF-1;i++){printf $i "\t"}{print $NF}}' time_dist_CNi-CNi4.xvg > out.tmp
# merge average timeline data with the rest
paste time_dist_CNi-CNi4_avg.xvg out.tmp > time_dist_CNi-CNi4.xvg
# generate histograms for all
g_analyze -f time_dist_CNi-CNi4.xvg -dist dist_CNi-CNi4.xvg -bw 0.001
# split the histograms
python split-hists.py dist_CNi-CNi4.xvg
# generate average for histogram
# dump all columns to tmp
paste dist_CNi-CNi4-?.xvg dist_CNi-CNi4-??.xvg > out3.tmp
# dump time column to tmp
awk '{if ($1 !~ /^[@|#]/) print $1}' out3.tmp > out2.tmp
# add all columns and paste with time to generate average histogram
awk '{if ($1 !~ /^[@|#]/) {for (i=4;i<=NF;i+=2){x+=$i}{print $1,x/((NF/2)-1);x=0.}}}' out3.tmp > dist_CNi-CNi4_avg.xvg
rm out.tmp out2.tmp
rm dist_CNi-CNi4.xvg time_dist_CNi-CNi4.xvg
mv dist_CNi-CNi4-*.xvg dist_CNi-CNi4_avg.xvg histograms/
mv time_dist_CNi-CNi4-* time_dist_CNi-CNi4_avg.xvg time-data/

