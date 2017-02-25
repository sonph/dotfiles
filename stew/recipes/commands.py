import logging
import os
import sys
import typing

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import sh

def git_clone(repo_url: str, dst: str=None, recursive: bool=True):
  if dst is None:
    # print(sh.git.clone(repo_url, recursive=recursive), _iter=True))
    pass
  else:
    # print(sh.git.clone(repo_url, dst, recursive=recursive), _iter=True)
    pass

