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
packadd termdebug
let mapleader = " "
nnoremap <Space> <Nop>
nnoremap <leader>d :Termdebug bin/out<CR>:close<CR>:resize 8<CR><C-w>w
nnoremap <leader>r :Run <CR>
nnoremap <leader>b :Break<CR>
nnoremap <leader>g :Clear<CR>
nnoremap <leader>c :Continue<CR>
nnoremap <leader>o :Over<CR>
nnoremap <leader>f :Finish<CR>
nnoremap <leader>s :Step<CR>
