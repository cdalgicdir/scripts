#! /bin/bash

#terminal="wxt enhanced persist"
terminal="wxt persist"
energyfile="energy.xvg"
potfile="*.pot.*"
tabfile="*table_*"
q="'"

max=30
#terminal="x11 persist position 800,10"


if [[ $1 == $potfile ]]; then
    if [ $# == 1 ]; then
	gplot [:][:$max] $1 u 1:2 
    elif [ $# == 2 ]; then
	gplot [:][:$max] $1 u 1:$2
    elif [ $# == 3 ]; then
	gplot [:][:$max] $1 u 1:2 $2 $3
    fi

elif [[ $1 == $tabfile && $1 != *table_d*.xvg && $1 != *table_a*.xvg && $1 != *table_b*.xvg ]]; then
    if [ $# == 1 ]; then
	gplot [:][:$max] $1 u 1:6
    elif [ $# == 2 ]; then
	gplot [:][:$max] $1 u 1:$2
    elif [ $# == 3 ]; then
	gplot [:][:$max] $1 u 1:6 $2 $3
    fi

elif [[ $1 == '-en' ]]; then
    gplot --term "$terminal" -c "set key right center" -y "Energy (kJ/mol)" -x "Time(ps)" -- "'energies.xvg' u 1:2 t 'Potential','' u 1:3 t 'Kinetic','' u 1:4 t 'Total'"

else
    if [[ $1 == *$energyfile ]]; then
	if [[ $# == 1 ]]; then
	    Nline=1
	else
	    Nline=`expr $2 - 1`
	fi
	mean=`awk '{if ($0 !~ /^[#@]/) {x+=$2; y+=1}}END{print x/y}' energy.xvg `
	t=`grep -i -w s[0-9] $1 | awk '{if(NR=='$Nline') print $4,$5}'`
	len=${#t}
	len=`expr $len - 3`
	title=`echo ${t:1:$len}`
	[[ $title == "Total Energ" ]] && title="Total Energy"
	#gplot -t "$title" -x "$xlabel" -y "$ylabel" -c "fit a 'energy.xvg' u 1:2 via a" -c "std=sqrt(FIT_WSSR/(FIT_NDF+1))" -c "set label 1 gprintf('Mean = %g',a) at 1000,a+2*std" -- "$q$1$q u 1:2,$mean w l lt 0 t 'mean',a-std w l lt 0 not,a+std w l lt 0 not"
    else
	    title=`grep "\stitle" $1|perl -lane 'print "@F[2..$#F]"'|tr -d "\""|head -1`
	    xlabel=`grep -m 1 xaxis $1|perl -lane 'print "@F[3..$#F]"'|tr -d "\""|head -1`
	    ylabel=`grep -m 1 yaxis $1|perl -lane 'print "@F[3..$#F]"'|tr -d "\""|head -1`
	    [[ ${title:0:2} == '\x' ]] && [[ ${title:3:4} == '\f{}' ]] && title='{/Symbol '"${title:2:1}"'}'" ${title:8}"

    fi
    if [ $# == 1 ]; then
	gplot --term "$terminal" -t "$title" -x "$xlabel" -y "$ylabel" $1 u 1:2
    elif [ $# == 2 ]; then
	gplot --term "$terminal" -t "$title" -x "$xlabel" -y "$ylabel" $1 u 1:$2
    elif [ $# == 3 ]; then
	gplot --term "$terminal" -t "$title" -x "$xlabel" -y "$ylabel" $1 u 1:2 $2 $3
    else
	gplot --term "$terminal" -t "$title" -x "$xlabel" -y "$ylabel" $1 u 1:$2 $3 $4
    fi
fi
