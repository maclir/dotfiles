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

set wrap
autocmd FilterWritePre * if &diff | setlocal wrap< | endif

" lightline configuration {{{
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightLineFilename',
      \   'gitbranch': 'gitbranch#name'
      \ }
      \ }
function! LightLineFilename()
  return expand('%')
endfunction
" }}}

colorscheme jellybeans

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

set list listchars=tab:»·,trail:·

set runtimepath^=~/.vim/bundle/ctrlp.vim

set spelllang=en_us


" vim git configuration {{{
set updatetime=100
let g:gitgutter_max_signs = 500
let g:gitgutter_diff_args = '-w'
" }}}

" Yaml {{{
" Fix indention
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" Set filetype to ansible
au BufRead,BufNewFile *.yaml set filetype=ansible
" }}}

" Remove trailing whitespace {{{
autocmd BufWritePre * %s/\s\+$//e
autocmd FileType json,raml,yaml autocmd BufWritePre <buffer> %s/\s\+$//e
" }}}

" Load Config {{{
runtime! config/mappings.vim
runtime! config/plugins.vim
" }}}
