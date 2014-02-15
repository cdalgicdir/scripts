#! /usr/bin/python

###################################################################
# calculates angle between 2 vectors: v1 and v2
# infile comprises of 6 columns with 1st 3 corresponding to v1
# last 3 columns correspond to v2
# prints out angles in degrees
###################################################################

import math,sys

infilename = sys.argv[1]
outfilename = sys.argv[2]

infile = open(infilename,'r')
outfile = open(outfilename,'w')

while 1:
    txt = infile.readline()
    if not txt:
	break
    elif txt[0] in ['@','#']:
	pass
    else:
	tmp = txt.split()
	#vec1 = [float(tmp[0]), float(tmp[1]), float(tmp[2])]
	#vec2 = [float(tmp[3]), float(tmp[4]), float(tmp[5])]
	# added time info column for both vectors
	time1 = float(tmp[0])
	time2 = float(tmp[4])
	if time1 == time2:
	    vec1 = [float(tmp[1]), float(tmp[2]), float(tmp[3])]
	    vec2 = [float(tmp[5]), float(tmp[6]), float(tmp[7])]
	    angle = math.acos((vec1[0]*vec2[0]+vec1[1]*vec2[1]+vec1[2]*vec2[2])/(math.sqrt(vec1[0]**2+vec1[1]**2+vec1[2]**2)*(math.sqrt(vec2[0]**2+vec2[1]**2+vec2[2]**2))))
	    print >> outfile, time1, angle/math.pi*180
	else:
	    print "Time steps do not match: %f vs %f" %(time1, time2)

print "%s generated!" %outfilename
