#!/bin/bash
# ------------------------------------------------
# Script to install additional stuffs on a clean Mac.
# ------------------------------------------------

DOTFILES_DIR="$HOME/.files"

# Source functions for all the common cross platform stuff. Alternatively we can
# split those into a common file, but since this script won't be called as
# often, we'll just keep linux-install the main script and source it.
source "$DOTFILES_DIR/linux-install.sh"

common_bin_exists 'brew' && brew update

group-cli-install() {
  brew-install
  brew install autoconf automake binutils cmake coreutils ctags curl \
      diff-so-fancy ffmpeg git imagemagick perl python \
      reattach-to-user-namespace ruby ttyrec tmux vim wget youtube-dl zsh
  brew-cask-install
  # brew cask install
  dotfiles-install
}

brew-install() {
  local URL='https://brew.sh/'
  # test
  common_bin_exists 'brew' && return
  # install
  /usr/bin/ruby -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

brew-cask-install() {

}

neovim-install() {
  local URL='https://neovim.io/doc/'
  # test
  command -v nvim 2>&1 > /dev/null && return
  # deps
  brew-install
  # pip
  # install
  brew install neovim/neovim/neovim
  pip install neovim
  pip3 install neovim
}

# TODO: convert stuff from the Makefile.
