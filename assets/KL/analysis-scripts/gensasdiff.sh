#! /bin/bash

trj="../traj.xtc"
tpr="../topol.tpr"
ndx="../index.ndx"
###################################################################
# g_sas
###################################################################
# number of proteins in aggregate
n=4

# do sasa calculation for individual chains
for i in `seq 1 $n`; do
    echo Protein_chain${i} Protein_chain${i} | g_sas -f $trj -s $tpr -n $ndx -o area_chain${i} -q connelly_chain${i}
    awk '{if ($1 !~ /^[@|#]/) print $2,$3,$4}' area_chain$i.xvg > area_chain$i.dat
done

# aggregate
echo Protein Protein | g_sas -f $trj -s $tpr -n $ndx -o area_aggregate -q connelly_aggregate

# calculate sum
paste area_chain?.dat > area_chain-all.dat
awk -v x=$n '{for (i=1;i<=x;i++) {sumx+=$(3*i-2);sumy+=$(3*i-1);sumz+=$(3*i)} {print sumx,sumy,sumz;sumx=0;sumy=0;sumz=0}}' area_chain-all.dat > area_chain-sum.dat

awk '{if ($1 !~ /^[@|#]/) print $2,$3,$4}' area_aggregate.xvg > area_aggregate.dat
awk '{if ($1 !~ /^[@|#]/) print $1}' area_aggregate.xvg > time.dat

paste time.dat area_aggregate.dat area_chain-sum.dat > area_ALL.dat
awk '{print $1, $2-$5,$3-$6,$4-$7}' area_ALL.dat > area_diff.dat

cat > tmp.gp << EOF
set key outside right top vertical Right noreverse enhanced autotitles nobox
set xrange [ * : * ] noreverse nowriteback
set yrange [ * : * ] noreverse nowriteback
set ylabel "aggregate-(sum of chains)" 
set xlabel "time (ns)" 
set macros
ev="1000"
N = "1000"
p 'area_diff.dat' ev @ev u (\$1/1000):2 t 'hydrophobic','' ev @ev u (\$1/1000):3 t 'hydrophilic','' ev @ev  u (\$1/1000):4 t 'total'
EOF

gnuplot "tmp.gp" -e "set terminal pdfcairo font \"Gill Sans, 24\" linewidth 3 rounded size 10,4;set output \"sasdiff.pdf\";rep;set output"
rm tmp.gp
