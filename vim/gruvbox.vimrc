call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'morhetz/gruvbox'
call plug#end()

let NERDTreeShowHidden=1

" Gruvbox
"let g:gruvbox_transparent_bg = 'medium' " soft, medium and hard
"colorscheme gruvbox
"set background=dark " dark/light

" Dracula
packadd! dracula
syntax enable
colorscheme dracula

let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

filetype plugin indent on
syntax on

set whichwrap=b,s,<,>,[,]
set mouse=a
set noshowmode
set cmdheight=1
set tabstop=4 shiftwidth=4 expandtab

"inoremap <C-s> <esc>:w<cr>                 " save files
"nnoremap <C-s> :w<cr>

"inoremap <C-d> <esc>:wq!<cr>               " save and exit
"nnoremap <C-d> :wq!<cr>

"inoremap <C-q> <esc>:qa!<cr>               " quit discarding changes
"nnoremap <C-q> :qa!<cr>

autocmd VimEnter * hi Normal ctermbg=none
"autocmd VimEnter * NERDTree
