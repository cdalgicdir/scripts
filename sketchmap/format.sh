#! /bin/bash

awk -v c=1 '! /^[@|#]/{if (c%14==0)print $1,$2;else{printf "%.4f %.4f ",$1,$2};c+=1 }' $1
