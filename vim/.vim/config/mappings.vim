let mapleader = ' '

nnoremap <C-D> :terminal<CR>

" FZF key bindings
nnoremap <Leader>o :FZF<CR>
nnoremap <Leader>O :FZF %:p:h<CR>
nnoremap <Leader>p :Files<CR>
nnoremap <C-f> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-i': 'split',
  \ 'ctrl-v': 'vsplit' }
