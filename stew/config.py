import os

env = os.environ
join = os.path.join

config = {
  'DOTFILES_DIR': join(env['HOME'], '.files'),
  'XDG_CONFIG_HOME': join(env['HOME'], '.config'),
}

