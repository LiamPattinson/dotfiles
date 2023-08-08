" Plugins. Use :PlugInstall to update
call plug#begin()
    " treesitter -- incremental highlighting updates
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

    " lspconfig -- set up Language Server Protocols
    Plug 'neovim/nvim-lspconfig' " Easier LSP setup

    " Autocompletion with nvim-cmp engine and vsnip snippets
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

    " Additional snippets
    Plug 'rafamadriz/friendly-snippets'

    " Fuzzy file finder, better file browser
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'nvim-telescope/telescope-file-browser.nvim'
    Plug 'nvim-tree/nvim-web-devicons'

    " Status line
    Plug 'nvim-lualine/lualine.nvim'

    " Better terminal
    Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

    " Better folding
    " Try https://github.com/kevinhwang91/nvim-ufo sometime

    " Git stuff
    Plug 'tpope/vim-fugitive'
    Plug 'mhinz/vim-signify'

    " Auto-documenting
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

    " Python stuff
    Plug 'psf/black', { 'branch': 'stable' }

    " Indent line
    Plug 'Yggdroot/indentLine'

    " Better commenting utils, uses gc plus movement (gcc to comment line)
    Plug 'numToStr/Comment.nvim'

    " Show the context of for loops, if statements etc
    Plug 'wellle/context.vim'

    " Better startup screen, session management (:SLoad, :SSave, :SDelete, :SClose)
    Plug 'mhinz/vim-startify'

    " Theme
    Plug 'dracula/vim'

    " Hardmode. Git gud.
    Plug 'takac/vim-hardtime'

    " syntax highlighting
    Plug 'cespare/vim-toml'
    Plug 'rust-lang/rust.vim'
    
    " LaTeX
    Plug 'vim-latex/vim-latex'

    " Reasonable defaults
    Plug 'tpope/vim-sensible'

call plug#end()

" Core set up

" Searching/matching
set showmatch " matching braces
set hlsearch " highlight searches
set incsearch " Begin search as chars are typed
set ignorecase " Don't count upper vs lower case
set smartcase " ... unless the search term contains upper case chars

" Indentation
set tabstop=4 " Number of columns occupied by a tab
set softtabstop=4 " Interpret multiples spaces as tabs
set shiftwidth=4 " Width of autoindents
set expandtab " Automatically convert tabs to spaces
set smarttab " Cleverer tabbing/spacing
set autoindent " Automatically indent based on last line

" Positional cues
set colorcolumn=88 " Coloured column at 88 chars
set number "Numbers on the left
set relativenumber " Besides current line, show relative numbers
set ruler " Info of char positions on current line

" Better autocomplete
set wildmode=longest,list,full " bash style tab autocomplete
set wildmenu " Give menu of possible autocompletes

" Misc
set wrap " Long lines wrap backup
set breakindent " Keep indentation when wrapping long lines
set title " Title of window set to title string
set laststatus=2 " Keep status lines on windows
set showcmd " Show last command
set showmode "Show which mode we're in
set mouse=a " Enable mouse clicking
set ttyfast " Faster scrolling (not sure if it works?)
set backupdir=~/.cache/vim "Directory for backup files
set hidden " When moving to new file, keep old one in buffer

color dracula

" Plugin set up
lua << EOF
servers = {
    'pyright',
}
require('treesitter-config')
require('nvim-cmp-config')
require('lspconfig-config')
require('telescope-config')
require('lualine-config')
require('comment-config')
require('toggleterm-config')
EOF

" snippets
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" terminal utils, window jumping
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
tnoremap <A-H> <C-\><C-N><C-w>H
tnoremap <A-J> <C-\><C-N><C-w>J
tnoremap <A-K> <C-\><C-N><C-w>K
tnoremap <A-L> <C-\><C-N><C-w>L
tnoremap <A-+> <C-\><C-N><C-w>+
tnoremap <A--> <C-\><C-N><C-w>-
tnoremap <A-<> <C-\><C-N><C-w><
tnoremap <A->> <C-\><C-N><C-w>>
tnoremap <Esc> <C-\><C-n>
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-H> <C-\><C-N><C-w>H
inoremap <A-J> <C-\><C-N><C-w>J
inoremap <A-K> <C-\><C-N><C-w>K
inoremap <A-L> <C-\><C-N><C-w>L
inoremap <A-+> <C-\><C-N><C-w>+
inoremap <A--> <C-\><C-N><C-w>-
inoremap <A-<> <C-\><C-N><C-w><
inoremap <A->> <C-\><C-N><C-w>>
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap <A-H> <C-w>H
nnoremap <A-J> <C-w>J
nnoremap <A-K> <C-w>K
nnoremap <A-L> <C-w>L
nnoremap <A-+> <C-w>+
nnoremap <A--> <C-w>-
nnoremap <A->> <C-w>>
nnoremap <A-<> <C-w><

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" hardmode settings
let g:hardtime_default_on = 1
let g:hardtime_showmsg = 1
let g:hardtime_ignore_buffer_patterns = [ "vim.lsp" ]
let g:hardtime_maxcount = 4
let g:hardtime_motion_with_count_resets = 1

" Default auto-documenting settings
let g:doge_doc_standard_python = 'numpy'

" Settings for LaTeX, markdown, rst, etc
let g:tex_flavor = "latex"
autocmd FileType tex,latex,rst,markdown setlocal tw=88
autocmd FileType tex,latex,rst,markdown setlocal spell spelllang=en_gb tw=88

" Settings for C/C++/Fortran
autocmd FileType c,cpp,cmake,fortran setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufRead,BufNewFile *.c.in,*.h.in setlocal filetype=c
autocmd BufRead,BufNewFile *.cpp.in,*.hpp.in,*.cxx.in,*.hxx.in,*.H.in,*C.in setlocal filetype=cpp
autocmd BufRead,BufNewFile *.pf setlocal filetype=fortran

" Disable dangerous exit modes
nnoremap Z <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

filetype plugin indent on
syntax on

