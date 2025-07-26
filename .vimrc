# ~/.vimrc - Vim configuration

" Basic settings
set nocompatible              " be iMproved, required
filetype off                  " required

" Vundle setup
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" File management
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'

" Git integration
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Code editing
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'jiangmiao/auto-pairs'

" Syntax highlighting
Plugin 'sheerun/vim-polyglot'

" Status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Color schemes
Plugin 'dracula/vim', { 'name': 'dracula' }
Plugin 'morhetz/gruvbox'

" Search
Plugin 'mileszs/ack.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Basic settings
syntax enable                " Enable syntax highlighting
set number                   " Show line numbers
set relativenumber           " Show relative line numbers
set cursorline              " Highlight current line
set wildmenu                " Visual autocomplete for command menu
set lazyredraw              " Redraw only when we need to
set showmatch               " Highlight matching [{()}]
set incsearch               " Search as characters are entered
set hlsearch                " Highlight matches
set ignorecase              " Ignore case when searching
set smartcase               " When searching try to be smart about cases
set autoread                " Auto reload file when changed externally
set hidden                  " Allow hidden buffers
set encoding=utf8           " Set utf8 as standard encoding
set ffs=unix,dos,mac        " Use Unix as the standard file type

" Spaces & Tabs
set tabstop=4               " Number of visual spaces per TAB
set softtabstop=4           " Number of spaces in tab when editing
set expandtab               " Tabs are spaces
set shiftwidth=4            " Number of spaces to use for autoindent
set autoindent              " Auto indent
set smartindent             " Smart indent

" UI Config
set ruler                   " Always show current position
set cmdheight=2             " Height of the command bar
set hid                     " A buffer becomes hidden when it is abandoned
set backspace=eol,start,indent " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l
set laststatus=2            " Always show the status line
set mouse=a                 " Enable mouse usage
set scrolloff=7             " Set 7 lines to the cursor - when moving vertically using j/k

" Color scheme
set background=dark
colorscheme dracula

" NERDTree settings
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dracula'

" Key mappings
let mapleader = ","         " Leader key

" Quick save
nmap <leader>w :w!<cr>

" Quick quit
map <leader>q :q<cr>

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" Turn backup off
set nobackup
set nowb
set noswapfile

" Persistent undo
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry
