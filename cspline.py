#! /usr/bin/python

import pdb
import numpy
from scipy.linalg import solve

#def cspline(data, cond=[[None,0.,None],[None,0.,None]]):
def xcspline(data, cond=[[None,0.,None],[None,0.,None]]):
    ''' appends derivative array to data=[x,y] using cubic splines through y
        x,y can be lists or arrays
        returns [x,f,g], f=y (array), g=first derivative array
        cond prescribes first, second or third derivatives at end points
        default condition is natural splines
    '''

    x=numpy.array(data[:,0]); f=numpy.array(data[:,1])
    n=numpy.alen(x)-1
    if (numpy.alen(f)!=n+1):
        print "ERROR: unequal length of x and y in data"
        print "cspline aborted"
        return None

    xdif=numpy.diff(x)
    if xdif.min()<=0.:
        print "ERROR: nonincreasing x values"
        print "cspline aborted"
        return None

    s=1./xdif
    d=numpy.arange(n+1,dtype=float) # predefine d

    for i in range(1,n):
        d[i]=2.*(s[i-1]+s[i])
    b=numpy.arange(n+1,dtype=float) # predefine b

    for i in range(1,n):
        b[i]=3.*((f[i]-f[i-1])*s[i-1]**2 + (f[i+1]-f[i])*s[i]**2)
    if (cond==[[None,None,None],[None,None,None]]): # periodic
        if (f[0]!=f[-1]):
            print "ERROR: periodic spline with",
            print "unequal first and last values"
            print "cspline aborted"
            return None
        else:
            d[0]=2.*(s[0]+s[n-1])
            d=d[:-1]
            A=numpy.diag(d)
            for i in range(n-1): A[i,i+1]=A[i+1,i]=s[i]
            A[0,n-1]=A[n-1,0]=s[n-1]
            b[0]=3.*((f[1]-f[0])*s[0]**2 + (f[n]-f[n-1])*s[n-1]**2)
            b=b[:-1]
            g=solve(A,b)
            g=numpy.concatenate((g,[g[0]]))
            return [x,f,g]

    head=True # extra first row and column
    tail=True # extra last row and column
    if (cond[0][0]!=None):
        b[1]=b[1]-cond[0][0]*s[0]
        head=False
    elif (cond[0][1]!=None):
        d[0]=2.*s[0]
        b[0]=3.*(f[1]-f[0])*s[0]**2-0.5*cond[0][1]
    else:
        d[0]=s[0]
        b[0]=2.*(f[1]-f[0])*s[0]**2+cond[0][2]/(6.*s[0])

    if (cond[1][0]!=None):
        b[n-1]=b[n-1]-cond[1][0]*s[n-1]
        tail=False
    elif (cond[1][1]!=None):
        d[n]=2.*s[n-1]
        b[n]=3.*(f[n]-f[n-1])*s[n-1]**2-0.5*cond[1][1]
    else:
        d[n]=s[n-1]
        b[n]=2.*(f[n]-f[n-1])*s[n-1]**2+cond[1][2]/(6.*s[n-1])
    if (not head):
        s=s[1:]; d=d[1:]; b=b[1:]
    if (not tail):
        s=s[:-1]; d=d[:-1]; b=b[:-1]

    A=numpy.diag(d)
    for i in range(numpy.alen(d)-1): A[i,i+1]=A[i+1,i]=s[i]
    g=solve(A,b)
    if (not head): g=numpy.concatenate(([cond[0][0]],g))
    if (not tail): g=numpy.concatenate((g,[cond[1][0]]))

    pdb.set_trace()
    return [x,f,g]

