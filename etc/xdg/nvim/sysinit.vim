set number
set wrap
syntax on
set cursorline
set mouse=
set termguicolors
set background=dark
set signcolumn=yes

" allow backspace on indent, end of line or insert mode start position
set backspace=indent,eol,start

" use system clipboard
set clipboard=unnamedplus

" tab
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set autoindent
set smartindent

" ignore case when searching
set ignorecase
set smartcase

" disable swapfile
set noswapfile

" lines
set cc=80

" make background transparent
highlight Normal guibg=none
highlight NonText guibg=none
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" keybinds
map <F4> :nohl<CR>
