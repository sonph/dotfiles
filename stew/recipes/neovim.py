from recipes import recipe
import sh
import os
import commands as c

# TODO:
# - change class name and file name
# - change desc, url, deps and skip_test
# - implement install() and test()

class Neovim(recipe.Recipe):
  def __init__(self):
    desc = 'Neovim and configs'
    url = 'https://neovim.io/doc/'
    deps = [
        'pip3',
    ]
    super().__init__(desc, url, deps, skip_test=False)

  def install(self):
    if not c.dir_exist(self.config.XDG_CONFIG_HOME):
      sh.mkdir('-p', self.config.XDG_CONFIG_HOME)
    sh.ln('-s', os.path.join(self.config.DOTFILES_DIR, 'home', 'vim'),
        os.path.join(self.config.XDG_CONFIG_HOME, '.nvim'))
    sh.sudo.pip3('install', 'neovim')

  def test(self):
    pass

