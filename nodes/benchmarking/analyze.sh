#! /bin/bash

for d in trial-*;do
    pushd $d
    progress -d "`ls -dv ncor*`" -nc | awk '{sub(/ncore-/,"",$1);sub(/\/md.log/,"",$1);print $1,$3}' > stat
    popd
done

for d in trial-*;do
    awk '{print $1}' $d/stat > $d/tmp.1
    awk '{print $2}' $d/stat > $d/tmp.2
done

paste trial-*/tmp.2 > TMP.2
awk '{for(i=t=0;i<NF;) t+=$++i/NF; $0=t}1' TMP.2 > TMP.22
paste trial-2/tmp.1 TMP.22 > STAT

rm trial-*/tmp*
rm TMP*
