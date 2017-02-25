from recipes import recipe
import sh

class Linux(recipe.Recipe):
  def __init__(self):
    desc = 'Essential linux recipes'
    url = ''
    deps = [
        'dotfiles',
    ]
    self.apt_pkgs = [

        ]
    super().__init__(desc, url, deps, skip_test=True)

  def install(self):
    pass
