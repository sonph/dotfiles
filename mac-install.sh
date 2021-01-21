#!/bin/bash
# ------------------------------------------------
# Script to install additional stuffs on a clean Mac.
# ------------------------------------------------

DOTFILES_DIR="$HOME/code/dotfiles"

# Source functions for all the common cross platform stuff. Alternatively we can
# split those into a common file, but since this script won't be called as
# often, we'll just keep linux-install the main script and source it.
SOURCE_AS_LIBRARY='true'
source "$DOTFILES_DIR/linux-install.sh"

common_bin_exists 'brew' && brew update

function group_cli_install() {
  brew_install
  brew install \
      autoconf \
      automake \
      binutils \
      cmake \
      coreutils \
      ctags \
      curl \
      git \
      python \
      ruby \
      tmux \
      ttyrec \
      vim \
      wget \
      zsh
  dotfiles_install
}

# Use brew instead of apt-get on mac.
function common_install_pkg() {
  brew_install && brew install "$@"
}

function brew_install() {
  local url='https://brew.sh/'
  # test
  common_bin_exists 'brew' && return
  # install
  /usr/bin/ruby -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function neovim_install() {
  readonly local url='https://neovim.io/doc/'
  # test
  command -v nvim > /dev/null 2>&1 && return
  # deps
  brew_install
  # pip
  # install
  brew install neovim/neovim/neovim
  pip install neovim
  pip3 install neovim
}

function pylint_install() {
  pip23_install
  pip install pylint
}

# TODO: convert stuff from the Makefile.
if [ $# -eq 0 ]; then
  compgen -A function | grep -Ev '^(fail|info|ok)'
  exit 0
fi
"$@"
