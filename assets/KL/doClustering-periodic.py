#! /usr/bin/python

import sys
import os
import shutil
import MDAnalysis as md
import numpy as np
import pylab as pl
from scipy import linalg as ln
from hcluster import *

import argparse

class Choices():
    def __init__(self, *choices):
        self.choices = choices

    def __contains__(self, choice):
        # True if choice ends with one of self.choices
        return any(choice.endswith(c) for c in self.choices)

    def __iter__(self):
        return iter(self.choices)

parser = argparse.ArgumentParser(description='Process some integers.')

parser.add_argument('--gro', '-g', dest='grofile', nargs='?', default="conf.gro", const="conf.gro", help='gromacs configuration file (.gro)', choices=Choices('.gro'))
parser.add_argument('--xtc', '-x', dest='xtcfile', nargs='?', default="traj.xtc", const="traj.xtc", help='gromacs trajectory file (.xtc)', choices=Choices('.xtc'))
parser.add_argument('--cutoff', '-c', dest='cutoff', nargs="?", default="600", const="600", help='cutoff value (default 600)', type=int)
parser.add_argument('--link_parameter', '-p', dest='link_param', nargs="?", default="4", const="4", help='number of levels to show in dendrogram', type=int)
parser.add_argument('--method', '-m', dest='method', nargs="?", default="complete", const="complete", help='method for clustering', choices=["single", "complete", "average", "weighted", "centroid", "median", "ward"])
parser.add_argument('--truncate_mode', '-tr', dest='truncate_mode', nargs="?", default="level", const="level", help='method for truncation of dendrogram', choices=["level", "mtica", "lastp", "none", "None"])
parser.add_argument('--noplot', '-np', dest='show_plot', default=True, action='store_false', help='do not show histogram and dendrogram plots')

args = parser.parse_args()

grofile = args.grofile
xtcfile = args.xtcfile
cutoff = args.cutoff
link_param = args.link_param
method = args.method
truncate_mode = args.truncate_mode
show_plot = args.show_plot

#cutoff = 300
#link_param = 4
#xtcfile = 'trajout0-dt10k-center.xtc'
#grofile = 'protein-alpha.gro'
#grofile = sys.argv[1]
#xtcfile = sys.argv[2]

def calcRama(u):
    ''' input: dcd universe '''
    protein = u.selectAtoms("protein")
    numresidues = protein.numberOfResidues()
    md.collection.clear()

    for res in range(1, numresidues-1):
        phi_sel = u.residues[res].phi_selection()
        psi_sel = u.residues[res].psi_selection()
        md.collection.addTimeseries(md.Timeseries.Dihedral(phi_sel))
        md.collection.addTimeseries(md.Timeseries.Dihedral(psi_sel))
        md.collection.compute(u.trajectory)

    Rp = np.zeros((u.trajectory.numframes,len(md.collection)))
    for i in range(len(md.collection)):
        Rp[:,i] = np.rad2deg(md.collection[i][0])
    np.putmask(Rp,Rp<-180,Rp+360)
    np.putmask(Rp,Rp>180,Rp-360)

    return Rp

def convert_xtc2dcd(uxtc):
    ''' input: xtc universe, output: dcd universe '''
    w = md.Writer("out.dcd", uxtc.trajectory.numatoms)

    for ts in uxtc.trajectory:
        w.write(ts)
    w.close_trajectory()

    return md.Universe(grofile,"out.dcd")

def doCluster(X, method):
    Z = linkage(X,method)
    pl.figure()
    pl.title(method)
    R=dendrogram(Z, color_threshold='auto',truncate_mode=truncate_mode, p=link_param, show_contracted=True, orientation='left')
    pl.savefig("dendrogram.pdf")
    f = doHist(Z)
    return f

def doHist(Z):
    f = fcluster(Z,cutoff,criterion='distance')
    hist, bin_edges = np.histogram(f,np.arange(0.5,f.max()+1))
    pl.figure()
    pl.bar(bin_edges[:-1],sorted(hist,reverse=True),width=1)
    #pl.bar(bin_edges[:-1],hist,width=1)
    pl.title(method + "-" + str(cutoff))
    pl.savefig("histogram.pdf")
    return f

def write_report(f, method, cutoff):
    cluster_id = 1
    report = "clusters-" + method + "-" + str(cutoff) + ".dat"
    fout = open(report,"w")
    clusters = {}
    for i in range(1,f.max()):
        clusters[i] = len(np.where(f==i)[0])
    clusters_keys_sorted = sorted(clusters,key=clusters.get,reverse=True)
    for i in clusters_keys_sorted:
        print >> fout, "cluster %d (%d frames):" %(cluster_id,clusters[i]),
        for j in np.where(f==i)[0]:
            print >> fout, j,
        print >> fout, ""
        cluster_id += 1
    fout.close()
    return report, clusters_keys_sorted, clusters

def accumulate_clusters(f):
    clusters = {}
    for i in range(1,f.max()):
        clusters[i] = len(np.where(f==i)[0])
    clusters_keys_sorted = sorted(clusters,key=clusters.get,reverse=True)
    return clusters, clusters_keys_sorted

u = md.Universe(grofile,xtcfile)
Rp = calcRama(convert_xtc2dcd(u))
x = Rp[:,None,...] - Rp[None,...]
x[x<-180]+=360
x[x>180]-=360
xs = np.sqrt((x**2).sum(axis=2))

#X = pdist(Rp)
Xs = (np.triu(xs)[np.triu_indices(Rp.shape[0])])
nf = Rp.shape[0]
nff = nf * (nf-1) / 2
X = Xs[ Xs != 0]

#for method in ["single"]:
#for method in ["complete"]:
f = doCluster(X, method)
report, clusters_keys_sorted, clusters = write_report(f, method, cutoff)

if show_plot:
    pl.show()

outdir_root = "clustering-" + method + "-" + str(cutoff)

A = u.selectAtoms('all')
#for i in range(1,f.max()+1):
i = 1

outdir = outdir_root

while os.path.exists(outdir):
    i += 1
    outdir = outdir_root + "-" + str(i)

os.mkdir(outdir)

print "Writing files in %s!" %outdir

shutil.move("histogram.pdf", outdir + "/histogram.pdf")
shutil.move("dendrogram.pdf", outdir + "/dendrogram.pdf")
shutil.move(report, outdir + "/" + report)

cluster_id = 1
for i in clusters_keys_sorted:
    cluster_grofile = outdir + "/" + "cluster-" + str(cluster_id) + ".gro"
    cluster_trajfile = outdir + "/" + "trajcluster-" + str(cluster_id) + ".xtc"
    W = md.Writer(cluster_trajfile,A.numberOfAtoms())
    frames = np.where(f==i)[0]
    for ts in u.trajectory:
	if ts.frame-1 in frames:
	    W.write(ts)
	    A.write(cluster_grofile)
    W.close_trajectory()
    cluster_id += 1

print "Found %d clusters!" %len(clusters)
