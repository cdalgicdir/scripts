#! /bin/bash

bondlist=('CN-CA' 'CA-CN' 'CA-L' 'CA-KC' 'KC-KN')
bondRlist=('0.2112' '0.196' '0.263' '0.259' '0.3194')
bondNlist=('14' '14' '8' '6' '6')
anglist=('CN-CA-CN' 'CA-CN-CA' 'CN-CA-L' 'CN-CA-KC' 'CA-KC-KN')
dihlist=('CN-CA-CN-CA' 'CA-CN-CA-CN' 'CA-CN-CA-KC' 'CN-CA-KC-KN' 'CA-CN-CA-L')
implist=('CA-CN-CN-L' 'CA-CN-KC-CN')

mkdir -p histograms time-data

for i in `seq 0 $((${#bondlist[@]}-1))`; do
    for j in `seq 1 ${bondNlist[$i]}`; do
	b=${bondlist[$i]}
	r=${bondRlist[$i]}
	echo bond_${b}-$j | g_bond -f traj.xtc -s -n bonded-all.ndx -o bond_${b}-$j.xvg -d time_bond_${b}-$j.xvg -blen $r
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
    g_analyze -f traj.xtc time_ang_${a}.xvg -dist ang_${a}.xvg -bw 1
    python split-hists.py ang_${a}.xvg
    rm ang_${a}.xvg
    mv ang_${a}_avg.xvg ang_${a}-*.xvg histograms/
    mv time_ang_${a}.xvg time-data/
done

for d in ${dihlist[@]}; do
    echo dih_${d} | g_angle -f traj.xtc -n bonded.ndx -type dihedral -od dih_${d}_avg.xvg -ov time_dih_${d}.xvg -all
    g_analyze -f time_dih_${d}.xvg -dist dih_${d}.xvg -bw 1
    python split-hists.py dih_${d}.xvg
    rm dih_${d}.xvg
    mv dih_${d}_avg.xvg dih_${d}-*.xvg histograms/
    mv time_dih_${d}.xvg time-data/
done

for i in ${implist[@]}; do
    echo imp_${i} | g_angle -f traj.xtc -n bonded.ndx -type improper -od imp_${i}_avg.xvg -ov time_imp_${i}.xvg -all
    g_analyze -f time_imp_${i}.xvg -dist imp_${i}.xvg -bw 1
    python split-hists.py imp_${i}.xvg
    rm imp_${i}.xvg
    mv imp_${i}_avg.xvg imp_${i}-*.xvg histograms/
    mv time_imp_${i}.xvg time-data/
done

