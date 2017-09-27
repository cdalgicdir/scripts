augroup syntax
:autocmd FileType *      set formatoptions=tcql nocindent comments&
:autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,ex:*/,://
:autocmd FileType mdp.gromacs set omnifunc=mdpcomplete#Complete
" imap <C-n> <C-x><C-o>
:autocmd FileType python set omnifunc=pythoncomplete#Complete
:autocmd BufWritePre *.gro call Update_number_of_atoms()
:au BufNewFile,BufRead *.rtp    setf top.gromacs
:au BufNewFile,BufRead *.gp  set filetype=gnuplot
:au BufNewFile,BufRead *.comms  set filetype=sh
:au BufNewFile,BufRead .vmdrc  set filetype=tcl
:au BufNewFile,BufRead bash-fc-*    set syntax=sh
:au BufNewFile,BufReadPost *.lmp           setfiletype lammps
:au BufNewFile,BufReadPost *.lammps           setfiletype lammps
:au BufNewFile,BufReadPost system.in.init           setfiletype lammps
:au BufNewFile,BufReadPost system.in.settings           setfiletype lammps
:au BufNewFile,BufReadPost run.in.*           setfiletype lammps
:au BufNewFile,BufReadPost in.*           setfiletype lammps
" :au BufNewFile,BufReadPost *.tex           setfiletype plaintex
:autocmd FileType bib  set paste
:autocmd FileType plumed.dat      setfiletype plumed
:au BufNewFile,BufReadPost plumed.dat           setfiletype plumed
:autocmd FileType colvar      setfiletype plumedf
:au BufNewFile,BufReadPost colvar           setfiletype plumedf
:autocmd FileType COLVAR      setfiletype plumedf
:au BufNewFile,BufReadPost COLVAR           setfiletype plumedf
augroup end
