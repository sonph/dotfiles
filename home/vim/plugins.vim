" TODO: experiment with shallow copy or limited depth (max 200?) git cloning to save space.

" Dein.vim {
if dein#load_state('~/.vim/bundle')
  call dein#begin('~/.vim/bundle')
  " Plugin formats: user/repo for GitHub
  "                 name for plugin from vim-scripts.org/vim/scripts.html
  "                 git://host/repo.git for repos not on github
  " Dependencies:
  "   vimproc (does not apply for neovim/dein):
  "     cd ~/.vim/bundle/repos/github.com/Shougo/vimproc && make
  "   YouCompleteMe:
  "     cd ~/.vim/bundle/repos/github.com/Valloric/YouCompleteMe && ./install.py
  "   ctags: brew install ctags or apt-get install ctags
  "   ack: make ack in dotfiles/bin/ack available in the path

  " Colorschemes.
  call dein#add('daylerees/colour-schemes', {'rtp': 'vim/'})
  call dein#add('altercation/vim-colors-solarized')
  call dein#add('chriskempson/tomorrow-theme', {'rtp': 'vim/'})
  call dein#add('sonph/onehalf', {'rtp': 'vim/'})

  " Status bar.
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('vim-scripts/Tabmerge')
  call dein#add('hecal3/vim-leader-guide')

  " Navigation.
  call dein#add('christoomey/vim-tmux-navigator')
  call dein#add('scrooloose/nerdtree')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')
  call dein#add('luochen1990/rainbow')
  if executable('ctags')
    call dein#add('majutsushi/tagbar')
  endif
  call dein#add('kshenoy/vim-signature')
  call dein#add('rargo/vim-tab')
  call dein#add('easymotion/vim-easymotion')
  " Vim sugar for the UNIX shell commands e.g. Remove, Rename, Mkdir, SudoWrite, etc.
  call dein#add('tpope/vim-eunuch')

  " Search & autocomplete.
  if has("nvim")
    " Denite requires neovim or vim8 with python3 support (echo has("python3") == 1).
    " Install python3 dep:
    " brew install python3 && pip3 install neovim && nvim -c \":UpdateRemotePlugins\"
    " apt-get install python3-pip && pip3 install neovim && nvim -c \":UpdateRemotePlugins\"
    call dein#add('Shougo/denite.nvim')
  else
    call dein#add('Shougo/unite.vim')
    " Most recently used file source (file_mru for Unite).
    call dein#add('Shougo/neomru.vim')
    " Async stuffs (enable file_rec/async for Unite).
    call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  endif

  call dein#add('Valloric/YouCompleteMe', {'build': './install.py'})
  " Fix YCM load errors due to Python:
  " https://github.com/Valloric/YouCompleteMe/issues/18
  " https://github.com/Valloric/YouCompleteMe/issues/1605
  if executable('ack-grep')             " Ack code search; better version of grep.
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
    call dein#add('mileszs/ack.vim')
  elseif executable('ack')
    call dein#add('mileszs/ack.vim')
  endif

  " Editing.
  call dein#add('sjl/gundo.vim')
  call dein#add('mattn/emmet-vim', {'on_ft': ['html', 'xml', 'css']})
  " Sublime text style multiple cursors.
  call dein#add('terryma/vim-multiple-cursors')
  " Fork of auto pairs (auto closing parentheses).
  call dein#add('sonph/auto-pairs')
  call dein#add('scrooloose/nerdcommenter')

  call dein#end()
  call dein#save_state()
endif
" }


function! s:maybe_add_denite_item(name, cmd)
  if exists('s:menus')
    call add(s:menus.user_commands.command_candidates, [a:name, a:cmd])
  endif
endfunction

function! s:maybe_add_leader_guide_item(key, name, cmd)
  if exists('g:lmap')
    execute 'let g:lmap' . a:key . ' = '
          \ . '[' . shellescape(a:cmd) . ',' . shellescape(a:name) . ']'
  endif
endfunction

function! s:leader_bind(map, key, key2, key3, value, denite_name, guide_name, is_cmd)
  " leader_bind('nnoremap', 'g', 'b', '', 'Gblame', 'Git: Blame', 'blame', 1)
  " leader_bind('nnoremap', 'g', 'g', 'n', 'GitGutterNextHunk', 'Git: Next Hunk', 'next-hunk', 1)
  if a:is_cmd
    " If a:value is a complete command e.g. :Gblame<CR>
    let l:value = ':' . a:value . '<CR>'
    let l:denite_name = a:denite_name . ' (_' . a:key . a:key2 . a:key3 . ')'
    let l:denite_cmd = a:value
    let l:guide_name = a:guide_name
  else
    " If a:value is not a complete command e.g. :Gmove<Space> that needs the
    " user to finish the command, we'll append (nop) to indicate that
    " selecting the menu item either in denite or leader-guide does nothing,
    " because incomplete commands are not supported.
    " a:value in this case should contain a leading ':' and trailing '<Space>'.
    " TODO: figure out a way to use incomplete commands.
    let l:value = a:value
    let l:denite_name = a:denite_name . ' (_' . a:key . a:key2 . ') (nop)'
    let l:denite_cmd = ''
    let l:guide_name = a:guide_name . ' (nop)'
  endif
  execute a:map . ' <leader>' . a:key . a:key2 . a:key3 . ' ' . l:value
  call s:maybe_add_denite_item(l:denite_name, l:denite_cmd)
  if strlen(a:key3)
    let l:key = '[' . shellescape(a:key) . ']'
          \ . '[' . shellescape(a:key2) . ']'
          \ . '[' . shellescape(a:key3) . ']'
  else
    if strlen(a:key2)
      let l:key = '[' . shellescape(a:key) . ']'
            \ . '[' . shellescape(a:key2) . ']'
    else
      let l:key = '[' . shellescape(a:key) . ']'
    endif
  endif
  call s:maybe_add_leader_guide_item(l:key, l:guide_name, l:denite_cmd)
endfunction

function! s:denite_add_user_command(item, cmd)
  call add(s:menus.user_commands.command_candidates, [a:item, a:cmd])
endfunction


" Plugin settings {

" hecal3/vim-leader-guide
" function! s:vim_leader_guide_setup()
let g:lmap = {}
let g:leaderGuide_vertical = 1
let g:leaderGuide_position = 'botright'
let g:leaderGuide_max_size = 30

call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
" endfunction
" call dein#set_hook('vim-leader-guide', 'hook_add', function('s:vim_leader_guide_setup'))


" Unite & Denite
if has("python3")
  " TODO: use -no-split when it becomes available.
  " TODO: enable & test for vim8.
  " if v:version >= 800

  let s:menus = {}
  let s:menus.user_commands = {
        \ 'description': 'User commands'
        \ }
  let s:menus.user_commands.command_candidates = [
        \ ['Build: Run file (_ex)', ':!%:p'],
        \ ['Colorscheme: One Half Dark', 'colorscheme onehalfdark | let g:airline_theme=' . shellescape('onehalfdark')],
        \ ['Colorscheme: One Half Light', 'colorscheme onehalflight | let g:airline_theme=' . shellescape('onehalfdark')],
        \ ['Edit: Remove trailing whitespaces', '%s/\s\+$//e'],
        \ ['Indentation: 2 spaces soft tab', 'set expandtab tabstop=2 softtabstop=2 shiftwidth=2'],
        \ ['Indentation: 2-space hard tabs', 'set noexpandtab tabstop=2 softtabstop=2 shiftwidth=2'],
        \ ['Indentation: 4 spaces soft tab', 'set expandtab tabstop=4 softtabstop=4 shiftwidth=4'],
        \ ['Indentation: 4-space hard tabs', 'set noexpandtab tabstop=4 softtabstop=4 shiftwidth=4'],
        \ ['Indentation: Convert tabs to spaces', 'retab'],
        \ ['Indentation: Toggle paste mode', 'set paste!'],
        \ ['Nav: Clear vim-signature bookmarks (m_)', 'call signature#mark#Purge(' . shellescape('all') . ')'],
        \ ['Nav: Show vim-signature bookmarks (m/)', 'SignatureListBufferMarks'],
        \ ['Plugins: Git garbage collect (git gc)', 'call dein#each(' . shellescape('git gc') . ')'],
        \ ['Plugins: Load remote plugins (neovim only)', 'call dein#remote_plugins()'],
        \ ['Plugins: Update', 'call dein#update()'],
        \ ['Tabs: New (<C-w>t)', 'tabnew'],
        \ ['Tabs: Resize equal (<C-w>=)', 'wincmd ='],
        \ ['View: Fold level 0 (_f0)', 'set foldlevel=0'],
        \ ['View: Fold level 3 (_f3)', 'set foldlevel=3'],
        \ ['View: Fold level 6 (_f6)', 'set foldlevel=6'],
        \ ['View: Fold level 9 (_f9)', 'set foldlevel=9'],
        \ ['View: Hex (disable)', 'set noreadonly | setlocal nobinary | %!xxd -r'],
        \ ['View: Hex (readonly)', 'set readonly | setlocal binary | %!xxd'],
        \ ['View: No fold', 'set foldlevel=99'],
        \ ['View: Plain text filetype', 'set syntax=off filetype=plaintext'],
        \ ['View: Toggle rainbow parentheses', 'RainbowToggle'],
        \ ['View: Toggle relative line number', 'set relativenumber!'],
        \ ['View: Toggle spellcheck', 'set spell!'],
        \ ['View: Toggle word wrap', 'set wrap!'],
        \ ['Vim: Edit vimrc configs', 'Denite menu:vimrc'],
        \ ['Vim: Keymap', 'new ~/.vim/keymap.vim'],
        \ ['Vim: Plugins', 'new ~/.vim/plugins.vim'],
        \ ['Vim: Settings init.vim', 'new ~/.vim/init.vim'],
        \ ['Vim: Shell terminal', 'terminal'],
        \ ['Visual: Apply line-macro <a> to selection (norm! @a)', 'norm! @a'],
        \ ]
  let s:menus.vimrc = {
        \ 'description': 'Vim config files'
        \ }
  let s:menus.vimrc.file_candidates = [
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
  let g:lmap.p = ['', 'finder-file (nop) (_p)']
  call s:leader_bind('nnoremap', 'P', '', '',
        \ 'Denite menu:user_commands command', 'Finder: Commands', 'finder-command', 1)
  vnoremap <leader>P :Denite menu:user_commands command<CR>
  call s:leader_bind('nnoremap', '/', '', '',
        \ 'Denite line', 'Finder: Line', 'finder-line', 1)

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


" sonph/onehalf
colorscheme onehalflight


" vim-airline/vim-airline
let g:airline_theme='onehalfdark'       " For other built in themes see
                                        "   https://github.com/vim-airline/vim-airline/wiki/Screenshots
set laststatus=2                        " Load airline even on a single split.
set noshowmode                          " Disable vim's default mode indicator.
let g:airline_inactive_collapse=1
let g:airline#extensions#tabline#fnamemod=':p:.'
let g:airline#extensions#tabline#fnamecollapse=1
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='|'
let g:airline_left_sep=''
let g:airline_right_sep=''


" View layer {
let g:lmap.v = {'name': 'View/'}

" scrooloose/nerdtree
" <C-w>0 to focus nerdtree (like sublime)
nnoremap <C-w>0 :NERDTreeFocus
call s:leader_bind('nnoremap', 'v', 'n', '', 'NERDTreeToggle', 'View: Nerdtree', 'nerdtree', 1)


" majutsushi/tagbar
call s:leader_bind('nnoremap', 'v', 't', '', 'TagbarToggle', 'View: Tagbar', 'tagbar', 1)


" sjl/gundo.vim
call s:leader_bind('nnoremap', 'v', 'g', '', 'GundoToggle', 'View: Gundo', 'gundo', 1)
" open gundo on the right side instead of the left
let g:gundo_right=1
" automatically close gundo on reverting
let g:gundo_close_on_revert=1
" }


" Rainbow
" Change ctermfgs to set colors; original colors are bright.
let g:rainbow_conf = {
    \   'guifgs': ['black', 'blue', 'red', 'green'],
    \   'ctermfgs': ['black', 'blue', 'red', 'green'],
    \}


" Vim-signature
let g:lmap.m = {'name': 'Bookmarks/'}
" Change the bookmark color to indicate git-gutter state (since we only have
" one column for both bookmarks and git-gutter indicators).
let g:SignatureMarkTextHLDynamic=1

" for some reason the bookmarks don't immediately appear, call SignatureRefresh
let bookmark_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
let i = 0
while i < len(bookmark_keys)
  execute 'nnoremap m' . bookmark_keys[i] . ' :mark ' . bookmark_keys[i]. ' \| SignatureRefresh<CR>'
  let i = i + 1
endwhile
" List all bookmarks.
nnoremap m/ :SignatureListBufferMarks<CR>
" Remove all bookmarks.
nnoremap m<Space> call signature#mark#Purge('all')


" vim-tab
let g:TabTrigger = []


" Emmet
" enable only for html/css
let g:user_emmet_install_global=0
autocmd FileType html,css EmmetInstall
" use <Tab> to trigger expanding abbreviation
let g:user_emmet_expandabbr_key='<Tab>'


" NERDCommenter
" Add an extra space after the comment sign.
let NERDSpaceDelims=1


" Git layer {
" tpope/vim-fugitive
let g:lmap.g = {'name': 'Git/'}
call s:leader_bind('nnoremap', 'g', 'b', '', 'Gblame', 'Git: Blame', 'blame', 1)
call s:leader_bind('nnoremap', 'g', 'B', '', 'Gbrowse', 'Git: Status', 'status', 1)
call s:leader_bind('nnoremap', 'g', 'c', '', ':Gcommit<Space>', 'Git: Commit', 'commit', 0)
call s:leader_bind('nnoremap', 'g', 'C', '', 'Gcheckout', 'Git: Checkout', 'checkout', 1)
call s:leader_bind('nnoremap', 'g', 'D', '', 'Gdiff HEAD', 'Git: Diff HEAD', 'diff HEAD', 1)
call s:leader_bind('nnoremap', 'g', 'd', '', 'Gdiff', 'Git: Diff', 'diff', 1)
call s:leader_bind('nnoremap', 'g', 'm', '', ':Gmove<Space>', 'Git: Move', 'move', 0)
call s:leader_bind('nnoremap', 'g', 'p', '', 'Gpull', 'Git: Pull', 'pull', 1)
call s:leader_bind('nnoremap', 'g', 'P', '', 'Gpush', 'Git: Push', 'push', 1)
call s:leader_bind('nnoremap', 'g', 'r', '', 'Gread', 'Git: Checkout current file', 'checkout-current-file', 1)
call s:leader_bind('nnoremap', 'g', 's', '', 'Gstatus', 'Git: Status', 'status', 1)


" airblade/vim-gitgutter
let g:lmap.g.g = {'name': 'Gutter/'}
call s:leader_bind('nnoremap', 'g', 'g', 'n', 'GitGutterNextHunk', 'Git: Next Hunk', 'next-hunk', 1)
call s:leader_bind('nnoremap', 'g', 'g', 'p', 'GitGutterPrevHunk', 'Git: Prev Hunk', 'prev-hunk', 1)
call s:leader_bind('nnoremap', 'g', 'g', 'S', 'GitGutterStageHunk', 'Git: Stage Hunk', 'stage-hunk', 1)
call s:leader_bind('nnoremap', 'g', 'g', 'R', 'GitGutterRevertHunk', 'Git: Revert Hunk', 'revert-hunk', 1)
call s:leader_bind('nnoremap', 'g', 'g', 't', 'GitGutterSignsToggle', 'Git: Toggle Gutter', 'toggle-gutter', 1)
" }


" Leader key mappings {

" Wrap visual selection in parentheses/quotes.
call s:leader_bind('vnoremap', '(', '', '', 'c()<Esc>P', 'Visual: Wrap ()', 'wrap-()', 0)
call s:leader_bind('vnoremap', '[', '', '', 'c[]<Esc>P', 'Visual: Wrap []', 'wrap-[]', 0)
" TODO: figure out how to escape a single quote.
vnoremap <leader>' c''<Esc>P
call s:maybe_add_denite_item('Visual: Wrap ' . shellescape('') . '(nop)', '')
call s:leader_bind('vnoremap', '"', '', '', 'c""<Esc>P', 'Visual: Wrap ""', 'wrap-""', 0)
call s:leader_bind('vnoremap', '<', '', '', 'c<><Esc>P', 'Visual: Wrap <>', 'wrap-<>', 0)

" Tabs.
" call s:leader_bind(map, key, key2, key3, value, denite_name, guide_name, is_cmd)
call s:leader_bind('nnoremap', '<Tab>', '', '', 'tabn', 'Tab: Next', 'tab-next', 1)
call s:leader_bind('nnoremap', '<S-Tab>', '', '', 'tabp', 'Tab: Prev', 'tab-prev', 1)
for i in range(1, 9)
  execute 'nnoremap <leader>' . i . ' ' . i . 'gt<CR>'
endfor
" Merge this tab and next tab.
let g:lmap.t = {'name': 'Tab/'}
if exists(':Tabmerge')
  call s:leader_bind('nnoremap', 't', 'm', '', 'Tabmerge', 'Tabs: Merge with next tab', 'tab-merge-next', 1)
endif
" Make this split into a new tab.
call s:leader_bind('nnoremap', 't', 's', '', 'wincmd T', 'Tabs: Split into tab', 'tab-split', 1)

call s:leader_bind('nnoremap', 'q', '', '', 'q', 'Vim: Quit', 'quit', 1)
call s:leader_bind('nnoremap', 'Q', '', '', 'q!', 'Vim: Quit unsaved', 'quit-unsaved', 1)
call s:leader_bind('nnoremap', 'w', '', '', 'w', 'File: Write', 'file-write', 1)

" Clear search highlight.
call s:leader_bind('nnoremap', '?', '', '', 'nohlsearch', 'Visual: Clear search highlight', 'nohlsearch', 1)
call s:leader_bind('nnoremap', 'r', '', '', 'source ~/.vim/init.vim', 'Vim: Re-source init.vim', 'resource-init.vim', 1)

" Execute current file.
call s:leader_bind('nnoremap', 'x', '', '', '!%:p', 'File: Execute', 'file-execute', 1)

" C-f to replace visually selected text.
" See http://stackoverflow.com/a/15934899/2522725
vnoremap <leader>r y<ESC>/<C-r>"<CR>:%s//
call s:maybe_add_denite_item('Visual: Replace selection (_r) (nop)', '')
call s:maybe_add_leader_guide_item('r', 'v-selection-replace (nop)', '')
" TODO: resolve message on startup when we issue the following function call
" call s:leader_bind('vnoremap', 'r', '', '', '', 'Visual: Replace selection', 'v-selection-replace', 0)

" <leader>c to copy to system clipboard.
if executable('pbcopy')
  call s:leader_bind('vnoremap', 'c', '', '', 'w !pbcopy', 'Visual: Copy to system clipboard', 'v-selection-pbcopy', 1)
endif

" Set fold level.
for i in range(1, 9)
  execute 'nnoremap <leader>f' . i . ' :set foldlevel=' . i . '<CR>'
endfor

" }

" Sort Denite user commands.
if exists('s:menus')
  call sort(s:menus.user_commands.command_candidates, 'i')
endif
