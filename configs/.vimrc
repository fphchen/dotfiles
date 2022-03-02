 " BASIC ------------------------------------------------------------------ {{{

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
set wildmode=list:longest

" Show partial commands in the last line of the screen
set showcmd

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files
set confirm

" Show relative line number
set number relativenumber

" Auto indent
set autoindent

" Set tab width to 4 columns
set tabstop=4
set softtabstop=4

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

" PLUGINS ---------------------------------------------------------------- {{{

" }}}

" MAPPINGS --------------------------------------------------------------- {{{

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

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}
