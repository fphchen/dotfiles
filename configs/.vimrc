" BASIC ------------------------------------------------------------------ {{{

" Set Encoding to UTF-8
set encoding=UTF-8

" No backup and No write backup
set nobackup nowritebackup

" Disable compatibility with vi which can cause unexpected issues
set nocompatible

" Enable type file detection
filetype on

" Enable plugins and load plugin for the detected file type
filetype plugin on

" Load an indent file for the detected file type
filetype indent on

" Enable colour
syntax on

" Enable spelling check 
set spelllang=en_ca
			
" Set vim colourscheme
colorscheme elflord
		  
" Enable auto completion menu after pressing TAB
set wildmenu

" List all matches and complete to the longest match
se wildmode=longest:full

" Show partial commands in the last line of the screen
set showcmd

" Add split screen horizontally to bottom
set splitbelow

" Add split screen vertically to right
set splitright

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files
set confirm

" Show relative line number
set number relativenumber

" Auto indent
set autoindent smartindent expandtab

" Set tab width to 4 columns
set tabstop=4 softtabstop=4

" Set shift width to 4 spaces
set shiftwidth=4

" Do not let cursor scroll below or above N number of lines when scrolling
set scrolloff=5

" Show & set colour for  horizontal & vertical cursor line
set cursorline
set cursorcolumn
highlight Cursorline ctermfg=Black
highlight CursorColumn ctermfg=Black
highlight Cursorline ctermbg=DarkGrey
highlight CursorColumn ctermbg=DarkGrey

" Search as characters are entered
set incsearch

" Highlight matched serach
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" }}}

" Netrw Settings ------------------------------------------------------------------ {{{

let g:netrw_banner=0
let g:netrw_liststyle = 3

" }}}

" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'
" Make sure you use single quotes
    Plug 'junegunn/fzf.vim'
" Initialize plugin system
call plug#end()

" }}}

" MAPPINGS --------------------------------------------------------------- {{{

" Set <leader> to \
let mapleader = "\\"

" Map common used vim commands to keys
nnoremap <leader>f :Files ~<CR>
nnoremap <leader>s :source ~/.vimrc<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :wq<CR>
nnoremap <leader>x :q!<CR>
nnoremap <leader>v :Vexplore<CR>
nnoremap <leader>h :Sexplore<CR>

" Use Shift to navigate between split screen mode
map <S-h> <C-w>h
map <S-j> <C-w>j
map <S-k> <C-w>k
map <S-l> <C-w>l

xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

" }}}

" STATUS LINE ------------------------------------------------------------ {{{

" Show the status on the second to last line.
set laststatus=2

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=%#NonText#
set statusline+=\ %F

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=%#TermCursor#
set statusline+=\ ascii:\%b\ hex:\0x%B\ %m\%r\%y\[%l/%L]\[%c]\[%p]

" }}}
