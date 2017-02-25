#!/usr/bin/env python3
import sys
import logging
import argparse
import inspect
import importlib

def install(recipe):
  """Install a recipe by finding the file and subclass, initialize and call the
  install() method.

  TODO: de-dup this and Recipe.install_deps()
  """
  module = importlib.import_module('.'.join(['recipes', recipe]))
  classes = [obj for name, obj in inspect.getmembers(module) if inspect.isclass(obj)]
  if len(classes) != 1:
    raise RuntimeError(
        'Recipe "%s" should contain exactly one subclass of Recipe, contains %d'
        % (recipe, len(classes)))
  for cls in classes:
    cls().install()

def main():
  parser = argparse.ArgumentParser(description='Stew')
  parser.add_argument('recipe', type=str, nargs='+', help='recipes to install')
  parser.add_argument('-v', '--verbose', action='store_true',
      help='verbose output')
  args = parser.parse_args()

  if args.verbose:
    logging.basicConfig(level=logging.INFO)

  for recipe in args.recipe:
    install(recipe)


if __name__ == '__main__':
  main()
