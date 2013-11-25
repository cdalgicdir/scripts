#! /bin/bash
#
# Plotting script for Votca
# Needs: gplot script of Christoph Junghans & gnuplot
# C.Dalgicdir
#

gplot='gplot'
pp='pp'

plot () {

    $gplot $printout $output -c "$terminal" -c "$size" -c "$arrow" -c "bulk=1" -c "set xzeroaxis lw 1 lt 0" -c "set mytics" -c "set mxtics" -c "set ytics $ytics" -t "$title" -j [:$range] -- "$plotfiles$save" 2>/dev/null

}

if [[ $1 != 'all' ]]; then
    A=$1
    B=$2
    shift 2
else
    flist=`ls step_000/*.dist.tgt`
    iter=0
    for f in $flist;do xx+=' '`echo ${f%.dist.tgt}`;iter=`expr $iter + 1`;done
    for f in $xx;do xy+=' '`echo ${f#step_*/}`;done
    xy=(${xy//-/ })
    index1=0
    index2=1
    i=1
    while [[ $i -le $iter ]];do
	A=`echo ${xy[$index1]}`
	B=`echo ${xy[$index2]}`
	args=`echo $@`
	args=`echo ${args#all}`
	$pp $A $B $args
	i=`expr $i + 1`
	index1=`expr $index1 + 2`
	index2=`expr $index2 + 2`
    done
    exit 0
fi

wdir=`pwd`
n="$*"
q='"'
step="step_"
slash="/"
plotfile=""
sp=" "
maxgraphs=15
var=(${n// / })
dirname=(${wdir//// })
l=`expr ${#dirname[*]} - 1`
title=${dirname[$l]}
comma=","
save=""
printout=""
xml='ibi-mpi.xml'
arrow=''
lw=3
ps=3

Nplotopt=`expr ${#var[*]} - 2`
indFname=`expr ${#var[*]} - 1`

if [[ ${var[$Nplotopt]} == '-s' ]]; then
    Nplotopt=`expr $Nplotopt - 1`
    limit=3
    Fname=${var[$indFname]}
    save=" \n save $q$Fname$q"
elif [[ ${var[$Nplotopt]} == '-e' ]]; then
    Nplotopt=`expr $Nplotopt - 1`
    limit=3
    Fname=${var[$indFname]}
    output="-o $Fname"
    size='set size 0.7,0.7'
    lw=3
    terminal='set terminal postscript eps color enhanced solid'
    #terminal='set terminal png enhanced size 1280,960 crop'
    #terminal='set terminal epslatex'
elif [[ ${var[$Nplotopt]} == '-o' ]]; then
    Nplotopt=`expr $Nplotopt - 1`
    limit=3
    Fname=${var[$indFname]}
    printout="-o $Fname"
else
    Nplotopt=`expr ${#var[*]} - 1`
    limit=1
fi

if [[ ${var[$Nplotopt]} == 'rdf' ]]; then
    if [[ `ls $xml 2>/dev/null` ]]; then
	max=`grep '<max>' $xml`
	max=${max//[^. 0-9]/}
	max=(${max// / })
	type1=`grep '<type1>' $xml`
	type1=${type1//<type1>/}
	type1=${type1//<\/type1>/}
	type1=(${type1// / })
	type2=`grep '<type2>' $xml`
	type2=${type2//<type2>/}
	type2=${type2//<\/type2>/}
	type2=(${type2// / })
	i=0
	while [[ $i -le ${#max[*]} ]]; do
	    if [ $A == ${type1[$i]} -a $B == ${type2[$i]} ]; then
	    #if [ \( $A == ${type1[$i]} \) -a \( $B == ${type2[$i]} \) ]; then
		vline=${max[$i]}
		break
	    fi
	    i=`expr $i + 1`
	done
    fi

    #if [ \( ${#max[*]} != ${#type1[*]} \) -o \( ${#max[*]} != ${#type2[*]} \) ]; then
    if [ ${#max[*]} != ${#type1[*]} -o ${#max[*]} != ${#type2[*]} ]; then
	echo "ERROR! Length og max and types are not equal"
	exit 1
    fi
fi

if [[ ${var[$Nplotopt]} == "pot" ]]; then
    #if [[ $A == "A" || $A == "B" ||  $A == "X" ||  $A == "Y" ]]; then
    if [[ -d REALPOTS ]]; then
	plotfile="$q./REALPOTS/table\_$A\_$B.xvg$q u 1:6 w l linestyle 1 lw $lw t 'REAL',"
	plotfile=$plotfile"$q./REALPOTS/table\_$A\_$B.xvg$q u 1:6 every 50 with points linestyle 1 pt 3 ps $ps not,"
    elif [[ -d initpots ]]; then
	plotfile="$q./initpots/table\_$A\_$B.xvg$q u 1:6 w l linestyle 1 lw $lw t 'initial',"
	plotfile=$plotfile"$q./initpots/table\_$A\_$B.xvg$q u 1:6 every 50 with points linestyle 1 pt 3 ps $ps not,"
    fi
    range=20
    u=" u 1:2 w l lw $lw t "
    file="$A-$B.pot.new"
    title="$A-$B.pot.new - [$title]"
    ytics=''
elif [[ ${var[$Nplotopt]} == "tab" ]]; then
    if [[ $A == "A" || $A == "B" ]]; then
	plotfile="$q./REALPOTS/table\_$A\_$B.xvg$q u 1:6 w l lw $lw t 'REAL',"
	range=20
    else
	range=20
    fi
    u="u 1:6 w l lw $lw t "
    file="table_$A\_$B.xvg"
    title="$A-$B Table Potentials - (table.xvg u 1:6) - [$title]"
    ytics=""
elif [ ${var[$Nplotopt]} == "for" ]; then
    u="u 1:7 w l lw $lw t "
    file="table_$A\_$B.xvg"
    range="400"
    title="$A-$B Forces (table.xvg u 1:7) - [$title]"
    ytics=""
elif [ ${var[$Nplotopt]} == "cur" ]; then
    if [[ $A == "A" || $A == "B" ]]; then
	plotfile="$q./REALPOTS/table\_$A\_$B.xvg$q u 1:6 w l lw $lw t 'REAL',"
	range=20
    else
	range=20
    fi
    u="u 1:2 w l lw $lw t "
    file="$A-$B.pot.cur"
    title="$A-$B.pot.cur - [$title]"
    #ytics=0.5
elif [ ${var[$Nplotopt]} == "rdf" ]; then
    maxR=`awk '{if ($0 !~ /^[#@]/) {if($2>m) {m=$2}}} END{print m}' step_000/$A-$B.dist.tgt`
    arrow="set arrow from $vline,0 to $vline,$maxR lw 1 lt 0 nohead"
    if [[ -d RDFs ]]; then
	plotfile="bulk lt 0 lw 1 not,$q./RDFs/rdf_$A-$B.xvg$q u 1:2 w l linestyle 1 lw $lw t 'TARGET',"
	plotfile=$plotfile"$q./RDFs/rdf_$A-$B.xvg$q u 1:2 every 10 with points linestyle 1 pt 3 not,"
    else
	plotfile="bulk lt 0 lw 1 not,$q./rdf_$A-$B.xvg$q u 1:2 w l linestyle 1 lw $lw t 'TARGET',"
	plotfile=$plotfile"$q./rdf_$A-$B.xvg$q u 1:2 every 10 with points linestyle 1 pt 3 not,"
    fi
    u="u 1:2 w l lw $lw t "
    file="$A-$B.dist.new"
    range=""
    title="$A-$B RDFs (dist.new) - [$title]"
    ytics=""
elif [ ${var[$Nplotopt]} == "dpt" ]; then
    u="u 1:2 w l lw $lw t "
    file="$A-$B.dpot.new"
    range=""
    title="$A-$B Potential Updates (dpot.new) - [$title]"
    ytics=""
elif [ ${var[$Nplotopt]} == "all" ]; then
    args=`echo $@`
    args=`echo ${args%all}`
    for item in 'rdf' 'pot' 'dpt' 'for'; do
	$pp $A $B $args $item
    done
else
    echo -e "ERROR! Specify the type at the end:pot|tab|for|cur|rdf"
    echo "Usage:${0##*/} A B 12 23 50 100 pot"
    exit 1
fi

while [ $# -gt $limit ]; do
    
    if [[ $1 != [0-9]* && $1 != *\?* && $1 != step_* ]]; then
	echo "ERROR! Inputs must be integer!"
	exit 1
    fi


    check4digits=`ls -d step_???? 2> /dev/null`
    dirlist=`ls -d step_*`

    if [[ ! -n $check4digits ]]; then
	string=${dirlist: -4}
	pos_=`expr index "$string" _`
    else
	string=${check4digits: -4}
	pos_=`expr index "$string" _`
    fi

    if [[ $1 == *-* ]]; then
	var=(${1//-/ })
	if [ $(expr ${var[1]} - ${var[0]}) -ge $maxgraphs ];then
	    echo "Too many graphs, max is" $maxgraphs"! Try reducing the number of graphs! Exiting..."
	    exit 1
	else
	    n=${var[0]}
	    while [ $n -le ${var[1]} ]; do
		num=`printf "%03d" "$n"`
		#if [ $n != 0 ]; then
		plotfile=$plotfile$q$step$num$slash$file$q$u$q$n$q$comma
		#fi
		n=`expr $n + 1`
	    done
	fi
    elif [[ $1 == *:*:* ]]; then
	var=(${1//:/ })
	if [ `echo "(${var[2]} - ${var[0]}) / ${var[1]}" | bc` -ge $maxgraphs ];then
	    echo "Too many graphs, max is" $maxgraphs"! Try reducing the number of graphs! Exiting..."
	    exit 1
	else
	    n=${var[0]}
	    while [ $n -le ${var[2]} ]; do
		num=`printf "%03d" "$n"`
		#if [  $n != 0 ]; then
		plotfile=$plotfile$q$step$num$slash$file$q$u$q$n$q$comma
		#fi
		n=`expr $n + ${var[1]}`
	    done
	fi
    elif [[ $1 == *\?* ]]; then
	num=$1
	# pad with zeros
	while [ ${#num} -lt 3 ]; do
	    num=0$num
	done
	dirlist=`ls -d step_$num`
	for dir in $dirlist; do
	    if [[  $dir != step_000 && $file != *pot.new  ||  $file == *pot.new  ]]; then
		plotfile=$plotfile$sp$q$dir$slash$file$q$u$q$dir$q$comma
	    fi
	done
     elif [[ $1 == *\* ]]; then
	num=$1
	# pad with zeros
	while [ ${#num} -lt 3 ]; do
	    num=0$num
	done
	dirlist=`ls -d step_$num`
	for dir in $dirlist; do
	    if [[  $dir != step_000 && $file != *pot.new  ||  $file == *pot.new  ]]; then
		plotfile=$plotfile$sp$q$dir$slash$file$q$u$q$dir$q$comma
	    fi
	done
     elif [[ $1 == step_* ]]; then
	# pad with zeros
	dirlist=`ls -d $1`
	for dir in $dirlist; do
	    if [[  $dir != step_000 && $file != *pot.new  ||  $file == *pot.new  ]]; then
		plotfile=$plotfile$sp$q$dir$slash$file$q$u$q$dir$q$comma
	    fi
	done
    else
	num=`printf "%03d" "$1"`
	plotfile=$plotfile$sp$q$step$num$slash$file$q$u$q$1$q$comma
    fi
    shift
done

len=${#plotfile}
if [[ $len -gt 0 ]]; then
    len2=`expr $len - 1`
    plotfiles=${plotfile:0:$len2}
    if [[ $terminal ]]; then
	title=''
    fi
    plot $@
    if [[ -n $save ]]; then
	chmod +x $Fname
    fi
else
    echo "No files found! Check the numbers!"
fi
