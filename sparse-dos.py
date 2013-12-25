#! /usr/bin/python

class Sparse:
    ''' Linked list representation of a sparse matrix '''

    def __init__(self, x=[]):
	self._firstrow = None
	self._dim = (len(x),len(x[0]))
	self.convert(x)

    def convert(self, mat):
	''' Converts a list of list to a Sparse class object '''

	prevRow = None
	newRow = None
	for i in range(self._dim[0]):
	    isnewrow = True # true when a new row is being parsed
	    prevCell = None
	    for j in range(self._dim[1]):
		if mat[i][j] != 0: # for non-zero elements
		    newCell = Cell(j, mat[i][j])
		    if isnewrow:
			newRow = Row(i)
			newRow._firstcell = newCell
			isnewrow = False # now the same row will be parsed
			# if Sparse class object is empty assign its first row
			if self.isempty():
			    self._firstrow = newRow
			# else link the rows
			else:
			    prevRow._nextrow = newRow
		    # if elements of the same row are being parsed
		    elif not isnewrow:
			prevCell._next = newCell #link the cells
		    prevCell = newCell
	    prevRow = newRow

    # returns True when the firstrow is None
    def isempty(self):
	return self._firstrow is None

    # returns all matrix, not just non-zero elements
    def __str__(self):
	string = ''
	currow = self._firstrow
	previ = -1 # previous row index parsed, initially -1 to parse zero rows
	i = previ # row index being parsed
	while not currow == None: # iterate until None row
	    i = currow._index # index of current row being parsed
	    curcell = currow._firstcell # current cell being parsed
	    # to print out zero rows at the beginning or in between
	    if i-previ > 1:
		for n in range(i-previ-1):
		    string += '\n' + '0 '*(self._dim[1])
	    else: # no zero rows
		string += '\n'
		prevj = -1 # previous column index parsed, initially -1 to parse zero columns
		while not curcell == None: # iterate until None element
		    j = curcell._index # column index being parsed
		    # to print out zero elements in the same row
		    if j-prevj > 1:
			string += '0 '*(j-prevj-1)
		    string += str(curcell._value) + ' '
		    curcell = curcell._next # go to the next cell
		    prevj = j
		# if the last elements of the row are zero
		if j != self._dim[1]-1:
		    string += '0 '*(self._dim[1]-j-1)
		currow = currow._nextrow
	    previ = i
	# if the last rows are zero
	if i != self._dim[0]-1:
	    for n in range(self._dim[0]-i-1):
		string += '\n' + '0 '*(self._dim[1])
	return string


class Row:
    ''' Rows of matrix '''

    def __init__(self, index):
	self._index = index
	self._firstcell = None
	self._nextrow = None

    # returns True when firstcell is None
    def isempty(self):
	return self._firstcell is None

class Cell:
    ''' Elements of a row '''
    
    def __init__(self, index, value):
	self._index = index
	self._value = value
	self._next = None



x = [[0,0,0,0],[0,0,0,0],[0,2,5,6],[0,4,3,5],[0,0,0,0],[3,0,0,0],[0,0,0,0]]

s = Sparse(x)
print s
