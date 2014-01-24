#! /bin/bash

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

flist=('bond_CA-CN_avg.xvg' 'bond_CA-KC_avg.xvg' 'bond_CA-L_avg.xvg' 'bond_CN-CA_avg.xvg' 'bond_KC-KN_avg.xvg' 'ang_CA-CN-CA_avg.xvg' 'ang_CA-KC-KN_avg.xvg' 'ang_CN-CA-CN_avg.xvg' 'ang_CN-CA-KC_avg.xvg' 'ang_CN-CA-L_avg.xvg' 'dih_CA-CN-CA-CN_avg.xvg' 'dih_CA-CN-CA-KC_avg.xvg' 'dih_CA-CN-CA-L_avg.xvg' 'dih_CN-CA-CN-CA_avg.xvg' 'dih_CN-CA-KC-KN_avg.xvg' 'imp_CA-CN-CN-L_avg.xvg' 'imp_CA-CN-KC-CN_avg.xvg')

#for f in bond*avg*xvg ang*avg*xvg dih*avg*xvg* imp*avg*xvg; do
for f in ${flist[@]}; do
    fx=${f%_avg.xvg}.xvg
    #bozf=`echo $f | sed 's/CA/CAB/g' | sed 's/ang/angle/' | sed 's/dih/dihedral/' | sed 's/imp/improper/' | sed 's/xvg/txt/' | sed 's/-/_/g'`
    #gplot -t "${f%.xvg}" ${f%_avg.xvg}.xvg u 1:2 w l t \'CG\'\,\'$kl7vacdir/$f\' u 1:2 w l t \'KL7-vac-excl\'\, \'$vacdir/$f\' u 1:2 w l t \'KL14-vac-excl\'\,\'$tetdir/$f\' u 1:2 w l t \'tetramer\'
    if [[ $f == bond* ]]; then
	gplot -o "`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/'`" --term "pdfcairo font \"Gill Sans,16\" lw 3 rounded"  -t "${f%.xvg}" ${fx} u 1:2 w l t \'CG\'\,\'$tetdir/$f\' u 1:2 w l t \'tetramer\'
    else
	gplot -o "`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/'`" --term "pdfcairo font \"Gill Sans,16\" lw 3 rounded" -t "${f%.xvg}" ${fx} u 1:2 w l t \'CG\'\,\'$tetdir/$f\' u \(\$1\/pi*180\):\(\$2\/180*pi\) w l t \'tetramer\'
    fi
    #gplot -o "`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/'`" --term "pdfcairo font \"Gill Sans,16\" lw 3 rounded" -t "${f%.xvg}" $kl7vacdir/$f u 1:2 w l t \'KL7-vac-excl\'\, \'$vacdir/$f\' u 1:2 w l t \'KL14-vac-excl\'\,\'$tetdir/$f\' u 1:2 w l t \'tetramer\'
    #gplot -o "`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/'`" --term "pdfcairo font \"Gill Sans,16\" lw 3 rounded" -t "${f%.xvg}" $kl7vacdir/$f u 1:2 w l t \'KL7-vac-excl\'\, \'$vacdir/$f\' u 1:2 w l t \'KL14-vac-excl\'\,\'$tetdir/$f\' u 1:2 w l t \'tetramer\'\,\'$bozsindir/$bozf\' u 1:2 w l t \'boz-sinmol\'\,\'$bozsinexdir/$bozf\' u 1:2 w l t \'boz-sinmol-excl\'
done

mkdir -p report
mv *pdf report/
cd report/
pdflatex -shell-escape -interaction=nonstopmode distributions.tex
rm *.aux *.log
cd ../

#for f in ${flist[@]}; do
#    gplot -o "`echo $f | sed 's/_/-/g' | sed 's/xvg/pdf/'`" --term "pdfcairo font \"Gill Sans,16\" lw 3 rounded" -t "${f%.xvg}" $kl2dir/$f u 1:2 w l t \'dimer\'\, \'$kl3dir/$f\' u 1:2 w l t \'trimer\'\,\'$kl4dir/$f\' u 1:2 w l t \'tetramer\'\,\'$kl5dir/$f\' u 1:2 w l t \'pentamer\'\,\'$kl6dir/$f\' u 1:2 w l t \'hexamer\'\,\'$kl8dir/$f\' u 1:2 w l t \'octamer\'
#done
