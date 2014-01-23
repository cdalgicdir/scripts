#! /bin/bash

bondlist=('CN-CA' 'CA-CN' 'CA-L' 'CA-KC' 'KC-KN')
bondRlist=('0.2112' '0.196' '0.263' '0.259' '0.3194')
anglist=('CN-CA-CN' 'CA-CN-CA' 'CN-CA-L' 'CN-CA-KC' 'CA-KC-KN')
dihlist=('CN-CA-CN-CA' 'CA-CN-CA-CN')
implist=('CA-CN-CN-L' 'CA-CN-KC-CN')

for i in `seq 0 $((${#bondlist[@]}-1))`; do
    b=${bondlist[$i]}
    r=${bondRlist[$i]}
    echo bond_${b} | g_bond -f -s -n bonded.ndx -o bond_${b}.xvg -d time-bond_${b}.xvg -blen $r
done

for a in ${anglist[@]}; do
    echo ang_${a} | g_angle -f -n bonded.ndx -type angle -od ang_${a}.xvg -ov time-ang_${a}.xvg -all
    g_analyze -f time-ang_${a}.xvg -dist hist_ang_${a}.xvg
done

for d in ${dihlist[@]}; do
    echo dih_${d} | g_angle -f -n bonded.ndx -type dihedral -od dih_${d}.xvg -ov time-dih_${d}.xvg -all
    g_analyze -f time-dih_${d}.xvg -dist hist_dih_${d}.xvg
done

for i in ${implist[@]}; do
    echo imp_${i} | g_angle -f -n bonded.ndx -type improper -od imp_${i}.xvg -ov time-imp_${i}.xvg -all
    g_analyze -f time-imp_${i}.xvg -dist hist_imp_${i}.xvg
done

