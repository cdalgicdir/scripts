#! /bin/bash

bondlist=('CN-CA' 'CA-CN' 'CA-L' 'CA-KC' 'KC-KN')
bondRlist=('0.2112' '0.196' '0.263' '0.259' '0.3194')
bondNlist=('14' '14' '8' '6' '6')
anglist=('CN-CA-CN' 'CA-CN-CA' 'CN-CA-L' 'L-CA-CN' 'CN-CA-KC' 'KC-CA-CN' 'CA-KC-KN')
dihlist=('CN-CA-CN-CA' 'CA-CN-CA-CN' 'CA-CN-CA-KC' 'CN-CA-KC-KN' 'CA-CN-CA-L')
implist=('CA-CN-CN-L' 'CA-CN-KC-CN')

mkdir -p bonded-histograms bonded-time-data

for i in `seq 0 $((${#bondlist[@]}-1))`; do
    for j in `seq 1 ${bondNlist[$i]}`; do
	b=${bondlist[$i]}
	r=${bondRlist[$i]}
	echo bond_${b}-$j | g_bond -f traj.xtc -s -n bonded-all.ndx -o hist_bond_${b}-$j.xvg -d time-bond_${b}-$j.xvg -blen $r
	mv hist_bond_${b}-$j.xvg bonded-histograms/
	mv time-bond_${b}-$j.xvg bonded-time-data/
    done
done

for i in `seq 0 $((${#bondlist[@]}-1))`; do
    b=${bondlist[$i]}
    r=${bondRlist[$i]}
    echo bond_${b} | g_bond -f traj.xtc -s -n bonded.ndx -o bond_${b}.xvg -d time-bond_${b}.xvg -blen $r
    mv bond_${b}.xvg bonded-histograms/
    mv time-bond_${b}.xvg bonded-time-data/
done

for a in ${anglist[@]}; do
    echo ang_${a} | g_angle -f traj.xtc -n bonded.ndx -type angle -od ang_${a}.xvg -ov time-ang_${a}.xvg -all
    g_analyze -f time-ang_${a}.xvg -dist hist_ang_${a}.xvg
    mv ang_${a}.xvg hist_ang_${a}.xvg bonded-histograms/
    mv time-ang_${a}.xvg bonded-time-data/
done

for d in ${dihlist[@]}; do
    echo dih_${d} | g_angle -f traj.xtc -n bonded.ndx -type dihedral -od dih_${d}.xvg -ov time-dih_${d}.xvg -all
    g_analyze -f time-dih_${d}.xvg -dist hist_dih_${d}.xvg
    mv dih_${d}.xvg hist_dih_${d}.xvg bonded-histograms/
    mv time-dih_${d}.xvg bonded-time-data/
done

for i in ${implist[@]}; do
    echo imp_${i} | g_angle -f traj.xtc -n bonded.ndx -type improper -od imp_${i}.xvg -ov time-imp_${i}.xvg -all
    g_analyze -f time-imp_${i}.xvg -dist hist_imp_${i}.xvg
    mv imp_${i}.xvg hist_imp_${i}.xvg bonded-histograms/
    mv time-imp_${i}.xvg bonded-time-data/
done

