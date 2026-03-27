scriptencoding utf-8
set encoding=utf-8

if empty(&shell) || fnamemodify(&shell, ':t') ==# '-bash'
  let &shell = exepath('bash')
endif
if empty(&shell)
  let &shell = exepath('sh')
endif

let g:coc_node_path = exists('*exepath')
      \ ? exepath('node')
      \ : substitute(system('which node'), '\n', '', 'g')

call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'do': 'fzf#install()' }
Plug 'junegunn/fzf.vim'
Plug '~/VimSession_plug'
call plug#end()

"## NERDTree config
autocmd BufEnter * if !argc() | NERDTreeMirror | endif


"## vimsession cinfig
let g:vimsession_directory = '~/.vim_sessions'
let g:vimsession_auto_load = 1
let g:vimsession_auto_save = 1
let g:vimsession_create_on_start = 1

set background=dark
"colorscheme gruvbox

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
" USER COMMANDS
" delete open buffers and reopen current file
command! Clean %bd|e#

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

" Use Ctrl + j/k to cycle through buffers
nnoremap <C-j> :bn<CR>
nnoremap <C-k> :bp<CR>

" disable modifyOtherKeys
let &t_TI = ""
let &t_TE = ""

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬,nbsp:%,trail:~,space:·
" Uncomment this to enable by default:
"set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

" NERDTree
map <F2> :NERDTreeToggle<cr>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif


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
nnoremap <silent> <C-w>        :<Esc>:q<CR>
nnoremap <silent> <C-n>        :tabnew<CR>
nnoremap <silent> <Leader>tq   :tabclose<CR>
nnoremap <silent> <Leader>tt   :tabs<CR>
nnoremap <silent> <Leader>tn   :tabnext<CR>
nnoremap <silent> <Leader>>    :tabnext<CR>
nnoremap <silent> <Leader>tp   :tabprevious<CR>
nnoremap <silent> <Leader><    :tabprevious<CR>

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


""------------------------------------------------------------""
let g:last_terminal_popup = get(g:, 'last_terminal_popup', 0)

function! s:GetTerminalPopupId() abort
  if type(get(g:, 'last_terminal_popup', 0)) != v:t_number
    let g:last_terminal_popup = 0
  endif

  let l:popup_id = g:last_terminal_popup
  if l:popup_id <= 0 || empty(popup_getpos(l:popup_id))
    let g:last_terminal_popup = 0
    echohl WarningMsg
    echomsg 'No active terminal popup'
    echohl None
    return 0
  endif

  return l:popup_id
endfunction

function! OpenTerminalPopup(...) abort
  let l:cmd = a:0 >= 1 ? a:1 : &shell
  let l:title = a:0 >= 2 ? a:2 : ' Terminal '
  let l:cmd_name = type(l:cmd) == v:t_list ? get(l:cmd, 0, '') : get(split(l:cmd), 0, '')

  if empty(l:cmd_name)
    echohl WarningMsg
    echomsg 'Popup command is empty'
    echohl None
    return -1
  endif

  if l:cmd_name !=# &shell && executable(l:cmd_name) == 0 && empty(exepath(l:cmd_name))
    echohl WarningMsg
    echomsg 'Command not found: ' . l:cmd_name
    echohl None
    return -1
  endif

  let l:buf = term_start(l:cmd, {
        \ 'hidden': 1,
        \ 'cwd': getcwd(),
        \ 'term_finish': 'close',
        \ })

  if l:buf <= 0
    echohl WarningMsg
    echomsg 'Failed to start popup command: ' . string(l:cmd)
    echohl None
    return -1
  endif

  let l:popup_id = popup_create(l:buf, {
        \ 'title': l:title,
        \ 'pos': 'center',
        \ 'minwidth': 80,
        \ 'minheight': 20,
        \ 'maxwidth': max([&columns - 4, 20]),
        \ 'maxheight': max([&lines - 4, 10]),
        \ 'border': [],
        \ 'padding': [0, 1, 0, 1],
        \ 'drag': 1,
        \ 'resize': 1,
        \ })

  let g:last_terminal_popup = l:popup_id
  call win_execute(l:popup_id, 'startinsert')
  return l:popup_id
endfunction

function! MoveTerminalPopup(dline, dcol) abort
  let l:popup_id = s:GetTerminalPopupId()
  if l:popup_id == 0
    return 0
  endif

  let l:pos = popup_getpos(l:popup_id)
  call popup_move(l:popup_id, {
        \ 'line': max([1, l:pos.line + a:dline]),
        \ 'col': max([1, l:pos.col + a:dcol]),
        \ })
  return l:popup_id
endfunction

function! ResizeTerminalPopup(dwidth, dheight) abort
  let l:popup_id = s:GetTerminalPopupId()
  if l:popup_id == 0
    return 0
  endif

  let l:pos = popup_getpos(l:popup_id)
  call popup_move(l:popup_id, {
        \ 'minwidth': max([20, l:pos.width + a:dwidth]),
        \ 'maxwidth': max([20, l:pos.width + a:dwidth]),
        \ 'minheight': max([10, l:pos.height + a:dheight]),
        \ 'maxheight': max([10, l:pos.height + a:dheight]),
        \ })
  return l:popup_id
endfunction

command! TerminalPopup call OpenTerminalPopup()
command! CopilotPopup call OpenTerminalPopup('copilot', ' Copilot ')
command! LazygitPopup call OpenTerminalPopup('lazygit', ' Lazygit ')

nnoremap <leader>ps <Cmd>TerminalPopup<CR>
nnoremap <leader>pc <Cmd>CopilotPopup<CR>
nnoremap <leader>pg <Cmd>LazygitPopup<CR>
nnoremap <leader>ph <Cmd>call MoveTerminalPopup(0, -3)<CR>
nnoremap <leader>pj <Cmd>call MoveTerminalPopup(1, 0)<CR>
nnoremap <leader>pk <Cmd>call MoveTerminalPopup(-1, 0)<CR>
nnoremap <leader>pl <Cmd>call MoveTerminalPopup(0, 3)<CR>
nnoremap <leader>pH <Cmd>call ResizeTerminalPopup(-4, 0)<CR>
nnoremap <leader>pJ <Cmd>call ResizeTerminalPopup(0, 2)<CR>
nnoremap <leader>pK <Cmd>call ResizeTerminalPopup(0, -2)<CR>
nnoremap <leader>pL <Cmd>call ResizeTerminalPopup(4, 0)<CR>
tnoremap <leader>ph <C-\><C-n><Cmd>call MoveTerminalPopup(0, -3)<CR>i
tnoremap <leader>pj <C-\><C-n><Cmd>call MoveTerminalPopup(1, 0)<CR>i
tnoremap <leader>pk <C-\><C-n><Cmd>call MoveTerminalPopup(-1, 0)<CR>i
tnoremap <leader>pl <C-\><C-n><Cmd>call MoveTerminalPopup(0, 3)<CR>i
tnoremap <leader>pH <C-\><C-n><Cmd>call ResizeTerminalPopup(-4, 0)<CR>i
tnoremap <leader>pJ <C-\><C-n><Cmd>call ResizeTerminalPopup(0, 2)<CR>i
tnoremap <leader>pK <C-\><C-n><Cmd>call ResizeTerminalPopup(0, -2)<CR>i
tnoremap <leader>pL <C-\><C-n><Cmd>call ResizeTerminalPopup(4, 0)<CR>i
