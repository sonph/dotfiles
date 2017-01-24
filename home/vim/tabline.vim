
" Tabline {
if exists("+showtabline")
" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
function! MyTabLine()
  let s = '  '
  let t = tabpagenr()
  let i = 1
  while i <= tabpagenr('$')
    let buflist = tabpagebuflist(i)
    let winnr = tabpagewinnr(i)
    let s .= '%' . i . 'T'
    let s .= (i == t ? '%1*' : '%2*')

    " let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
    " let s .= ' '
    let s .= (i == t ? '%#TabNumSel#' : '%#TabNum#')
    "let s .= ' ' . i . ' '
    let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')

    let bufnr = buflist[winnr - 1]
    let file = bufname(bufnr)
    let buftype = getbufvar(bufnr, '&buftype')

    if buftype == 'help'
      let file = 'help:' . fnamemodify(file, ':t:r')

    elseif buftype == 'quickfix'
      let file = 'quickfix'

    elseif buftype == 'nofile'
      if file =~ '\/.'
        let file = substitute(file, '.*\/\ze.', '', '')
      endif

    else
      let file = pathshorten(fnamemodify(file, ':p:~:.'))
      if getbufvar(bufnr, '&modified')
        let file = '+' . file
      endif

    endif

    if file == ''
      let file = '[No Name]'
    endif

    let s .= '  ' . file

    let nwins = tabpagewinnr(i, '$')
    if nwins > 1
      let modified = ''
      for b in buflist
        if getbufvar(b, '&modified') && b != bufnr
          let modified = '*'
          break
        endif
      endfor
      let hl = (i == t ? '%#WinNumSel#' : '%#WinNum#')
      let nohl = (i == t ? '%#TabLineSel#' : '%#TabLine#')
      "let s .= ' ' . modified . '(' . hl . winnr . nohl . '/' . nwins . ')'
      let s .= ' ' . modified . '(' . winnr . '/' . nwins . ')'
    endif

    let s .= '  '

    if i < tabpagenr('$')
      let s .= ' %#TabLine#  '
    else
      let s .= '  '
    endif

    let i = i + 1

  endwhile

  let s .= '%T%#TabLineFill#%='
  let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
  return s

endfunction
" set showtabline=1
"hi TabNum term=None cterm=None ctermfg=1 ctermbg=7 gui=None guibg=LightGrey
"hi TabNumSel term=None cterm=None ctermfg=1 ctermbg=7 gui=None
"hi WinNum term=None cterm=None ctermfg=11 ctermbg=7 guifg=DarkBlue guibg=LightGrey
"hi WinNumSel term=None cterm=None ctermfg=7 ctermbg=14 guifg=DarkBlue guibg=LightGrey
set tabline=%!MyTabLine()
endif " exists("+showtabline")
" }

