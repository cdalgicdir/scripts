#! /bin/bash

hom=`pwd`
remotedir="$HOME/remote"
KLdir="$HOME/SIMS/KL"
mapdir="$HOME/SIMS/KL/map/genitp"
nKLdir="$remotedir/scratch8/n-KL"

tetdir="$nKLdir/120608_KL4BbwLF/4-SIM/map"
#vacdir="$remotedir/yunus/KL/131216_vacuum-excl/trial-2/map/distributions"
kl7vacdir="$remotedir/yunus/KL/131216_vacuum-excl/7KL/map/distributions"
#bozsindir="$remotedir/bozgur-bonded/aa_SINMOL"
#bozsinexdir="$remotedir/bozgur-bonded/aa_SINMOL_excl"
bozsinexdir="$HOME/SIMS/bozgur/aa_SINMOL_excl"

# Bulk water
kl1dir="$nKLdir/131021_KLsbwL/map/"
kl2dir="$nKLdir/130121_2KL/map/"
kl3dir="$nKLdir/130408_3KL-cubic/7-NPT/map/"
kl4dir="$nKLdir/120608_KL4BbwLF/4-SIM/map/"
kl5dir="$nKLdir/130326_5KL/7-NPT/map/"
kl6dir="$remotedir/scratch7/KL/131204_6KL/7-Production/map/"
kl8dir="$nKLdir/130620_8KL/7-NPT/map/"

# Interface
kl1intdir="$remotedir/scratch10/120529_KLSiLF-54/4-SIM/map/"
kl2intdir="$remotedir/scratch4/130624_2KL-int/7-INT-nodistconstr/map/"

# @HOME
nKLhome="$HOME/SIMS/KL/n-KL-distributions"
tetdir="$nKLhome/4KL"
vacdir="$nKLhome/vacuum/140205_all-cutoff"

# HISTOGRAMS directory
histdir='histograms'
#cd ${histdir}

dirlist=("." "$tetdir" "$vacdir")
tlist=("cg-wall" "tetramer" "vac-excl")

###################################################################
# Plot Comparisons of Averages
###################################################################

flist=('bond_CN-CA_avg.xvg' 'bond_CA-CN_avg.xvg' 'bond_CA-L_avg.xvg' 'bond_CA-KC_avg.xvg' 'bond_KC-KN_avg.xvg' 'ang_CN-CA-CN_avg.xvg' 'ang_CA-CN-CA_avg.xvg' 'ang_CN-CA-L_avg.xvg' 'ang_L-CA-CN_avg.xvg' 'ang_CN-CA-KC_avg.xvg' 'ang_KC-CA-CN_avg.xvg' 'ang_CA-KC-KN_avg.xvg' 'dih_CN-CA-CN-CA_avg.xvg' 'dih_CA-CN-CA-CN_avg.xvg' 'dih_CA-CN-CA-KC_avg.xvg' 'dih_KC-CA-CN-CA_avg.xvg' 'dih_CN-CA-KC-KN_avg.xvg' 'dih_KN-KC-CA-CN_avg.xvg' 'dih_CA-CN-CA-L_avg.xvg' 'dih_L-CA-CN-CA_avg.xvg' 'imp_CA-CN-CN-L_avg.xvg' 'imp_CA-CN-KC-CN_avg.xvg' 'dist_CNi-CNi4_avg.xvg')

q="'"
u=" using 1:2 with line title "
terminal="pdfcairo font \"Gill Sans,16\" lw 3 rounded"
pdflist=()

keyleftlist=('dih_CA-CN-CA-CN_avg.xvg' 'ang_CA-KC-KN_avg.xvg' 'ang_KC-CA-CN_avg.xvg' 'ang_CN-CA-L_avg.xvg' 'ang_L-CA-CN_avg.xvg' 'ang_CA-CN-CA_avg.xvg' 'bond_KC-KN_avg.xvg' 'bond_CA-KC_avg.xvg' 'dih_L-CA-CN-CA_avg.xvg' 'dih_KC-CA-CN-CA_avg.xvg')

yrangelist=('dih_CN-CA-KC-KN_avg.xvg' 'dih_KN-KC-CA-CN_avg.xvg')

for f in ${flist[@]}; do
    plcomms=""
    for i in `seq 0 $((${#dirlist[@]}-1))`; do
	dir=${dirlist[$i]}/$histdir
	t=${tlist[$i]}
	plcomms="${plcomms}""${q}${dir}/${f}${q}${u}${q}${t}${q},"
    done
    outname="`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/'`"
    pdflist+=("$outname")
    if [[ ${yrangelist[@]} == *${f}*]] && [[ ! "${dirlist[@]}" =~ $vacdir ]] ; then
	gplot -c "set yrange[0:1]" -o "${outname}" --term "${terminal}" -t "${f%.xvg}" -- "${plcomms}"
    elif [[ ${keyleftlist[@]} == *"${f}"* ]]; then
	gplot -o "${outname}" --term "${terminal}" -c "set key left top" -t "${f%.xvg}" -- "${plcomms}"
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
plcomms=''
terminal="pdfcairo font \"Gill Sans,16\" lw 2 rounded"

for f in ${plots[@]}; do
    if [[ ${f} != *_avg.xvg ]]; then
	plcomms=${plcomms}${q}${histdir}/${f}${q}${u}${q}${j}${q}","
	let j=$j+1
    else
	plcomms=${plcomms}${q}${histdir}/${f}${q}${u}"'avg'"
	outname=`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/' | sed 's/avg/all/'`
	if [[ ${f} == "dih_CN-CA-KC-KN_avg.xvg" ]]; then
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
cp $HOME/SIMS/KL/plots/distributions-all.tex .
pdflatex -shell-escape -interaction=nonstopmode distributions-all.tex
rm *.aux *.log
mupdf distributions-all.pdf &
cd ../

