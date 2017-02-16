#! /bin/bash

conf='conf.gro'
traj='traj.xtc'
tpr='topol.tpr'
dsspdt=1
nf=5

nstxtcout=`grep nstxtcout mdout.mdp | awk '{print $3}'`
dt=`grep dt mdout.mdp | awk '{print $3}'`

dir=`pwd`
report='simreport.tex'
templatedir="$HOME/SIMS/simreport"
autosnap='autosnap.tcl'
reportdir=$pwd/report
figanalyze="$dir/report/figures/protein-analysis"

snap () {
    cp "$templatedir"/$autosnap .
    sed -i 's/^snapincr.*$/snapincr '$nf'/' $autosnap
    vmd -e $autosnap ${conf} ${traj}
    cp $dir/frame*png $dir/report/figures/snapshots/
}

dodssp () {
    echo MainChain | do_dssp -f -s -o && xpm2ps -f ss.xpm
    xpm2ps -f ss.xpm -o dssp.eps -title none
    epstopdf dssp.eps
    cp $dir/dssp.pdf $figanalyze
}

gentemplate () {
    mkdir -p report && cd report
    cp $templatedir/$report .
    mkdir -p figures/protein-analysis
    mkdir -p figures/snapshots
    cd $dir
}

dorama () {
    g_rama -f $traj -s $tpr -o rama.xvg
    cp -r "$templatedir"/rama ramaXXX
    cp rama.xvg ramaXXX/
    cd ramaXXX/
    gnuplot rama-pdf.gp
    cp rama.pdf ../
    cd ../
    rm -rf ramaXXX/
    cp $dir/rama.pdf $figanalyze
}

genpdfplot () {
gnuplot << EOF
    set terminal pdfcairo enhanced font "Gill Sans,16" linewidth 3 rounded
    set output "$1.pdf"
    set xlabel $2
    set ylabel $3
    plot "$1.xvg" using 1:2 with line not
    set output
EOF
}

calcrmsd () {
    echo Protein | g_rmsdist -f $traj -s $tpr -n -o rmsd.xvg
    genpdfplot 'rmsd' "'time (ps)'" "'RMSD (nm)'"
    cp $dir/rmsd.pdf $figanalyze
}

calcrmsf () {
    echo Protein | g_rmsf -f $traj -s $tpr -n -o rmsf.xvg
    genpdfplot 'rmsf' "'C-alpha atoms'" "'RMSF (nm)'"
    cp $dir/rmsf.pdf $figanalyze
}

mindist () {
    echo -e "r ACE\nrNME\nq\n" | make_ndf -c $conf -o caps.ndx
    g_mindist -f $traj -s $tpr -n caps.ndx -od mindist.xvg
    genpdfplot 'mindist' "'Time (ps)'" "'Distance (nm)'" 
}

mdmat () {
    echo Protein | g_mdmat -f $traj -s $tpr -mean dm.xpm
    xpm2ps -f dm.xpm -o mdmat.eps -title none
    epstopdf mdmat.eps
    cp $dir/mdmat.pdf $figanalyze
}

end2end () {
    echo Protein | g_polystat -f $traj -s $tpr -n index.ndx -o end2end.xvg
    genpdfplot 'end2end' "'Time (ps)'" "'End to end distance (nm)'"
    cp $dir/end2end.pdf $figanalyze
}

hbond () {
    #echo MainChain MainChain | g_hbond -f $traj -s $tpr -n -num hb-mc-mc.xvg
    echo MainChain Sidechain | g_hbond -f $traj -s $tpr -n -num hb-mc-sc.xvg
    echo Protein Water | g_hbond -f $traj -s $tpr -n -num hb-prot-sol.xvg
    #genpdfplot 'hb-mc-mc' "'Time (ps)'" "'No. of Hydrogen Bonds'" 
    genpdfplot 'hb-mc-sc' "'Time (ps)'" "'No. of Hydrogen Bonds'" 
    genpdfplot 'hb-prot-sol' "'Time (ps)'" "'No. of Hydrogen Bonds'" 
    #cp $dir/hb-mc-mc.pdf $figanalyze
    cp $dir/hb-mc-sc.pdf $figanalyze
    cp $dir/hb-prot-sol.pdf $figanalyze
}


gentemplate $@
dodssp $@
snap $@
dorama $@
calcrmsd $@
calcrmsf $@
#mindist
mdmat $@
end2end $@
hbond $@

cd $dir/report/figures/snapshots
for frame in frame*png; do
    convert -trim $frame ${frame%.png}c.png
done
framelist=`ls -r frame*c.png`
cd $dir/report

# include snapshot images
#for frame in ${framelist[@]}; do
#    sed -i '/FRAME/a\ \ \\\includegraphics\[width=0.4\\textwidth\]\{figures\/snapshots/'${frame%.png}'\}' $report
#done
#sed -i '/FRAME/d' $report

for frame in ${framelist[@]}; do
    time=`echo ${frame%.png} | tr -d "framec"` && time=`echo "$time*$nstxtcout*$dt" | bc -l`
    [[ $time == 0 ]] && time='Initial configuration' || time="$time ps"
    sed -i '/FRAME/a\ \ \\\begin\{subfigure\}\[b\]\{0.4\\textwidth\}\n\ \ \ \\\includegraphics\[width=\\textwidth\]\{figures\/snapshots/'${frame%.png}'\}\n\ \ \ \\caption\{'"$time"'\}\n\ \ \\\end\{subfigure\}' $report
done
sed -i '/FRAME/d' $report

title=`echo $PWD | sed 's/\/home\/cdalgicdir\/SIMS\///'`
title=`echo $title | sed 's/\/report//'`
title=`echo $title | sed 's/\\//\\\\\//g'`
#title=`echo $PWD | sed 's/\\//\\\\\//g'`
sed -i 's/\\title.*$/\\title{\\bf '$title'\}/' $report

pdflatex $report
rm simreport.log simreport.aux simreport.out
mupdf ${report%.tex}.pdf &
