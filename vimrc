scriptencoding utf-8
set encoding=utf-8

let g:coc_node_path = trim(system('which node'))

call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
cal plug#end()

set background=dark
colorscheme gruvbox

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FIX for WSL arrow keys not working
" source https://wsl-guide.kennethreitz.org/_/downloads/en/latest/pdf/
" uncomment the line below on windows WSL
" set term=builtin_ansi
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on
"  
" Enable syntax highlighting
syntax on
" Better command-line completion
set wildmenu  
" Show partial commands in the last line of the screen
set showcmd
" Display the cursor position on the last line of the screen or in the status
" line of a window
"set ruler
" Always display the status line, even if only one window is displayed
set laststatus=2
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
" Use visual bell instead of beeping when doing something wrong
"set visualbell
" Enable use of the mouse for all modes
"set mouse=a
" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2
" Display line numbers on the left
set number
" Now i can move inside files with cursors but i cant use "delete" and "backspace"
set nocp

"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.
 
" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab
"  
" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
"set shiftwidth=4
"set tabstop=4
"
"
"------------------------------------------------------------
"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings  
let mapleader = "?"
" 
" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,    
" which is the default
map Y y$
" Map <C-L> (redraw screen) to also turn off search highlighting until the next search
nnoremap <C-L> :nohl<CR><C-L>

" disable modifyOtherKeys
let &t_TI = ""
let &t_TE = ""

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬,nbsp:~,trail:·
" Uncomment this to enable by default:
"set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

" NERDTree
map <F2> :NERDTreeToggle<cr>


" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
"set incsearch
"set ignorecase
"set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

"------------------------------------------------------------

" Color scheme (terminal)
set t_Co=256
"set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
"colorscheme solarized

"------------------------------------------------------------
"PowerLine setup
"
set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

"------------------------------------------------------------
"setup plugins
"
let g:VEConf_filePanelSortType = 1
let g:VEConf_showHiddenFiles = 0
"------------------------------------------------------------
"
" TABS Config
set showtabline=2
nnoremap <silent> <C-k>        :<Esc>:q!<CR>
nnoremap <silent> <C-n>        :tabnew<CR>
nnoremap <silent> <Leader>tq   :tabclose<CR>
nnoremap <silent> <Leader>tt   :tabs<CR>
nnoremap <silent> <Leader>tn   :tabnext<CR>
nnoremap <silent> <Leader>>    :tabnext<CR>
nnoremap <silent> <Leader>tp   :tabprevious<CR>
nnoremap <silent> <Leader><    :tabprevious<CR>

" navigation like firefox
nnoremap <C-S-tab>      :tabprevious<CR>
nnoremap <C-tab>        :tabnext<CR>
nnoremap <C-S-t>        :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>
inoremap <C-S-w>   <Esc>:tabclose<CR>
nnoremap <A-F1> 1gt
nnoremap <A-F2> 2gt
nnoremap <A-F3> 3gt
nnoremap <A-F4> 4gt
nnoremap <A-F5> 5gt
nnoremap <A-F6> 6gt
nnoremap <A-F7> 7gt
nnoremap <A-F8> 8gt
nnoremap <A-F9> 9gt
nnoremap <A-F10> 10gt 
"------------------------------------------------------------
" my mappings
" save read only files
cnoremap w!! w !sudo tee % >/dev/null
" CTRL-S AS save
nnoremap <C-s>     :w<CR>
inoremap <silent> <C-s>     <Esc>:w<CR>i
"------------------------------------------------------------
" abrevations
:iabbrev _bash #!/bin/bash
