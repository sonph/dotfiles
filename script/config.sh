#!/usr/bin/env bash
#
# Usage: source config.sh from script/bootstrap.sh.
#
# This file contains config information for bootstrap.sh, such as gitconfig
# author name and email, brew formulas to install, cask apps to install, etc.

# Gitconfig.
CONFIG_GITCONFIG_NAME="Son A. Pham"
CONFIG_GITCONFIG_EMAIL="sp@sonpham.me"

# Brew casks to install if on macOS.
# To search for available Brew Cask formulas, use
#   https://caskroom.github.io/search
# and view the formula information with
#   https://github.com/caskroom/homebrew-cask/blob/master/Casks/<FORMULA>.rb
CONFIG_CASK_FORMULAS=(
  "atom"
  "dash"
  "dropbox"
  "flux"
  "franz"
  "google-chrome"
  "iterm2"
  "jumpcut"
  "licecap"
  "macs-fan-control"
  "skype"
  "spectacle"
  "sublime-text"
  "vlc"
)

# Brew formulas to install if on macOS.
# List of homebrew formulas:
#   https://github.com/Homebrew/homebrew-core/tree/master/Formula
CONFIG_BREW_FORMULAS=(
  "cmake"
  "coreutils"
  "ctags"
  "curl"
  "git"
  "python"
  "python3"
  "tmux"
  "vim"
  "wget"
  "zsh"
)

# Linuxbrew packages to install if on Linux.
CONFIG_LINUXBREW_FORMULAS=(
  "ctags"
  "curl"
  "git"
  "make"
  "python"
  "python3"
  "tmux"
  "vim"
  "wget"
  "zsh"
)

# Install neovim?
CONFIG_INSTALL_NEOVIM="yes"

# Install tmux?
CONFIG_INSTALL_TMUX="yes"
