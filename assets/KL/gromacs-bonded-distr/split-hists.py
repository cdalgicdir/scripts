#! /usr/bin/python
 
import sys
finame = sys.argv[1]
#finame = 'hist_dih_CA-CN-CA-L.xvg'
foname = finame.rsplit(".",1)[0] + '_all.' + finame.rsplit(".",1)[1]

fi = open(finame,'r')
fo = open(foname,'w')

hist = []
histlist = []

while True:
    line = fi.readline()
    if not line:
	histlist.append(hist)
	break
    elif line[0] in ['@','#']: continue
    elif line[0] == '&':
	histlist.append(hist)
	hist = []
    else:
	txt = line.split()
	x = float(txt[0])
	y = float(txt[1])
	hist.append((x,y))


#print len(histlist)

for i in range(len(histlist[0])):
    print >> fo, ''
    for j in range(len(histlist)):
	print >> fo, histlist[j][i][0], histlist[j][i][1],

