#! /usr/bin/python

###################################################################
# CMSE 501 HW #8 Regular Expression and String Manipulation
###################################################################

import re
import math

# calculates distance between two vectors a, b
def calcdist(a,b):
    return math.sqrt((a[0]-b[0])**2+(a[1]-b[1])**2+(a[2]-b[2])**2)

mult = 75
file = open('1UBQ.pdb','r')
content = file.read()

# part 1) prints all lines that start with "ATOM"
atomregex = re.compile("\nATOM.*")
atomlist = atomregex.findall(content)
print "#" * mult
print "Lines starting with 'ATOM'"
print "#" * mult
for line in atomlist:
    print line[1:-1]

# part 2) prints all lines that start with "ATOM" and have the residue name "LEU"
leuregex = re.compile("\nATOM\s+\d+\s+[a-zA-Z]+\s+LEU.*")
leulist = leuregex.findall(content)
print "#" * mult
print "Lines with residue name 'LEU'"
print "#" * mult
for line in leulist:
    print line[1:-1]

# part 3) prints all lines that start with "ATOM" and have the atom name "CA"
caregex = re.compile("\nATOM\s+\d+\s+CA.*")
calist = caregex.findall(content)
print "#" * mult
print "Lines with 'CA' atoms"
print "#" * mult
for line in calist:
    print line[1:-1]

# part 4) prints distances between consecutive "CA" atoms
prevCA = None # list of coordinates of previous CA atom
cadist = [] # holds distances btw consecutive CA atoms
for line in calist:
    curCA = [float(i) for i in line.split()[6:9]] # x,y,z coords of CA atom
    if prevCA:
	cadist += [calcdist(curCA, prevCA)]
    prevCA = curCA

# part 5) Extracts aminoacis sequence
seqregex = re.compile("\nSEQRES.*")
seqlist = seqregex.findall(content)
seqres = ''
for line in seqlist:
    seqres += ' ' + ' '.join(line.split()[4:])

print 
print "Aminacid sequence is:"
print seqres

# part 6) Counts total number of References
refregex = re.compile("\nREMARK.*REFERENCE.*")
reflist = refregex.findall(content)
print
print "Total number of references is %d" %len(reflist)

# part 7) Converts references into Nature style
def convertAuthor(txt):
    ''' Converts a given string of authors from pdb to Nature citation style author format '''
    string = ''
    authors = txt.split(',')
    for author in authors:
	if not author == '': # to eliminate empty strings
	    names = author.split('.')
	    string += names[-1].capitalize() + ', ' # surname
	    for i in range(len(names)-1):
		string += names[i] + '.' # initials
	    string += ', '
    return string[:-2]


# gets all relevant reference lines
allrefregex = re.compile(r'(REMARK\s+\d+\s+(TITL|AUTH|REF |REFN).*)')
allreflist = allrefregex.findall(content)
reflist = [] # list of references
ref = {} # a reference
for line in allreflist:
    txt = line[0].split() # splits into relevant strings
    if txt[2] == 'AUTH':
	if re.match("\d+",txt[3]):# if there are multiple author lines
	    ref['author'] += convertAuthor(txt[4])
	else:
	    ref['author'] = convertAuthor(txt[3])
    elif txt[2] == 'TITL':
	if re.match("\d+",txt[3]): # if there are multiple title lines
	    ref['title'] += ' ' + ' '.join(txt[4:]).lower()
	else:
	    ref['title'] = ' '.join(txt[3:]).capitalize()
    elif txt[2] == 'REF':
	ref['journal'] = '. '.join(txt[3].title().split('.'))
	ref['vol'] = txt[5]
	ref['page'] = txt[6]
	ref['year'] = txt[7]
    elif txt[2] == 'REFN':
	ref['issn'] = txt[4]
	if not ref == {}:
	    reflist += [ref] # add to the list of references
	ref = {}
    else:
	continue

# Nature style citation
print 
print "References in Nature citations style:"
i = 0
for ref in reflist:
    i += 1
    print '%d. %s %s. %s %s, %s (%s)' %(i, ref['author'], ref['title'], ref['journal'],ref['vol'],ref['page'],ref['year'])
