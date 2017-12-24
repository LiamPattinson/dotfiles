" Installing Vundle vim:
" Requires git install
" > git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" ==================================================================
" MY PLUGINS
" ==================================================================

" solarized theme
Plugin 'altercation/vim-colors-solarized'

" vim-airline -- better status/tabline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" obsession -- auto session saving
Plugin 'tpope/vim-obsession'

" tmux line -- better tmux integration
Plugin 'edkolev/tmuxline.vim'

" fugitive -- fancy Git plugin
Plugin 'tpope/vim-fugitive'

" gitgutter -- show git changes on left-hand side
Plugin 'airblade/vim-gitgutter'

" vim-latex -- features to improve LaTeX editing experience
Plugin 'vim-latex/vim-latex'

" rust syntax highlighting
Plugin 'rust-lang/rust.vim'

" ==================================================================

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

" ==================================================================
" PERSONAL SETUP
" ==================================================================

" Statusbar commands. Allows coloured status.
set laststatus=2

" Airline config 
let g:airline_powerline_fonts = 1

" Numbering on left of screen
set relativenumber
set number

" Indenting
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Colorscheme
syntax enable
set background=dark
colorscheme solarized
let g:solarized_termcolors=256

" LaTeX Settings
let g:tex_flavor = "latex"
au BufRead *.tex setlocal tw=79
au BufRead *.tex setlocal spell spelllang=en_gb
helptags ~/.vim/bundle/vim-latex/doc
