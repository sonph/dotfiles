from recipes import recipe

class Dotfiles(recipe.Recipe):
  def __init__(self):
    desc = 'Personal dotfiles'
    url = 'https://github.com/sonph/dotfiles'
    deps = ['git']
    super().__init__(desc, url, deps)

  def install(self):
    pass

  def test(self):
    pass

