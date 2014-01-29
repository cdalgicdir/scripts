#! /bin/bash

hom=`pwd`
remotedir="$HOME/remote"
nKLdir="$remotedir/scratch8/n-KL"

tetdir="$nKLdir/120608_KL4BbwLF/4-SIM/map/histograms"
vacdir="$remotedir/yunus/KL/131216_vacuum-excl/trial-2/map/distributions"
kl7vacdir="$remotedir/yunus/KL/131216_vacuum-excl/7KL/map/distributions"
bozsindir="$remotedir/bozgur-bonded/aa_SINMOL"
bozsinexdir="$remotedir/bozgur-bonded/aa_SINMOL_excl"

# Bulk water
kl1dir="$nKLdir/131021_KLsbwL/map/histograms"
kl2dir="$nKLdir/130121_2KL/map/histograms"
kl3dir="$nKLdir/130408_3KL-cubic/7-NPT/map/histograms"
kl4dir="$nKLdir/120608_KL4BbwLF/4-SIM/map/histograms"
kl5dir="$nKLdir/130326_5KL/7-NPT/map/histograms"
kl6dir="$remotedir/scratch7/KL/131204_6KL/7-Production/map/histograms"
kl8dir="$nKLdir/130620_8KL/7-NPT/map/histograms"

# Interface
kl1intdir="$remotedir/scratch10/120529_KLSiLF-54/4-SIM/map/histograms"
kl2intdir="$remotedir/scratch4/130624_2KL-int/7-INT-nodistconstr/map/histograms-90"

# @HOME
nKLhome="$HOME/SIMS/KL/n-KL-distributions"
tetdir="$nKLhome/4KL/histograms"

# HISTOGRAMS directory
histdir='histograms'
cd ${histdir}

flist=('bond_CN-CA_avg.xvg' 'bond_CA-CN_avg.xvg' 'bond_CA-L_avg.xvg' 'bond_CA-KC_avg.xvg' 'bond_KC-KN_avg.xvg' 'ang_CN-CA-CN_avg.xvg' 'ang_CA-CN-CA_avg.xvg' 'ang_CN-CA-L_avg.xvg' 'ang_L-CA-CN_avg.xvg' 'ang_CN-CA-KC_avg.xvg' 'ang_KC-CA-CN_avg.xvg' 'ang_CA-KC-KN_avg.xvg' 'dih_CN-CA-CN-CA_avg.xvg' 'dih_CA-CN-CA-CN_avg.xvg' 'dih_CA-CN-CA-KC_avg.xvg' 'dih_CN-CA-KC-KN_avg.xvg' 'dih_CA-CN-CA-L_avg.xvg' 'imp_CA-CN-CN-L_avg.xvg' 'imp_CA-CN-KC-CN_avg.xvg' 'dist_CNi-CNi4_avg.xvg')

for f in ${flist[@]}; do
    gplot -o "`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/'`" --term "pdfcairo font \"Gill Sans,16\" lw 3 rounded"  -t "${f%.xvg}" ${f} u 1:2 w l t \'CG\'\,\'$tetdir/$f\' u 1:2 w l t \'tetramer\'
done

plots=`egrep "^hist [badi]" ${hom}/boltzmann.comms | awk '{print $2}'`

q="'"
plcomms=''
for f in ${plots[@]}; do
    if [[ ${f} != *_avg.xvg ]]; then
	plcomms=${plcomms}${q}${f}${q}" using 1:2 t "${q}${j}${q}","
	let j=$j+1
    else
	plcomms=${plcomms}${q}${f}${q}" using 1:2 t 'avg'"
	if [[ ${f} == "dih_CN-CA-KC-KN_avg.xvg" ]]; then
	    gplot -c "set yrange [0:1]" -c "set style data line" -o "`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/' | sed 's/-avg/-all/g' `" --term "pdfcairo font \"Gill Sans,16\" lw 2 rounded"  -t "${f%_avg.xvg}" -- ${plcomms}
	else
	    gplot -c "set style data line" -o "`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/' | sed 's/-avg/-all/g' `" --term "pdfcairo font \"Gill Sans,16\" lw 2 rounded"  -t "${f%_avg.xvg}" -- ${plcomms}
	fi
	plcomms=""
	j=1
    fi

done

cd -

mkdir -p report
mv ${histdir}/*pdf report/
cd report/
cp $HOME/SIMS/KL/plots/distributions-all.tex .
pdflatex -shell-escape -interaction=nonstopmode distributions-all.tex
rm *.aux *.log
mupdf distributions-all.pdf &
cd ../

