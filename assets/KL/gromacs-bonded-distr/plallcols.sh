#! /bin/bash

file="${1}"
q="'"
nf=`awk 'END{print NF}' ${file}`
plcomms=''

for i in `seq 3 2 $nf`; do
    plcomms="${plcomms}${q}${file}${q} using $i:$((i+1)) title ${q}${i}${q},"
done

# remove comma at the end of command
plcomms=${plcomms:0:$((${#plcomms}-1))}

#echo $plcomms
#gplot -c "set style data line" -- "${plcomms}"
if [[ ${file} == 'hist_dih_CN-CA-KC-KN_all.xvg' ]]; then
    gplot -c "set yrange [:0.04]" -o "`echo ${file} | sed 's/_/-/g' | sed 's/xvg/pdf/'`" --term "pdfcairo font \"Gill Sans,16\" lw 1 rounded"  -c "set style data line" -t "${file%.xvg}" -- "${plcomms}"
else
    gplot -o "`echo ${file} | sed 's/_/-/g' | sed 's/xvg/pdf/'`" --term "pdfcairo font \"Gill Sans,16\" lw 1 rounded"  -c "set style data line" -t "${file%.xvg}" -- "${plcomms}"
fi
