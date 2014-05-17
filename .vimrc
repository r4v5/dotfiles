set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'rodjek/vim-puppet'
Plugin 'tpope/vim-rails.git'
Plugin 'stephpy/vim-yaml'
Plugin 'vim-ruby/vim-ruby'
Plugin 'oblitum/rainbow'
Plugin 'The-NERD-Commenter'
Plugin 'vimux'
Plugin 'jgdavey/vim-turbux'

call vundle#end()
filetype plugin indent on 
let g:rainbow_active = 1

syntax on

set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

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
