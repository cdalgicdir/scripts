#! /usr/bin/python
# coding: utf-8

import numpy, sys

fin_name = sys.argv[1]
A = numpy.loadtxt(fin_name)
x = A[:][:,0]
y = A[:][:,1]
z = A[:][:,2]
vm = y[:-2]
vp = y[2:]
f = z[1:-1]
ns = vm.size
numf = -(vp-vm)*0.5*1
ssd = numpy.sum(numpy.fabs(2*(f-numf)/(f+numf)))
dev = 100*(ssd/ns)+0.5
print " Average deviation of forces for file %s is %.0f%%!" %(fin_name, dev)
