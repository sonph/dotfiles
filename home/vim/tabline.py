"""Python3 plugin to print custom tabline."""

# TODO(sonph): Clean up and convert into a python plugin.

import os
import re
import vim

EXCLUDE = [
    'NERD_tree.*',
    '__Gundo.*',
    '__Tagbar.*',
]

MIN_TAB_TITLE_LENGTH = 25

DEBUG = False

def debug(s):
  if DEBUG:
    vim.command('echom "tabline.py: %s"' % s)

def get_tab(tabpage):
  tab_parts = []
  tabpage_is_current = (tabpage.number == vim.current.tabpage.number)

  # File names.
  fnames = []
  for window in tabpage.windows:
    window_is_current = tabpage_is_current and (window.number == vim.current.window.number)
    fname = os.path.basename(window.buffer.name)
    for pattern in EXCLUDE:
      if re.match(pattern, fname):
        break
    else:
      fname_parts = []
      fname_parts.append('[' if window_is_current else ' ')

      fname_buf_type = vim.call('getbufvar', window.buffer, '&buftype')
      if fname_buf_type == 'help':
        fname_parts.append('H:%s' % fname.split('.')[0])
      elif fname_buf_type == 'quickfix':
        fname_parts.append('Q')
      else:
        fname_parts.append(fname if fname else 'new')
        if vim.call('getbufvar', window.buffer, '&modified'):
          fname_parts.append('*')

      fname_parts.append(']' if window_is_current else ' ')
      fnames.append(''.join(fname_parts))
  tab_parts.append(''.join(fnames))

  # With tab number.
  # prepend = ('%%#TabLine%s#%%%dT %d %%#TabLine%s#' %
  #     ('Sel' if tabpage_is_current else '', tabpage.number, tabpage.number, 'Sel' if tabpage_is_current else ''))
  prepend = ('%%#TabLine%s#%%T%%#TabLine%s#' %
      ('Sel' if tabpage_is_current else '', 'Sel' if tabpage_is_current else ''))

  # Padding
  tab_str = ''.join(tab_parts)
  padding_left = max((MIN_TAB_TITLE_LENGTH - len(tab_str)) // 2, 1)
  padding_right = max(MIN_TAB_TITLE_LENGTH - len(tab_str) - padding_left, 1)
  return '%s%s%s%s' % (prepend, ' ' * padding_left, tab_str, ' ' * padding_right)

def get_line():
  line_parts = []
  line_parts.append(' [%s] ' % str(len(vim.tabpages)))
  for tab in vim.tabpages:
    line_parts.append(get_tab(tab))
  line_parts.append('%#TabLineFill#%T%=%#TabLineFill#%999X')
  line_parts.append('%%#TablineSel# %s ' % os.path.basename(os.getcwd()))
  return ''.join(line_parts)

tabline = get_line()
vim.command('let g:pytabline="%s"' % tabline)
