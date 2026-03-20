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
nnoremap <A-d> :Termdebug bin/out<CR>:close<CR>:resize 8<CR><C-w>w
nnoremap <A-r> :Run <CR>
nnoremap <A-b> :Break<CR>
nnoremap <A-g> :Clear<CR>
nnoremap <A-c> :Continue<CR>
nnoremap <A-o> :Over<CR>
nnoremap <A-e> :Evaluate<CR>
nnoremap <A-f> :Finish<CR>
nnoremap <A-s> :Step<CR>
