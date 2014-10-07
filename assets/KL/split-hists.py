#! /usr/bin/python
 
import sys
finame = sys.argv[1]
fi = open(finame,'r')

hist = []
histlist = []
i = 0

while True:
    line = fi.readline()
    if not line:
	fo.close()
	break
    elif line[0] in ['@','#']: continue
    elif line[0] == '&':
	hist = []
	i = i + 1
	foname = finame.rsplit(".",1)[0] + '-%d.' %i + finame.rsplit(".",1)[1]
	try: fo.close()
	except NameError: pass
	fo = open(foname,'w')
    else:
	if i > 0:
	    txt = line.split()
	    x = float(txt[0])
	    y = float(txt[1])
	    print >> fo, x, y

