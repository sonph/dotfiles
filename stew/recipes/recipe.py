from typing import List
import importlib
import inspect
import logging
import os
import platform
import sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import sh

import config

class Recipe(object):
  """Base recipe class containing helper methods and props.

  User defined recipes should subclass this class, define properties, install()
  and test() methods. Create a new recipe by making a copy of the base.py file.
  """
  def __init__(self, desc:str, url:str, deps:List[str], skip_test:bool=False):
    """Create a recipe with metadata.

    The skip_test arg indicates whether we want to invoke the test() method or
    not. Simply implement a pass test() method won't work, as it doesn't
    indicate whether the recipe is installed or not."""
    self.desc = desc or 'Recipe template'
    self.url = url or ''
    self.deps = deps or []
    self.env = os.environ
    self.config = config.config
    self.sh = sh

    # Platform is either darwin or linux.
    system = platform.system().lower()
    if 'linux' in system:
      self.platform = 'linux'
    elif 'darwin' in system:
      self.platform = 'darwin'
    else:
      raise SystemError('Unknown platform: %s' % system)

    if (skip_test):
      logging.info('Installing dependencies: %s', ', '.join(self.deps))
      self.install_deps()
      logging.info('Installing recipe: %s', self.get_recipe_name())
      self.install()
    else:
      try:
        self.test()
        logging.info('Recipe %s already installed', self.get_recipe_name())
      except Exception:
        logging.info('Installing dependencies: %s', ', '.join(self.deps))
        self.install_deps()
        logging.info('Installing recipe: %s', self.get_recipe_name())
        self.install()
        self.test()

  def get_recipe_name(self) -> str:
    """Get current recipe name e.g. dotfiles, mac, nvim, etc.

    TODO: Figure out a less hacky way, use __name__ or __loader__ or something.
    """
    try:
      f = sys.modules[self.__class__.__module__].__file__
      return os.path.basename(f).split('.')[0]
    except Exception:
      return self.__class__.__name__

  def install_deps(self):
    """Install all dependencies listed in self.deps by finding the modules,
    create the Recipe subclass objects then invoke the install methods.
    """
    for recipe in self.deps:
      module = importlib.import_module('.'.join(['recipes', recipe]))
      classes = [obj for name, obj in inspect.getmembers(module)
          if inspect.isclass(obj)]
      if len(classes) != 1:
        raise RuntimeError(
            'Recipe %s should contain exactly one subclass of Recipe', recipe)
      for cls in classes:
        cls().install()

  def install(self):
    """Perform the actual install steps.

    We can import and reuse functions defined in commands.py.
    """
    raise NotImplementedError('Method is not defined.')

  def test(self):
    """Perform tests to (1) skip install if recipe is already installed, or (2)
    make sure recipe is actually installed.

    Raise an exception if the test does not pass.
    """
    raise NotImplementedError('Method is not defined.')



