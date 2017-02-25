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
  def __init__(self, desc:str, url:str, deps:List[str], skip_test:bool=False):
    """Create a recipe with metadata."""
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
    """Install all dependencies by finding the module, create the Recipe subclass
    object then invoke the install method.
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
    """
    raise NotImplementedError('Method is not defined.')

  def test(self):
    """Perform tests to (1) skip install if recipe is already installed, or (2)
    make sure recipe is actually installed.

    Raise an exception if the test does not pass.
    """
    raise NotImplementedError('Method is not defined.')



