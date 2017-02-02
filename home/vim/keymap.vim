" Leader key mappings are in plugins.vim
let mapleader=' '

nnoremap ; :

noremap <C-c> <Esc>
inoremap jj <ESC>
inoremap jk <ESC>

" In soft wrap mode, gj goes to the next display line and not logical line.
nnoremap j gj
nnoremap k gk

" Emacs-like keybindings in insert and command mode.
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-p> <Up>
inoremap <C-n> <Down>

" Tab and S-Tab to indent/unindent in visual mode.
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <Tab> >>
noremap <S-Tab> <<

" Indent/unindent in visual mode without exiting.
vnoremap > >gv
vnoremap < <gv

" Create new buffer with ^w n
noremap <C-w>n :new<Enter>

" Tabs
nnoremap <C-w><Tab> :tabn<CR>
nnoremap <C-w><S-Tab> :tabp<CR>
nnoremap <C-w>t :tabnew<CR>
for i in range(1, 9)
  " Use <C-w>i to switch to tab i.
  execute 'nnoremap <C-w>' . i . ' ' . i . 'gt<CR>'
endfor

" By default C-q is 'unfreeze', so we tells the terminal to forward it to vim
" and map it to :qall instead.
" See http://stackoverflow.com/questions/7883803/why-doesnt-map-c-q-q-cr-work-in-vim
silent !stty -ixon 2>&1 > /dev/null
nnoremap <C-q> :qall<CR>

