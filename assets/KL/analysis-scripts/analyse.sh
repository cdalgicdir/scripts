#! /bin/bash

#sleep 6h
echo Backbone_chain2 System | trjconv -f -s -n -dt 500 -pbc mol -center -ur compact && echo Backbone_chain2 System | trjconv -f trajout.xtc -fit rot+trans -n
echo MainChain | do_dssp -f -s -n -tu ps -dt 500 && xpm2ps -f ss.xpm 
bash commands.sh
