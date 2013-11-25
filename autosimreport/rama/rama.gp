#!/usr/local/bin/gnuplot -persist
#
#    
#    	G N U P L O T
#    	Version 4.6 patchlevel 4    last modified 2013-10-06 
#    	Build System: Linux x86_64
#    
#    	Copyright (C) 1986-1993, 1998, 2004, 2007-2013
#    	Thomas Williams, Colin Kelley and many others
#    
#    	gnuplot home:     http://www.gnuplot.info
#    	faq, bugs, etc:   type "help FAQ"
#    	immediate help:   type "help"  (plot window: hit 'h')
set terminal wxt 0 enhanced
# set output
unset clip points
set clip one
unset clip two
set bar 1.000000 front
set border 3 back linetype -1 linecolor rgb "#808080"  linewidth 1.000
set timefmt z "%d/%m/%y,%H:%M"
set zdata 
set timefmt y "%d/%m/%y,%H:%M"
set ydata 
set timefmt x "%d/%m/%y,%H:%M"
set xdata 
set timefmt cb "%d/%m/%y,%H:%M"
set timefmt y2 "%d/%m/%y,%H:%M"
set y2data 
set timefmt x2 "%d/%m/%y,%H:%M"
set x2data 
set boxwidth
set style fill  empty border
set style rectangle back fc lt -3 fillstyle   solid 1.00 border lt -1
set style circle radius graph 0.02, first 0, 0 
set style ellipse size graph 0.05, 0.03, first 0 angle 0 units xy
set dummy x,y
set format x "% g"
set format y "% g"
set format x2 "% g"
set format y2 "% g"
set format z "% g"
set format cb "% g"
set format r "% g"
set angles radians
unset grid
set raxis
set key title ""
set key inside right top vertical Right noreverse enhanced autotitles nobox
set key noinvert samplen 4 spacing 1 width 0 height 0 
set key maxcolumns 0 maxrows 0
set key noopaque
unset key
unset label
unset arrow
set style increment userstyles
unset style line
set style line 1  linetype 1 linecolor rgb "#a00000"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 2  linetype 2 linecolor rgb "#00a000"  linewidth 3.000 pointtype 6 pointsize default pointinterval 0
set style line 3  linetype 3 linecolor rgb "#5060d0"  linewidth 3.000 pointtype 2 pointsize default pointinterval 0
set style line 4  linetype 4 linecolor rgb "#f25900"  linewidth 3.000 pointtype 9 pointsize default pointinterval 0
set style line 5  linetype 5 linecolor rgb "black"  linewidth 3.000 pointtype 5 pointsize default pointinterval 0
set style line 6  linetype 6 linecolor rgb "red"  linewidth 3.000 pointtype 6 pointsize default pointinterval 0
set style line 7  linetype 7 linecolor rgb "cyan"  linewidth 3.000 pointtype 7 pointsize default pointinterval 0
set style line 8  linetype 8 linecolor rgb "orange"  linewidth 3.000 pointtype 8 pointsize default pointinterval 0
set style line 9  linetype 9 linecolor rgb "magenta"  linewidth 3.000 pointtype 9 pointsize default pointinterval 0
set style line 10  linetype 1 linecolor rgb "olive"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 11  linetype 1 linecolor rgb "dark-red"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 12  linetype 1 linecolor rgb "light-green"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 13  linetype 1 linecolor rgb "violet"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 14  linetype 1 linecolor rgb "navy"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 15  linetype 1 linecolor rgb "grey"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 80  linetype 80 linecolor rgb "#808080"  linewidth 1.000 pointtype 80 pointsize default pointinterval 0
set style line 81  linetype -1 linecolor rgb "#808080"  linewidth 1.000 pointtype -1 pointsize default pointinterval 0
unset style arrow
set style histogram clustered gap 2 title  offset character 0, 0, 0
unset logscale
set offsets 0, 0, 0, 0
set pointsize 1
set pointintervalbox 1
set encoding default
unset polar
unset parametric
unset decimalsign
set view 60, 30, 1, 1
set samples 100, 100
set isosamples 10, 10
set surface
unset contour
set clabel '%8.3g'
set macros
set mapping cartesian
set datafile separator whitespace
unset hidden3d
set cntrparam order 4
set cntrparam linear
set cntrparam levels auto 5
set cntrparam points 5
set size ratio 0 1,1
set origin 0,0
set style data points
set style function lines
set xzeroaxis linetype 0 linewidth 1.000
set yzeroaxis linetype 0 linewidth 1.000
set zzeroaxis linetype -2 linewidth 1.000
set x2zeroaxis linetype -2 linewidth 1.000
set y2zeroaxis linetype -2 linewidth 1.000
set ticslevel 0.5
set mxtics default
set mytics default
set mztics default
set mx2tics default
set my2tics default
set mcbtics default
set xtics border in scale 1,0.5 nomirror norotate  offset character 0, 0, 0 autojustify
set xtics autofreq  norangelimit
set ytics border in scale 1,0.5 nomirror norotate  offset character 0, 0, 0 autojustify
set ytics autofreq  norangelimit
set ztics border in scale 1,0.5 nomirror norotate  offset character 0, 0, 0 autojustify
set ztics autofreq  norangelimit
set nox2tics
set noy2tics
set cbtics border in scale 1,0.5 nomirror norotate  offset character 0, 0, 0 autojustify
set cbtics autofreq  norangelimit
set rtics axis in scale 1,0.5 nomirror norotate  offset character 0, 0, 0 autojustify
set rtics autofreq  norangelimit
set title "" 
set title  offset character 0, 0, 0 font "" norotate
set timestamp bottom 
set timestamp "" 
set timestamp  offset character 0, 0, 0 font "" norotate
set rrange [ * : * ] noreverse nowriteback
set trange [ * : * ] noreverse nowriteback
set urange [ * : * ] noreverse nowriteback
set vrange [ * : * ] noreverse nowriteback
set xlabel "{/Symbol f}" 
set xlabel  offset character 0, 0, 0 font "" textcolor lt -1 norotate
set x2label "" 
set x2label  offset character 0, 0, 0 font "" textcolor lt -1 norotate
set xrange [ -180.000 : 180.000 ] noreverse nowriteback
set x2range [ * : * ] noreverse nowriteback
set ylabel "{/Symbol y}" 
set ylabel  offset character 0, 0, 0 font "" textcolor lt -1 rotate by -270
set y2label "" 
set y2label  offset character 0, 0, 0 font "" textcolor lt -1 rotate by -270
set yrange [ -180.000 : 180.000 ] noreverse nowriteback
set y2range [ * : * ] noreverse nowriteback
set zlabel "" 
set zlabel  offset character 0, 0, 0 font "" textcolor lt -1 norotate
set zrange [ * : * ] noreverse nowriteback
set cblabel "" 
set cblabel  offset character 0, 0, 0 font "" textcolor lt -1 rotate by -270
set cbrange [ * : * ] noreverse nowriteback
set zero 1e-08
set lmargin  -1
set bmargin  -1
set rmargin  -1
set tmargin  -1
set locale "en_US.UTF-8"
set pm3d explicit at s
set pm3d scansautomatic
set pm3d interpolate 1,1 flush begin noftriangles nohidden3d corners2color mean
set palette positive nops_allcF maxcolors 0 gamma 1.5 color model RGB 
set palette rgbformulae 7, 5, 15
set colorbox default
set colorbox vertical origin screen 0.9, 0.2, 0 size screen 0.05, 0.6, 0 front bdefault
set style boxplot candles range  1.50 outliers pt 7 separation 1 labels auto unsorted
set loadpath 
set fontpath 
set psdir
set fit noerrorvariables
GNUTERM = "wxt"
XYZ = " title 'xyz' with lines lt rgb 'brown' lw 3"
PDF = "set terminal pdfcairo enhanced font \"Gill Sans,16\" linewidth 3 rounded"
OUT = "set output \"out.pdf\";rep;set output"
PDFOUT = "set terminal pdfcairo enhanced font \"Gill Sans,16\" linewidth 3 rounded;set output \"out.pdf\";rep;set output"
PNGOUT = "set terminal pngcairo size 800,600;set output \"out.png\";rep;set output"
DIH = "set xlabel '{/Symbol F}_{PBBP}';set ylabel 'P ({/Symbol F})';set xtics 60;set xrange [-180:180]"
PMF = "set xlabel 'separation distance (nm)';set ylabel 'V(r) (kJ/mol)'"
KL = "/home/cdalgicdir/SIMS/remote/ichi/sg5/KL/"
IBI = "/home/cdalgicdir/SIMS/remote/ichi/sg5/IBI/"
FF = "/home/cdalgicdir/SIMS/remote/ichi/sg5/FF/"
p 'rama-red-region1.dat' w l lt 1,'rama-red-region2.dat' w l lt 1,'rama-red-region3.dat' w l lt 1,'rama-blue-region1.dat' w l lt 3,'rama-blue-region2.dat' w l lt 3,'rama-blue-region3.dat' w l lt 3,'rama-blue-region4.dat' w l lt 3,'rama-blue-region5.dat' w l lt 3,'rama-blue-region6.dat' w l lt 3,'rama-blue-region7.dat' w l lt 3,'rama.xvg' u 1:2 lt -1 pt 1
#    EOF
