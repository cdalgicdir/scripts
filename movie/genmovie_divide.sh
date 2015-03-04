#! /bin/bash

divide=4
begin_frame=2
final_frame=2000
step=$(((final_frame-begin_frame)/divide))
file="gentex.py"

init_frame=$begin_frame
end_frame=$((begin_frame+step))

for i in `seq 1 $divide`; do
    newfile="${file%.py}-${i}of${divide}.py"
    cp $file $newfile
    sed -i 's/^init_frame =.*$/init_frame = '$init_frame'/' $newfile
    sed -i 's/^end_frame =.*$/end_frame = '$end_frame'/' $newfile
    sed -i 's/output.tex/output_'${i}'of'${divide}'.tex/' $newfile
    init_frame=$((init_frame+step))
    end_frame=$((end_frame+step))
done
