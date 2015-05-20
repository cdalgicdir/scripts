#! /usr/bin/python
import numpy as np
A=np.loadtxt("rama.formatted.xvg")
np.savetxt("rama.formatted-rad.dat",A/180.0*np.pi)
