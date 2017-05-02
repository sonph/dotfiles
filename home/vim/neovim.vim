" True colors support
set termguicolors

if has('nvim-0.2.0')
  " guicursor is enabled by default only if Nvim is certain it won't cause
  " problems on the terminal. Uncomment the below line to force.
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
  " or uncomment this line to disable.
  " set guicursor=
else
  " For nvim 0.1.7 and older.
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif

" Show the effects of a command incrementally, as you type, such as :s.
set inccommand=nosplit
