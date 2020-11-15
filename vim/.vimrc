set guifont=Ubuntu\ Mono:h15:cANSI

packadd! dracula
syntax enable
let g:dracula_colorterm = 0
colorscheme dracula

filetype plugin indent on
syntax on

set whichwrap=b,s,<,>,[,]
set mouse=a
set noshowmode
set tabstop=4 shiftwidth=4 expandtab

let g:airline_powerline_fonts = 1
let g:airline_theme='minimal'

inoremap <C-s> <esc>:w<cr>                 " save files
nnoremap <C-s> :w<cr>

inoremap <C-d> <esc>:wq!<cr>               " save and exit
nnoremap <C-d> :wq!<cr>

inoremap <C-q> <esc>:qa!<cr>               " quit discarding changes
nnoremap <C-q> :qa!<cr>
