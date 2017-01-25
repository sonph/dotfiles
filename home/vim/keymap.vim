let mapleader=' '
nnoremap ; :

noremap <C-c> <Esc>
inoremap jj <ESC>
inoremap jk <ESC>

" In soft wrap mode, gj goes to the next display line and not logical line.
nnoremap j gj
nnoremap k gk

" C-a/C-e to go to beginning/end of line in insert mode.
" (C-o puts you in command mode for one key only)
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
" C-f/C-b for moving right/left.
inoremap <C-f> <Right>
inoremap <C-b> <Left>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" Tab and S-Tab to indent/unindent in visual mode.
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <Tab> >>
noremap <S-Tab> <<

" Indent/unindent in visual mode without exiting.
vnoremap > >gv
vnoremap < <gv

" Press ( [ ' " < to wrap visual selection in pairs.
vnoremap ( c()<Esc>P
vnoremap [ c[]<Esc>P
vnoremap ' c''<Esc>P
vnoremap " c""<Esc>P

" Create new buffer with ^w n
noremap <C-w>n :new<Enter>

" Tabs
nnoremap <C-w><Tab> :tabn<CR>
nnoremap <C-w><S-Tab> :tabp<CR>
nnoremap <leader><Tab> :tabn<CR>
nnoremap <leader><S-Tab> :tabp<CR>
nnoremap <C-w>t :tabnew<CR>
for i in range(1, 9)
  " use <C-w>1 or <leader>1 to switch to tab 1
  execute 'nnoremap <C-w>' . i . ' ' . i . 'gt<CR>'
  execute 'nnoremap <leader>' . i . ' ' . i . 'gt<CR>'
endfor

" Merge this tab and next tab (tab merge).
if exists(':Tabmerge') | nnoremap <leader>tm :Tabmerge<CR> | endif

" Make this split into a new tab (tab split).
nnoremap <leader>ts <C-w>T
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>
nnoremap <leader>w :w<CR>
" Clear search highlight.
nnoremap <leader>? :nohlsearch<CR>
" Re-source vimrc.
nnoremap <leader>r :source ~/.vimrc<CR>

" <leader>ex to execute current file
nnoremap <leader>ex :!%:p<CR>

nnoremap <leader>spdb o__import__('pdb').set_trace()<CR><Esc>

vnoremap <leader>r y:%s/<C-R>*/
" C-f to replace visually selected text.
" See http://stackoverflow.com/a/15934899/2522725
vnoremap <C-f> y<ESC>/<C-r>"<CR>:%s//

nnoremap <leader>ggn :GitGutterNextHunk<CR>
nnoremap <leader>ggp :GitGutterPrevHunk<CR>

" <leader>c to copy to system clipboard.
if executable('pbcopy') | vnoremap <leader>c :w !pbcopy | endif

" Set fold levels.
for i in range(1, 9)
  execute 'nnoremap <leader>f' . i . ' :set foldlevel=' . i . '<CR>'
endfor

" By default C-q is 'unfreeze', so we tells the terminal to forward it to vim
" and map it to :qall instead.
" See http://stackoverflow.com/questions/7883803/why-doesnt-map-c-q-q-cr-work-in-vim
silent !stty -ixon 2>&1 > /dev/null
nnoremap <C-q> :qall<CR>

