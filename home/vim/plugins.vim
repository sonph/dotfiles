" TODO: switch to dein.vim (Shougo/dein.vim) and experiment with shallow copy
" or limited depth (max 200?) git cloning to save space.

" Vundle {
call vundle#begin()
  " Plugin formats: user/repo for GitHub
  "                 name for plugin from vim-scripts.org/vim/scripts.html
  "                 git://host/repo.git for repos not on github
  " Dependencies:
  "   vimproc: cd ~/.vim/bundle/vimproc && make
  "   YouCompleteMe: cd ~/.vim/bundle/YouCompleteMe && ./install.py
  "   ctags: brew install ctags or apt-get install ctags
  "   ack: make ack in dotfiles/bin/ack available in the path
  Plugin 'VundleVim/Vundle.vim'

  " Colorschemes.
  Plugin 'daylerees/colour-schemes', {'rtp': 'vim/'}
  Plugin 'altercation/vim-colors-solarized'
  Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
  Plugin 'sonph/onehalf', {'rtp': 'vim/'}

  " Status bar.
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'

  Plugin 'vim-scripts/Tabmerge'

  " Navigation.
  Plugin 'christoomey/vim-tmux-navigator'
  Plugin 'scrooloose/nerdtree'
  " Plugin 'jistr/vim-nerdtree-tabs'              " Sync nerdtrees between tabs.
  Plugin 'airblade/vim-gitgutter'
  Plugin 'luochen1990/rainbow'                    " Different colors for parentheses at different nested levels.
  if executable('ctags')
    Plugin 'majutsushi/tagbar'
  endif
  Plugin 'kshenoy/vim-signature'
  Plugin 'rargo/vim-tab'
  Plugin 'easymotion/vim-easymotion'

  " Search & autocomplete.
  " Plugin 'ctrlpvim/ctrlp.vim'
  if has("nvim")
    " Denite requires neovim or vim8 with python3 support (echo has("python3") == 1).
    " Install python3 dep: apt-get install python3-pip && pip3 install neovim && nvim -c \":UpdateRemotePlugins\"
    " Or `brew install python3` for macOS.
    Plugin 'Shougo/denite.nvim'
  else
    Plugin 'Shougo/unite.vim'
    Plugin 'Shougo/neomru.vim'                    " Most recently used files source (file_mru) for Unite.
    Plugin 'Shougo/vimproc.vim'                   " Async indexing (file_rec/async) for Unite.
  endif

  Plugin 'Valloric/YouCompleteMe'
  " Fix YCM load errors due to Python:
  " https://github.com/Valloric/YouCompleteMe/issues/18
  " https://github.com/Valloric/YouCompleteMe/issues/1605
  if executable('ack-grep')                       " Ack code search; better version of grep.
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
    Plugin 'mileszs/ack.vim'
  elseif executable('ack')
    Plugin 'mileszs/ack.vim'
  endif

  " Editing.
  Plugin 'sjl/gundo.vim'
  Plugin 'mattn/emmet-vim'
  Plugin 'terryma/vim-multiple-cursors'           " Sublime text style multiple cursors.
  Plugin 'sonph/auto-pairs'                       " Fork of auto-pairs.
  Plugin 'scrooloose/nerdcommenter'               " For comments.

" All vundle plugins must be before this line.
call vundle#end()
" }

" Plugin settings {

" vim-airline
let g:airline_theme='onehalfdark'                 " for other built in themes see
                                                  "   https://github.com/vim-airline/vim-airline/wiki/Screenshots
set laststatus=2                                  " load airline even on a single split
set noshowmode                                    " disable default mode indicator, use airline's instead
let g:airline_inactive_collapse=1
let g:airline#extensions#tabline#fnamemod=':p:.'
let g:airline#extensions#tabline#fnamecollapse=1
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='|'
let g:airline_left_sep=''
let g:airline_right_sep=''


" NERDTree
nmap <leader>nt :NERDTreeToggle<CR>                     " ^w 0 to focus the nerdtree sidebar (like sublime)
"let NERDTreeShowHidden=1                          " show hidden dot files
"if has('autocmd')
"  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"                                                  " automatically close vim if the only tab open is nerdtree
"  autocmd StdinReadPre * let s:std_in=1           " open nerdtree automatically if no file is specified
"  autocmd VimEnter * if (argc() == 0 && !exists("s:std_in")) | NERDTree | wincmd l | endif
"endif


" Tagbar
nmap <leader>tb :TagbarToggle<CR>


" Rainbow
" let g:rainbow_active = 1                          " enable by default (can also use :RainbowToggle)
" change ctermfgs to set colors; original colors are bright
let g:rainbow_conf = {
    \   'guifgs': ['black', 'blue', 'red', 'green'],
    \   'ctermfgs': ['black', 'blue', 'red', 'green'],
    \}


" Vim-signature
" change the bookmark color to indicate git-gutter state
let g:SignatureMarkTextHLDynamic=1

" for some reason the bookmarks don't immediately appear, call SignatureRefresh
let bookmark_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
let i = 0
while i < len(bookmark_keys)
  execute 'nnoremap m' . bookmark_keys[i] . ' :mark ' . bookmark_keys[i]. ' \| SignatureRefresh<CR>'
  let i = i + 1
endwhile

nnoremap m/ :SignatureListMarks<CR>
nnoremap m<Space> call signature#mark#Purge('all')


" vim-tab
let g:TabTrigger = []


" Unite & Denite
if has("nvim") && has("python3")
  " TODO: use -no-split when it becomes available.
  " TODO: enable & test for vim8.
  " if v:version >= 800
  nnoremap <leader>p :Denite file_rec buffer<CR>
  nnoremap <leader>P :Denite menu:user_commands command<CR>
  vnoremap <leader>P :Denite menu:user_commands command<CR>
  nnoremap <leader>/ :Denite line<CR>

  let s:menus = {}
  let s:menus.user_commands = {
        \ 'description': 'User commands'
        \ }
  let s:menus.user_commands.command_candidates = [
        \ ['Build: Run file (_ex)', ':!%:p'],
        \ ['Indentation: Convert tabs to spaces', 'retab'],
        \ ['Indentation: 2 spaces soft tab', 'set expandtab tabstop=2 softtabstop=2 shiftwidth=2'],
        \ ['Indentation: 4 spaces soft tab', 'set expandtab tabstop=4 softtabstop=4 shiftwidth=4'],
        \ ['Indentation: 2-space hard tabs', 'set noexpandtab tabstop=2 softtabstop=2 shiftwidth=2'],
        \ ['Indentation: 4-space hard tabs', 'set noexpandtab tabstop=4 softtabstop=4 shiftwidth=4'],
        \ ['Misc: Shell', 'shell'],
        \ ['Nav: Next git hunk (_ggn)', 'GitGutterNextHunk'],
        \ ['Nav: Previous git hunk (_ggp)', 'GitGutterPrevHunk'],
        \ ['Preferences: Edit vimrc configs', 'Denite menu:vimrc'],
        \ ['Preferences: Keymap', 'new ~/.vim/keymap.vim'],
        \ ['Preferences: Plugins', 'new ~/.vim/plugins.vim'],
        \ ['Preferences: Reload init.vim (_r)', 'source ~/.vim/init.vim'],
        \ ['Preferences: Settings init.vim', 'new ~/.vim/init.vim'],
        \ ['Preferences: User commands', 'new ~/.vim/commands.vim'],
        \ ['Tabs: Merge (_tm)', 'Tabmerge'],
        \ ['Tabs: New (<C-w>t)', 'tabnew'],
        \ ['Tabs: Split (_ts <C-w>T)', 'call feedkeys("\<C-w>T")'],
        \ ['Tabs: Resize equal (<C-w>=)', 'call feedkeys("\<C-w>=")'],
        \ ['View: Toggle relative line number', 'set relativenumber!'],
        \ ['View: Toggle word wrap', 'set wrap!'],
        \ ['View: Fold level 0 (_f0)', 'set foldlevel=0'],
        \ ['View: Fold level 3 (_f3)', 'set foldlevel=3'],
        \ ['View: Fold level 6 (_f6)', 'set foldlevel=6'],
        \ ['View: Fold level 9 (_f9)', 'set foldlevel=9'],
        \ ['View: No fold', 'set foldlevel=99'],
        \ ['View: Hex (readonly)', 'set readonly | setlocal binary | %!xxd'],
        \ ['View: Hex (disable)', 'set noreadonly | setlocal nobinary | %!xxd -r'],
        \ ['View: Toggle Nerdtree (_nt)', 'NERDTreeToggle'],
        \ ['View: Toggle Tagbar (_tb)', 'TagbarToggle'],
        \ ['Visual: Apply line-macro <a> to selection (norm! @a)', 'norm! @a'],
        \ ['Visual: Copy to system clipboard (_c)', 'w !pbcopy'],
        \ ['Visual: Replace <C-f>', 'call feedkeys("\<C-f>")'],
        \ ]
  let s:menus.vimrc = {
        \ 'description': 'Vim config files'
        \ }
  let s:menus.vimrc.file_candidates = [
        \ ['commands.vim', '~/.vim/commands.vim'],
        \ ['google.vim', '~/.vim/google.vim'],
        \ ['init.vim', '~/.vim/init.vim'],
        \ ['keymap.vim', '~/.vim/keymap.vim'],
        \ ['neovim.vim', '~/.vim/neovim.vim'],
        \ ['plugins.vim', '~/.vim/plugins.vim'],
        \ ]
  call denite#custom#var('menu', 'menus', s:menus)

  call denite#custom#option('default', 'prompt', 'λ:')

  " If we're in a git repo, use `git ls-files`. See doc for example.
  " git ls-files ignores files in .gitignore, symlinks, etc.
  call denite#custom#alias('source', 'file_rec/git', 'file_rec')
  call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])
  nnoremap <leader>p :Denite `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'` buffer<CR>

  " Key mappings.
  call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')
  call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
  call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
  call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
  call denite#custom#map('insert', '<C-a>', '<denite:move_caret_to_head>', 'noremap')
  call denite#custom#map('insert', '<C-e>', '<denite:move_caret_to_tail>', 'noremap')
  call denite#custom#map('insert', '<C-b>', '<denite:move_caret_to_left>', 'noremap')
  call denite#custom#map('insert', '<C-f>', '<denite:move_caret_to_right>', 'noremap')

  " Highlight groups.
  hi! link deniteMatchedChar Constant
else
  nnoremap <leader>p :Unite -start-insert -no-split -smartcase file_rec/async<CR>
  nnoremap <leader>P :Unite -start-insert -no-split -smartcase command<CR>
  vnoremap <leader>P :Unite -start-insert -no-split -smartcase command<CR>
  nnoremap <leader>/ :Unite -start-insert -no-split -smartcase line<CR>

  " the default command is find -L, which follows symbolic links
  let g:unite_source_rec_async_command = ['find']

  " call unite#filters#matcher_default#use(['matcher_fuzzy'])
  autocmd FileType unite call s:unite_user_settings()
  function! s:unite_user_settings()"{{{
    nmap <buffer> <leader>p <Plug>(unite_exit)
    nmap <buffer> <leader>q <Plug>(unite_exit)
    nmap <buffer> <Esc> <Plug>(unite_exit)
    nmap <buffer> <C-c> <Plug>(unite_exit)
  endfunction"}}}

  let g:multi_cursor_quit_key='<C-c>'
  "nnoremap <leader>m :call multiple_cursors#quit()<CR>
  "nnoremap <leader>c :call multiple_cursors#quit()<CR>
  let g:multi_cursor_exit_from_insert_mode=0
endif


" Gundo
nnoremap <leader>gd :GundoToggle<CR>
" for configuration options, see http://sjl.bitbucket.org/gundo.vim/
" open gundo on the right side instead of the left
let g:gundo_right=1
" automatically close gundo on reverting
let g:gundo_close_on_revert=1


" Emmet
" enable only for html/css
let g:user_emmet_install_global=0
autocmd FileType html,css EmmetInstall
" use <Tab> to trigger expanding abbreviation
let g:user_emmet_expandabbr_key='<Tab>'
" }


" NERDCommenter
" Add an extra space after the comment sign.
let NERDSpaceDelims=1
