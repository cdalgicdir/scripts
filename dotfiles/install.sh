#! /bin/bash

DIR=scripts/dotfiles
cd $HOME

ln -s $DIR/bash_aliases .bash_aliases
ln -s $DIR/bash_aliases_soft .bash_aliases_soft
ln -s $DIR/bashrc .bashrc
ln -s $DIR/bash_logout .bash_logout
ln -s $DIR/dircolors .dircolors
ln -s $DIR/gnuplot .gnuplot
ln -s $DIR/gvimrc .gvimrc
ln -s $DIR/vimrc .vimrc
ln -s $DIR/multitailrc .multitailrc
ln -s $DIR/tmux.conf .tmux.conf 
ln -s $DIR/vmdrc .vmdrc 
ln -s $DIR/bash_soft .bash_soft

cd -
