set encoding=utf-8
set expandtab
set tabstop=4
set shiftwidth=4
set ruler
set hlsearch

filetype plugin indent on

set t_Co=16
syntax enable

"split navigations, use normal navigation letters with Ctrl to move
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" End super-standard vimrc

execute pathogen#infect()


" ignore python-compiled files in NERDTree file browser
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
