" Space as the leader for everything; olang's keys are <Space>r run, b build, t test, f format, e explain, i prompt
let mapleader = " "
let maplocalleader = " "
nnoremap <Space> <Nop>
filetype plugin indent on
syntax on
colo torte
set mouse=a
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set number
set showmatch
set ignorecase
set incsearch
set nohlsearch
set expandtab
set nobackup
set noswapfile
set cursorline
set cursorlineopt=number
hi clear CursorLineNr
hi CursorLineNr ctermfg=magenta
set complete+=i
" Markdown read comfortably: long lines wrap at word boundaries, wrapped list items keep their indentation, and the
" ** and ` around text are hidden
autocmd FileType markdown setlocal wrap linebreak breakindent conceallevel=2
