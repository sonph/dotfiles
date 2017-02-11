" Disable backward compatibility with vi.
set nocompatible

filetype off

" Set runtime path to include Vundle and initialize.
set runtimepath+=~/.vim/bundle/repos/github.com/Shougo/dein.vim

" General settings {
if !has('nvim') | set encoding=utf-8 | endif    " Neovim sets utf8 by default.
set fileencoding=utf-8
set ffs=unix,dos,mac

set textwidth=0 wrapmargin=0
set nowrap whichwrap=b,s,h,l,<,>,[,]
set nojoinspaces

" Search.
set ignorecase smartcase hlsearch incsearch

" Undo, backup, swap, history.
set history=1000 undolevels=1000
set nobackup noswapfile

" Indentation.
set expandtab shiftwidth=2 tabstop=2 softtabstop=2 smarttab smartindent
" Pressing backspace also deletes autoindents and newlines.
set backspace=indent,eol,start

" Line numbering.
set number relativenumber

" Column/row highlight.
try | set colorcolumn=81,121 | catch | set colorcolumn=121 | endtry
set cursorline
" Only highlight current line for active window.
" see http://vim.wikia.com/wiki/Highlight_current_line
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Syntax highlighting.
syntax on
set showmatch                           " Highlight matching parentheses.
set list                                " Highlight trailing whitespaces.
set listchars=tab:›·,trail:·,extends:›,precedes:‹

" Cursor and mouse
set ttyfast
set mouse=a                             " See http://usevim.com/2012/05/16/mouse/

if !has('nvim') | set ttymouse=xterm2 | endif

" Change the shape of the cursor according to the current mode.
" Only works in iTerm with or without tmux.
" See http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
if !empty($TMUX)
  " Inside a tmux session.
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  " Not inside a tmux session.
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Windows, buffers.
set splitbelow splitright
set switchbuf=usetab,newtab             " See http://vim.wikia.com/wiki/Using_tab_pages


" Misc.
set lazyredraw                          " Don't redraw while executing macros.
set wildmenu                            " Show autocompletion list.
set scrolloff=8                         " Minimum number of lines to keep above and below cursor.
set nofoldenable                        " Disable code folding.
set nospell                             " Disable spell checking.
set timeoutlen=1000 ttimeoutlen=0       " Eliminate delay after pressing Esc or ^c to return to normal mode
                                        " See https://www.johnhawthorn.com/2012/09/vi-escape-delays/
set noerrorbells visualbell t_vb=       " No bell sounds.
autocmd GUIEnter * set visualbell t_vb=

set autoread                            " Automatically reload file when changed from outside

" w!! to save file with sudo.
cmap w!! w !sudo tee % > /dev/null

" Remember last file edit position on open.
" See http://askubuntu.com/questions/202075/how-do-i-get-vim-to-remember-the-line-i-was-on-when-i-reopen-a-file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" }

" Language specific settings {
autocmd filetype python set shiftwidth=2 tabstop=2
autocmd filetype markdown set wrap
autocmd filetype java set colorcolumn=100
" }

if filereadable(expand('~/.vim/keymap.vim')) | source ~/.vim/keymap.vim | endif
if filereadable(expand('~/.vim/plugins.vim')) | source ~/.vim/plugins.vim | endif
if filereadable(expand('~/.vim/local.vim')) | source ~/.vim/local.vim | endif
if filereadable(expand('~/.vim/neovim.vim')) && has('nvim') | source ~/.vim/neovim.vim | endif

" Gvim {
if has('gui_running') && has('macunix')
endif
" }

" Colors {
set t_Co=256                                      " enable 256 colors
" Colorscheme and g:airline_theme are set in plugins.vim
hi MatchParen gui=inverse cterm=inverse
" }

if filereadable(expand('~/.vim/tabline.vim')) | source ~/.vim/tabline.vim | endif

" make sure this is the last line
filetype plugin indent on

