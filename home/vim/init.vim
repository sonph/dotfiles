" Disable backward compatibility with vi.
set nocompatible

filetype off

" Set runtime path to include Vundle and initialize.
set rtp+=~/.vim/bundle/Vundle.vim


" General settings {
" File encoding: utf-8
if !has('nvim')
  set encoding=utf-8
endif
set fileencoding=utf-8
set ffs=unix,dos,mac

" Line wrapping
" disable automatic hard line wrapping
" see http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
set textwidth=0
set wrapmargin=0
                                                  " http://vim.wikia.com/wiki/Automatic_word_wrapping
set nowrap                                        " no soft wrapping either
set nojoinspaces                                  " prevent 2 consecutive spaces after punctuation on a join (J)
set whichwrap=b,s,h,l,<,>,[,]                     " also wrap these keys: backspace, navigational

" Search
set ignorecase                                    " ignore case when searching
set smartcase                                     " SMART CASE: case-sensitive if the search term has a uppercased char
set hlsearch                                      " highlight search terms
set incsearch                                     " show search matches as you type

" Undo, backup, swap, history
set history=1000                                  " remember more commands and search history
set undolevels=1000                               " more undos

set nobackup                                      " don't use backup or swap files
set noswapfile

" Indentation settings
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smarttab                                      " insert tabs on the start of a line according to shiftwidth,
                                                  " not tabstop
set smartindent                                   " smart indent (does the right thing, most of the time)
set backspace=indent,eol,start                    " allow backspace to also delete autoindents and newlines

" Line numbering and highlight
set number                                        " show line numbers
set relativenumber
try                                               " set color columns to mark 80 and 120 character limits
  set colorcolumn=81,121
catch
  set colorcolumn=121                             " if 2 color columns are not supported
endtry

set cursorline                                    " highlight current line
" only highlight current line for active window
" see http://vim.wikia.com/wiki/Highlight_current_line
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Highlighting
syntax on                                         " syntax highlighting pls
set showmatch                                     " show matching parentheses
set list                                          " highlight trailing spaces
set listchars=tab:›·,trail:·,extends:›,precedes:‹

" Cursor and mouse
set ttyfast                                       " enable mouse support
set mouse=a                                       " see http://usevim.com/2012/05/16/mouse/

if !has('nvim')                                   " nvim doesn't have ttymouse. Mouse support is enabled by default
  set ttymouse=xterm2                             " set this to name of your terminal that supports mouse codes:
endif                                             " xterm, xterm2, netterm, dec, jsbterm, pterm

" change cursor shapes according to current mode
" only works in iTerm. tmux optional.
" see http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
if !empty($TMUX)
  " inside a tmux session
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  " not inside a tmux session
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


" Windows, buffers
set splitbelow                                    " open new split windows to the right and bottom
set splitright

set switchbuf=usetab,newtab                       " see http://vim.wikia.com/wiki/Using_tab_pages


" Other
set lazyredraw                                    " don't redraw while executing macros
set wildmenu                                      " show list instead of just autocompleting commands
set scrolloff=8                                   " minimum lines to keep above and below cursor
set nofoldenable                                  " disable code folding
set nospell                                       " disable spell checking
set timeoutlen=1000 ttimeoutlen=0                 " eliminate delay after pressing Esc or ^c to return to normal mode
                                                  " see https://www.johnhawthorn.com/2012/09/vi-escape-delays/
set noerrorbells visualbell t_vb=                 " no bell sounds
autocmd GUIEnter * set visualbell t_vb=

set autoread                                      " automatically reload file when changed from outside

cmap w!! w !sudo tee % > /dev/null                " w!! to save file with sudo

" remember last file edit position
" see
" http://askubuntu.com/questions/202075/how-do-i-get-vim-to-remember-the-line-i-was-on-when-i-reopen-a-file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" }

" Language specific settings {
" autocmd filetype python set shiftwidth=2 tabstop=2
" }

if filereadable(expand('~/.vim/keymap.vim')) | source ~/.vim/keymap.vim | endif
if filereadable(expand('~/.vim/plugins.vim')) | source ~/.vim/plugins.vim | endif
if filereadable(expand('~/.vim/google.vim')) | source ~/.vim/google.vim | endif
if filereadable(expand('~/.vim/neovim.vim')) && has('nvim') | source ~/.vim/neovim.vim | endif

" Gvim {
if has('gui_running') && has('macunix')
endif
" }

" Custom commands {

function! DeleteTrailingWs_()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunction
command! DeleteTrailingWs call DeleteTrailingWs_()
" }

" Colors {
set t_Co=256                                      " enable 256 colors
colorscheme onehalflight
let g:airline_theme='onehalfdark'
" }

if filereadable(expand('~/.vim/tabline.vim')) | source ~/.vim/tabline.vim | endif

" make sure this is the last line
filetype plugin indent on

