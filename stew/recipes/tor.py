from recipes import recipe
import sh

# TODO:
# - change class name and file name
# - change desc, url, deps and skip_test
# - implement install() and test()

class Template(recipe.Recipe):
  def __init__(self):
    desc = 'All Mac recipes'
    url = ''
    deps = [
    ]
    super().__init__(desc, url, deps, skip_test=False)

  def install(self):
    pass

  def test(self):
    pass

