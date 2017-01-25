let mapleader=' '
nnoremap ; :

noremap <C-c> <Esc>

" insert mode {
inoremap jj <ESC>                                     " bind jj and jk in INSERT mode to Esc
inoremap jk <ESC>

" ctrl+a/e to go to beginning/end of line in insert mode
inoremap <C-a> <C-o>^
" ctrl+o puts you in command mode for one key only
inoremap <C-e> <C-o>$
inoremap <C-f> <Right>
inoremap <C-b> <Left>
" }

" command mode {
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
" }

" visual mode {
" tab and shift-tab in visual mode to indent/unindent
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <Tab> >>
noremap <S-Tab> <<

" C-f to replace visually selected text
" See http://stackoverflow.com/a/15934899/2522725
vnoremap <C-f> y<ESC>/<C-r>"<CR>:%s//

" indent/unindent in visual mode without exiting
vnoremap > >gv
vnoremap < <gv

" press ( while visually selecting wraps the selection in ()
" same thing for [ ' " <
vnoremap ( c()<Esc>P
vnoremap [ c[]<Esc>P
vnoremap ' c''<Esc>P
vnoremap " c""<Esc>P
" }

" movement {
nnoremap j gj
nnoremap k gk
" }

" windows {
" create new buffer with ^w n
noremap <C-w>n :new<Enter>

" easy window navigation
" commented out because we use vim-tmux-navigator instead
" noremap <C-h> <C-w>h
" noremap <C-j> <C-w>j
" noremap <C-k> <C-w>k
" noremap <C-l> <C-w>l
" }

" tabs {
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

" Merge this tab and next tab (tab merge)
nnoremap <leader>tm :Tabmerge<CR>

" Make this split into a new tab (tab split)
nnoremap <leader>ts <C-w>T
" }

nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

nnoremap <leader>w :w<CR>

" clear search highlight
nmap <leader>? :nohlsearch<CR>

" resource vimrc
nmap <leader>r :source ~/.vimrc<CR>

if executable('pbcopy')
  vnoremap <leader>c :w !pbcopy
end

" set fold levels
for i in range(1, 9)
  execute 'nnoremap <leader>f' . i . ' :set foldlevel=' . i . '<CR>'
endfor

" <leader>ex to execute current file
nnoremap <leader>ex :!%:p<CR>

nnoremap <leader>spdb o__import__('pdb').set_trace()<CR><Esc>
vnoremap <leader>r y:%s/<C-R>*/

nnoremap <leader>ggn :GitGutterNextHunk<CR>
nnoremap <leader>ggp :GitGutterPrevHunk<CR>


" <C-q> is default 'unfreeze', so execute this command to allow <C-q> to reach vim via the terminal
" see http://stackoverflow.com/questions/7883803/why-doesnt-map-c-q-q-cr-work-in-vim
silent !stty -ixon 2>&1 > /dev/null
nnoremap <C-q> :qall<CR>

