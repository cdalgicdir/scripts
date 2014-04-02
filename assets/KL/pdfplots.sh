#! /bin/bash

source $HOME/SIMS/KLcg/dirs.sh
hom=`pwd`

dirlist=("." "../140228_cgw0.2-vBB-noii4-nb1" "../140228_cgw0.5-vBB-noii4-nb1" "../140205_cg-vacBBdih-ii4p" "$tetdir" "$vacdir")
tlist=("cgw0.1" "cgw0.2" "cgw0.5" "cg-vBB-ii4" "tetramer" "vac-excl")

# HISTOGRAMS directory
histdir='histograms'
#cd ${histdir}


###################################################################
# Plot Comparisons of Averages
###################################################################

flist=('bond_CN-CA_avg.xvg' 'bond_CA-CN_avg.xvg' 'bond_CA-L_avg.xvg' 'bond_CA-KC_avg.xvg' 'bond_KC-KN_avg.xvg' 'ang_CN-CA-CN_avg.xvg' 'ang_CA-CN-CA_avg.xvg' 'ang_CN-CA-L_avg.xvg' 'ang_L-CA-CN_avg.xvg' 'ang_CN-CA-KC_avg.xvg' 'ang_KC-CA-CN_avg.xvg' 'ang_CA-KC-KN_avg.xvg' 'dih_CN-CA-CN-CA_avg.xvg' 'dih_CA-CN-CA-CN_avg.xvg' 'dih_CA-CN-CA-KC_avg.xvg' 'dih_KC-CA-CN-CA_avg.xvg' 'dih_CN-CA-KC-KN_avg.xvg' 'dih_KN-KC-CA-CN_avg.xvg' 'dih_CA-CN-CA-L_avg.xvg' 'dih_L-CA-CN-CA_avg.xvg' 'imp_CA-CN-CN-L_avg.xvg' 'imp_CA-CN-KC-CN_avg.xvg' 'dist_CNi-CNi4_avg.xvg' 'table_L_wall0.xvg' 'tablep.xvg')

q="'"
u=" using 1:2 with line title "
terminal="pdfcairo font \"Gill Sans,16\" lw 3 rounded"
pdflist=()

keyleftlist=('dih_CA-CN-CA-CN_avg.xvg' 'ang_CA-KC-KN_avg.xvg' 'ang_KC-CA-CN_avg.xvg' 'ang_CN-CA-L_avg.xvg' 'ang_L-CA-CN_avg.xvg' 'ang_CA-CN-CA_avg.xvg' 'bond_KC-KN_avg.xvg' 'bond_CA-KC_avg.xvg' 'dih_L-CA-CN-CA_avg.xvg' 'dih_KC-CA-CN-CA_avg.xvg')

yrangelist=('dih_CN-CA-KC-KN_avg.xvg' 'dih_KN-KC-CA-CN_avg.xvg')

for f in ${flist[@]}; do
    plcomms=""
    for i in `seq 0 $((${#dirlist[@]}-1))`; do
	t=${tlist[$i]}
	# plotting tabular potentials
	if [[ $f == table* ]]; then
	   dir="${dirlist[$i]}"
	   u=" using 1:6 with line title "
	else
	   dir=${dirlist[$i]}/$histdir
	   u=" using 1:2 with line title "
       fi
	plcomms="${plcomms}""${q}${dir}/${f}${q}${u}${q}${t}${q},"
    done
    outname="`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/'`"
    pdflist+=("$outname")
    if [[ "${yrangelist[@]}" =~ ${f} ]] && [[ ! "${dirlist[@]}" =~ $vacdir ]] ; then
	gplot -c "set yrange[0:1]" -o "${outname}" --term "${terminal}" -t "${f%.xvg}" -- "${plcomms}"
    elif [[ ${keyleftlist[@]} == *"${f}"* ]]; then
	gplot -o "${outname}" --term "${terminal}" -c "set key left top" -t "${f%.xvg}" -- "${plcomms}"
    elif [[ $f == table* ]]; then
	gplot -c "set yrange[*:100]" -c "set xrange[0:1.5]" -o "${outname}" --term "${terminal}" -t "${f%.xvg}" -- "${plcomms}"
    else
	gplot -o "${outname}" --term "${terminal}" -t "${f%.xvg}" -- "${plcomms}"
    fi
done


###################################################################
# Plot All
###################################################################

plotall=1
if [[ $plotall == 1 ]]; then
plots=`egrep "^hist [badi]" boltzmann.comms | awk '{print $2}'`

q="'"
u=" using 1:2 with line title "
plcomms=''
terminal="pdfcairo font \"Gill Sans,16\" lw 2 rounded"

for f in ${plots[@]}; do
    if [[ ${f} != *_avg.xvg ]]; then
	plcomms=${plcomms}${q}${histdir}/${f}${q}${u}${q}${j}${q}","
	let j=$j+1
    else
	plcomms=${plcomms}${q}${histdir}/${f}${q}${u}"'avg'"
	outname=`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/' | sed 's/avg/all/'`
	if [[ "${yrangelist[@]}" =~ ${f} ]]; then
	    gplot -c "set yrange [0:1]" -c "set style data line" -o "${outname}" --term "${terminal}" -t "${f%_avg.xvg}" -- ${plcomms}
	else
	    gplot -c "set style data line" -o "${outname}" --term "${terminal}" -t "${f%_avg.xvg}" -- ${plcomms}
	fi
	pdflist+=("$outname")
	plcomms=""
	j=1
    fi
done
fi

mkdir -p report
for pdf in ${pdflist[@]}; do
    mv ${pdf} report/
done
#mv ${histdir}/*pdf report/
cd report/
#cp $HOME/SIMS/KL/plots/distributions-all.tex .
pdflatex -shell-escape -interaction=nonstopmode distributions-all.tex
rm *.aux *.log
mupdf distributions-all.pdf &
cd ../

