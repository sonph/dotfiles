"""Python3 plugin to print custom tabline."""

# TODO(sonph): Clean up and convert into a neovim python plugin?

import os
import re
import vim

EXCLUDE = [
    'NERD_tree.*',
    '__Gundo.*',
    '__Tagbar.*',
    '\[denite\]'
]

MIN_TAB_TITLE_LENGTH = 20

DEBUG = False

def debug(s):
  if DEBUG:
    vim.command('echom "tabline.py: %s"' % s)

def get_current_terminal_size():
  return (int(vim.eval('&lines')), int(vim.eval('&columns')))

def get_tab(tabpage, tabpage_is_current):
  tab_parts = []

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

  # Padding
  tab_str = ''.join(tab_parts)
  padding_left, padding_right = calc_padding(len(tab_str), MIN_TAB_TITLE_LENGTH)
  return (tab_str, tabpage_is_current, padding_left, padding_right)

def calc_padding(len_tab_str, len_tab_size):
  padding_left = max((len_tab_size - len_tab_str) // 2, 1)
  padding_right = max(len_tab_size - len_tab_str - padding_left, 1)
  return (padding_left, padding_right)

def format_tabline(parts, mode, padding=0):
  line_parts = []
  line_parts.append(parts[0])
  tabs = parts[1]
  for tab in tabs:
    tabpage_is_current = tab[1]
    # With tab number.
    # prepend = ('%%#TabLine%s#%%%dT %d %%#TabLine%s#' %
    #     ('Sel' if tabpage_is_current else '', tabpage.number, tabpage.number, 'Sel' if tabpage_is_current else ''))
    prepend = ('%%#TabLine%s#%%T%%#TabLine%s#' %
        ('Sel' if tabpage_is_current else '', 'Sel' if tabpage_is_current else ''))
    if mode == 'full':
      padding_left, padding_right = tab[2], tab[3]
    elif mode == 'min':
      padding_left, padding_right = 0, 0
    else:
      padding_left = padding // 2
      padding_right = padding - padding_left
    line_parts.append(''.join([
      prepend,
      ' ' * padding_left,
      tab[0],
      ' ' * padding_right,
    ]))
  line_parts.append('%#TabLineFill#%T%=%#TabLineFill#%999X')
  line_parts.append('%#TablineSel#')
  line_parts.append(parts[2])
  return ''.join(line_parts)

def get_line():
  number_of_tabs = ' [%d] ' % len(vim.tabpages)

  tabs = []
  for tabpage in vim.tabpages:
    tabpage_is_current = (tabpage.number == vim.current.tabpage.number)
    tabs.append(get_tab(tabpage, tabpage_is_current))

  cwd = ' %s ' % os.path.basename(os.getcwd())

  tabline_size = get_current_terminal_size()[1]

  min_tabline = ''.join([
    number_of_tabs,
    ''.join(tab[0] for tab in tabs),
    cwd,
  ])
  if len(min_tabline) > tabline_size:
    return format_tabline([number_of_tabs, tabs, cwd], mode='min')

  full_tabline = ''.join([
    number_of_tabs,
    ''.join(tab[0] + ' ' * tab[2] + ' ' * tab[3] for tab in tabs),
    cwd,
  ])
  if len(full_tabline) <= tabline_size:
    return format_tabline([number_of_tabs, tabs, cwd], mode='full')

  padding = (tabline_size - len(min_tabline)) // len(tabs)
  return format_tabline([number_of_tabs, tabs, cwd], mode='tight', padding=padding)


tabline = get_line()
vim.command('let g:pytabline="%s"' % tabline)
