proc snapincr {{increment "1000"}} {
    set nf [molinfo top get numframes]
    for { set i 0} { $i < $nf } {incr i $increment} {
        animate goto $i
        #set j [expr $i]
	set j [format "%03d" $i]
        render Tachyon frame$j.dat tachyon -aasamples 12 %s -format PNG -res 1200 1500 -o frame$j.png -mediumshade
    }
}

proc highres {molid} {

  for {set i 0} {$i < [molinfo $molid get numreps]} {incr i} {
    set rep [molinfo $molid get "{rep $i} {selection $i} {color $i} {material $i}"]
      foreach {r s c m} $rep { break }
    if { [lindex $r 0] == "NewCartoon" } { mol modstyle $i $molid NewCartoon [lindex $r 1] 100 [lindex $r 3] [lindex $r 4]
    } elseif { [lindex $r 0] == "Licorice" } { mol modstyle $i $molid Licorice [lindex $r 1] 100 100
    } elseif { [lindex $r 0] == "CPK" } { mol modstyle $i $molid CPK [lindex $r 1] [lindex $r 2] 100 100
    } elseif { [lindex $r 0] == "VDW" } { mol modstyle $i $molid VDW [lindex $r 1] 100 }
    }
}

proc kllred_viz {molid {colhfobic "ResType"} } {
  # operate only on existing molecules
  if {[lsearch [molinfo list] $molid] >= 0} {
    # delete all representations
    set numrep [molinfo $molid get numreps]
    for {set i $numrep} {$i > -1} {incr i -1} {
      mol delrep $i $molid
    }
    # add new representations
    # hydrophobic
    mol representation NewCartoon 0.300000 10.000000 4.500000 0
    mol color ColorID 0
    mol selection {resname LYS}
    mol addrep $molid
    # hydrophilic
    mol representation NewCartoon 0.300000 10.000000 4.500000 0
    mol color ColorID 1
    mol selection {resname LEU}
    mol addrep $molid
    # lysine sidechains
    mol representation Licorice 0.300000 10.000000 10.000000
    mol color ColorID 0
    mol selection {resname LYS and (sidechain or name CA) and not (resname ACE or resname NME)}
    mol addrep $molid
    # leucine sidechains
    mol representation Licorice 0.300000 10.000000 10.000000
    mol color ColorID 1
    mol selection {resname LEU and (sidechain or name CA) and not (resname ACE or resname NME)}
    mol addrep $molid
    # ACE - N-termini
    mol representation CPK 1.000000 0.300000 10.000000 10.000000
    mol color ColorID 3
    mol selection {resname ACE}
    mol addrep $molid
  }
}

kllred_viz [molinfo top]
highres [molinfo top]
display depthcue off
color Display Background white;pbc box -off;axes location off
display resetview
snapincr 5
exit
