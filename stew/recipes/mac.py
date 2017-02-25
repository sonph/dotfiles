from recipes import recipe
import logging

class Mac(recipe.Recipe):
  def __init__(self):
    desc = 'All Mac recipes'
    url = ''
    deps = [
        'dotfiles',
    ]
    super().__init__(desc, url, deps, skip_test=True)

  def install(self):
    pass

