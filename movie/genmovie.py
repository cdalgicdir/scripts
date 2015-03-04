#! /usr/bin/python

import os
from numpy import loadtxt

no_of_figs_per_line = 10
init_ind = 0
end_ind = 39
step = 1
frame_per_index = 2000
#ind_list = range(0,7) + range(6,40,2)
directory = "../SNAPSHOTS"
trimsize = "70mm 100mm 60mm 70mm" #left bottom right top

width_per_frame = 1./10 - 0.01

timestep_traj = 500

init_frame = 2
end_frame = 4
#end_frame = frame_per_index + init_frame
step_frame = 1

outfilename = "output.tex"

replica_index = loadtxt("../replica_index.xvg")
temperatures = loadtxt("../temperatures.dat")

for frame in range(init_frame,end_frame,step_frame):
    outfile = open(outfilename,'w')

    print >> outfile, '\\documentclass{article}\n\
\\newlength{\\ph}\n\
\\newlength{\\pw}\n\
\\setlength{\\ph}{11cm}\n\
\\setlength{\\pw}{20cm}\n\
\\newcommand{\\hpw}{.9800\\linewidth}\n\
\n\
\\usepackage{epsfig}\n\
\\usepackage{epstopdf}\n\
\\usepackage{graphics}\n\
\\usepackage{pdftricks}\n\
\n\
\\pagestyle{empty}\n\
\\usepackage[paperwidth=\\pw,paperheight=\\ph,body={\\pw,\\ph}]{geometry}\n\
\n\
\\begin{document}\n\
\\begin{figure}[htpb!]\
\\footnotesize\
    '

    j = frame
    prev_i = init_ind
    counter = 0
    #for i in ind_list:
    for i in range(init_ind,end_ind+1,step):
        j += (i-prev_i)*frame_per_index
        #T = temperatures[replica_index[frame*timestep_traj,i+1]]
        if counter % no_of_figs_per_line == 0:
            print >> outfile, ''
        print >> outfile, '\\begin{minipage}[t]{%.2f\pw} \n\
        \\centering \n\
        \\includegraphics[trim = %s, clip, width=\hpw]{%s/frame%04d} \\\\ \n\
        %d \n\
        \\end{minipage}' %(width_per_frame,trimsize,directory,j,i+1)
        prev_i = i
        counter += 1
    time = frame*timestep_traj/1000
    print >> outfile, '\\end{figure} \n\\Large\n\\vspace{-0.4cm} \\begin{center} %d ns \\end{center}\n\\end{document}' %time
    outfile.close()

    ###################################################################
    # system commands
    ###################################################################
    os.system('pdflatex %s' %outfilename)
    pdffile = ''.join(outfilename.split('.')[:-1]) + '.pdf'
    pngfile = ''.join(outfilename.split('.')[:-1]) + '.png'
    movpdffile = 'movframe%05d.pdf' %frame
    movpngfile = 'movframe%05d.png' %frame
    os.system('mv %s %s' %(pdffile,movpdffile) )
    os.system('convert -density 300 %s %s' %(movpdffile,movpngfile))

os.system('ffmpeg -i movframe%05d.png -c:v libx264 -pix_fmt yuv420p -r 30 -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" mov.mp4')

