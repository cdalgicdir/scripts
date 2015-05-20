#! /usr/bin/python

import numpy as np

do_plot = True
do_gentraj = True

fin = "lowd-new"
pdb = "protein.pdb"
xtc = 'traj.xtc'
A = np.loadtxt(fin)[:,0:2]
x = A[:,0]
y = A[:,1]

groups = []

# circles
circ1 = [-7.5,1]
circ2 = [8.3,0]
r = 4

groups.append(np.where((x+circ1[0])**2+(y-circ1[1])**2 < r**2)[0])
groups.append(np.where((x+circ2[0])**2+(y-circ2[1])**2 < r**2)[0])

# rectangles
recX = [-2.16, 0.42, 3.0] ; recY = [0.35, 0.35, 0.35] ; recH = [1.5 , 1.5, 1.5] ; recW = [2.577, 2.577, 2.577]

indX = np.where(x[np.where(x>recX[0]-recW[0]/2)[0]]<recX[0]+recW[0]/2)[0]
groups.append(np.where(y[np.where(y[indX]>recY[0]-recH[0]/2)[0]]<recY[0]+recH[0]/2)[0])
indX = np.where(x[np.where(x>recX[1]-recW[1]/2)[0]]<recX[1]+recW[1]/2)[0]
groups.append(np.where(y[np.where(y[indX]>recY[1]-recH[1]/2)[0]]<recY[1]+recH[1]/2)[0])
indX = np.where(x[np.where(x>recX[2]-recW[2]/2)[0]]<recX[2]+recW[2]/2)[0]
groups.append(np.where(y[np.where(y[indX]>recY[2]-recH[2]/2)[0]]<recY[2]+recH[2]/2)[0])

logfile = open("lowd-new-grouping.log","w")
for i in range(len(groups)):
    print >> logfile, "group %d %d" %(i,groups[i].size)

###################################################################
# Generate trajectories for each group
###################################################################

import MDAnalysis

if do_gentraj:
    u = MDAnalysis.Universe(pdb, xtc)
    protein = u.selectAtoms("protein")
    with MDAnalysis.Writer("group" + str(i) + ".xtc", protein.numberOfAtoms()) as W:
        c = 0
        for ts in u.trajectory:
            if c in groups[i]:
                W.write(protein)
            c += 1

###################################################################
# Plot the groups in lowd-new
###################################################################

if do_plot:
    import matplotlib.pyplot as plt
    from matplotlib.patches import Rectangle
    import os

    # Set the font dictionaries (for plot title and axis titles)
    title_font = {'fontname':'Arial', 'size':'20', 'color':'black', 'weight':'normal',
                  'verticalalignment':'bottom'} # Bottom vertical alignment for more space
    axis_font = {'fontname':'Arial', 'size':'18'}

    #plt.cla();plt.clf();plt.close();fig.clf();fig.clear()
    ax = plt.gca()
    ax.cla()
    ax.set_ylim((-10,10))
    ax.set_xlim((-15,15))
    ax.plot(x,y,'.')

    circle1 = plt.Circle((circ1[0],circ1[1]),radius=r,color='r',fill=False,linewidth=5)
    circle2 = plt.Circle((circ2[0],circ2[1]),radius=r,color='r',fill=False,linewidth=5)

    rec1 = ax.add_patch(Rectangle((recX[0] - recW[0]/2, recY[0] - recH[0]/2), recW[0], recH[0], facecolor="grey"))
    rec2 = ax.add_patch(Rectangle((recX[1] - recW[1]/2, recY[1] - recH[1]/2), recW[1], recH[1], facecolor="grey"))
    rec3 = ax.add_patch(Rectangle((recX[2] - recW[2]/2, recY[2] - recH[2]/2), recW[2], recH[2], facecolor="grey"))

    fig = plt.gcf()
    fig.gca().add_artist(circle1)
    fig.gca().add_artist(circle2)
    fig.suptitle(os.getcwd().split('/')[-1], y=0.92, **title_font)
    for tick in ax.xaxis.get_major_ticks():
        tick.label.set_fontsize(20)
    for tick in ax.yaxis.get_major_ticks():
        tick.label.set_fontsize(20)
    fig.savefig('lowd-new-groups.png',dpi=600)

###################################################################


## get number of atoms
#natoms = read_xtc_natoms(xtc)
#
## allocate coordinate array of the right size and type
## (the type float32 is crucial to match the underlying C-code!!)
#x = np.zeros((natoms, DIM), dtype=np.float32)
## allocate unit cell box
#box = np.zeros((DIM, DIM), dtype=np.float32)
#
## open file
#XTC = xdrfile_open(xtc, 'r')
#
## loop through file until return status signifies end or a problem
## (it should become exdrENDOFFILE on the last iteration)
#status = exdrOK
#c = 0
#while status == exdrOK:
#   status,step,time,prec = read_xtc(XTC, box, x)
#   if c in group1:
#
#   # do something with x
#   centre = x.mean(axis=0)
#   #print 'Centre of geometry at %(time)g ps: %(centre)r' % vars()
#   c += 1
#
## finally close file
#xdrfile_close(XTC)
#
