" Main
syntax on
set nowrap
set nocompatible              " be iMproved, required
filetype off                  " required
set shortmess=F

" Syntax Highlight
au BufNewFile,BufRead /*.rasi setf css

" Remaps
nnoremap <F5> "=strftime("%c")<CR>P
inoremap <F5> <C-R>=strftime("%c")<CR>
cabbrev q q!
" unmap <C-x>
nnoremap <C-x> <esc><return>:qa<return>
inoremap <C-x> <esc><return>:qa<return>

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set t_Co=256
" colorscheme minimalist
colorscheme nord
" colorscheme dracula2
" let g:airline_theme='minimalist'
let g:airline_theme='nord'
" let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
" set laststatus=2 " Always display the statusline in all windows
" set showtabline=2 " Always display the tabline, even if there is only one tab
set guifont=Inconsolata:h15
