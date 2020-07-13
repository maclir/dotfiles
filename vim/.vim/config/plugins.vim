call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sleuth'
Plug 'fatih/vim-go'
Plug 'chase/vim-ansible-yaml'
Plug 'avakhov/vim-yaml'
Plug 'editorconfig/editorconfig-vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'rking/ag.vim'
Plug 'neomake/neomake'
Plug 'udalov/kotlin-vim'
Plug 'delphinus/vim-firestore'
Plug 'leafgarland/typescript-vim'

call plug#end()
