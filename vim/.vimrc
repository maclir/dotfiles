syntax on
set backspace=eol,start,indent
au FileType gitcommit set tw=72
au BufNewFile,BufRead COMMIT_EDITMSG set ft=gitcommit
set cursorline

filetype indent plugin on
set hlsearch

set ignorecase
set smartcase
set autoindent
set ruler
set number

set background=dark
colorscheme Tomorrow-Night

set undodir=~/.vimundo
if !isdirectory(expand(&undodir))
	silent execute '!mkdir -p ' . &undodir
endif

set undofile

" Tabs and indenting {{{
set noexpandtab smarttab
set copyindent
set preserveindent
set tabstop=4 softtabstop=0
set shiftwidth=4
set autoindent
set smartindent
" }}}
