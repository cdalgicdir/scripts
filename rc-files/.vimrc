:syntax on
:autocmd FileType *      set formatoptions=tcql nocindent comments&
:autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,ex:*/,://
:autocmd FileType mdp.gromacs set omnifunc=mdpcomplete#Complete
" imap <C-n> <C-x><C-o>
:autocmd FileType python set omnifunc=pythoncomplete#Complete
:autocmd BufWritePre *.gro call Update_number_of_atoms()
:au BufNewFile,BufRead *.rtp    setf top.gromacs
:au BufNewFile,BufRead *.gp  set filetype=gnuplot
:au BufNewFile,BufRead .vmdrc  set filetype=tcl
:au BufNewFile,BufRead bash-fc-*    set syntax=sh
":au BufRead *.tex set spell
":highlight SpellBad gui=underline guibg=NONE guifg=NONE

:map <F6> {v}!par -w75<CR>
:vmap <F6> !par -w75<CR>
:map <F4> :highlight Normal ctermfg=black ctermbg=white<CR>

":set autoindent
set autowrite
set ruler
:ab #i #include
:ab #b /********************************************************
:ab #c ###################################################################
:ab #d %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:ab #e ********************************************************/
:ab #l /*------------------------------------------------------*/
:set sw=4
set notextmode
set notextauto
set hlsearch
set incsearch
set history=1000
set undolevels=1000
":set textwidth=100
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present

map <F8> :w <enter> :!/home/cdalgicdir/progs/bin/vimrun % <enter>
map <F2> :w <enter> :!/home/cdalgicdir/progs/bin/latexcrop % <enter>
"nnoremap    <F2> :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>

" LATEX PLUGIN options 

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
"filetype plugin on

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
"filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
"
" Use spaces instead of tabs for python
"set tabstop=4
"set shiftwidth=4
"set expandtab
"retab

" Bubble single lines
nmap <C-Up> ddkP
nmap <C-Down> ddp
" " Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]
" Visually select the text that was last edited/pasted
map gV `[v`]
nore ; :
nore , ;
" nnoremap <Up> gk
"let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -src-specials -interaction=nonstopmode $*'
"let g:Tex_ViewRule_pdf = 'okular --unique'
"function! SyncTexForward()
"    let s:syncfile = fnamemodify(fnameescape(Tex_GetMainFileName()), ":r").".pdf"
"    let execstr = "silent !okular --unique ".s:syncfile."\\#src:".line(".").expand("%\:p").' &'
"    exec execstr
"endfunction
"nnoremap <Leader>f :call SyncTexForward()<CR>
"
:set nocompatible
:filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'matchit.zip'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'beloglazov/vim-online-thesaurus'
Plugin 'HubLot/vim-gromacs'
" colorschemes
Plugin 'flazz/vim-colorschemes'
Plugin 'depuracao/vim-darkdevel'
Plugin 'altercation/solarized'
Plugin 'github-theme'
" Markdown syntax highlighting
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'bling/vim-airline'
Plugin 'benmills/vimux'
Plugin 'kien/ctrlp.vim'
Plugin 'jeetsukumaran/vim-buffergator'
" Git plugin not hosted on GitHub
"lugin 'https://github.com/Lokaltog/vim-easymotion.git'
"Plugin 'https://github.com/vim-scripts/Rainbow-Parenthsis-Bundle.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
:let g:notes_directory = '~/Documents/Notes'

autocmd FileType top.gromacs set commentstring=;\ %s
autocmd FileType mdp.gromacs set commentstring=;\ %s

" Toggle fold state between closed and opened. 
  " 
  " If there is no fold at current line, just moves forward. 
  " If it is present, reverse it's state. 
  fun! ToggleFold() 
  if foldlevel('.') == 0 
  normal! l 
  else 
  if foldclosed('.') < 0 
  . foldclose 
  else 
  . foldopen 
  endif 
  endif 
  " Clear status line 
  echo 
  endfun 
  " Map this function to Space key. 
  noremap <space> :call ToggleFold()<CR>

" Rainbowparentheses always on
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

" matchit
":source ~/.vim/bundle/vim-matchit/plugin/matchit.vim

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg|xtc|edr|cpt|tpr|pdf)$',
  \}
" https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
" Use a leader instead of the actual named binding
nmap <leader>p :CtrlP<cr>

" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>
" /CtrlP

set wildignore=*.log,*.aux,*.dvi,*.aut,*.aux,*.bbl,*.blg,*.dvi,*.fff,*.log,*.out,*.pdf,*.ps,*.toc,*.ttt
set thesaurus+=~/.vim/thesaurus/mthesaur.txt
set dictionary+=/usr/share/dict/words

" Buffergator
" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'R'

" I want my own keymappings...
let g:buffergator_suppress_keymaps = 0

" Looper buffers
"let g:buffergator_mru_cycle_loop = 1

" Go to the previous buffer open
nmap <leader>jj :BuffergatorMruCyclePrev<cr>

" Go to the next buffer open
nmap <leader>kk :BuffergatorMruCycleNext<cr>

" View the entire list of buffers open
nmap <leader>bl :BuffergatorOpen<cr>

" Shared bindings from Solution #1 from earlier
nmap <leader>T :enew<cr>
nmap <leader>bq :bp <BAR> bd #<cr>

" /Buffergator

":command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g
"
"func! WordProcessorMode() 
"  setlocal formatoptions=1 
"  setlocal noexpandtab 
"  map j gj 
"  map k gk
"  setlocal spell spelllang=en_us 
"  set complete+=s
"  set formatprg=par
"  setlocal wrap 
"  setlocal linebreak 
"endfu 
"com! WP call WordProcessorMode()
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats = 'pdf'
let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode $*'
let g:Tex_GotoError = 0
let g:Tex_ViewRule_pdf = 'evince'
" Initial fold level for markdown syntax plugin
let g:vim_markdown_initial_foldlevel=4
" Highlight YAML frontmatter
let g:vim_markdown_frontmatter=1
let g:vim_markdown_math=1
" Highlight line with \l, 'l to return to line and :match to clear
nnoremap <silent> <Leader>l ml:execute 'match Search /\%'.line('.').'l/'<CR>

" vim-airline settings
"let g:airline_left_sep=''
"let g:airline_right_sep=''
let g:airline#extensions#whitespace#trailing_format = 'trailing[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = 'mixed-indent[%s]'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Hide function display (don't use it)
let g:airline#extensions#tagbar#enabled = 0

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts=1

if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

let g:airline_theme='dark'

" Vimux settings
let g:VimuxHeight = "30"
let g:VimuxOrientation = "v"
let g:VimuxUseNearestPane = 0

" Vimux Mappings
nmap <leader>vp :VimuxPromptCommand<cr>
nmap <leader>vl :VimuxRunLastCommand<cr>
nmap <leader>vq :VimuxCloseRunner<cr>
nmap <leader>vx :VimuxInterruptRunner<cr>
