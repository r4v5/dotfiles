set nocompatible
filetype off

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

let g:rainbow_active = 1
autocmd vimenter * if !argc() | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>


syntax on

set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

set mouse=a


set hlsearch
set ignorecase
set smartcase
set incsearch
set expandtab
set shiftwidth=2
set tabstop=2
set number
set numberwidth=2
set autoindent
