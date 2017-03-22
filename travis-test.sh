#!/bin/bash

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
RESET="$(tput sgr0)"
info() { echo "[${BLUE}INFO${RESET}] $@"; }
fail() { echo "[${RED}FAIL${RESET}] $@"; }
ok() { echo "[ ${GREEN}OK${RESET} ] $@"; }

wrapper() {
  # Run command and check stderr. Stderr is redirected to tee so we can check
  # the size while also be able to see it in the logs.
  $@ 2> >(tee -a stderr.${1})
  # Wait for tee to finish writing to file. If we do not sleep, the following
  # stderr check fails even if we see stderr on the screen.
  sleep 1
  if [[ -s "stderr.$1" ]]; then
    fail "Stderr is not empty. Begin stderr.$1"
    cat "stderr.$1"
    fail "End stderr.$1"
    exit 1
  fi
}

info "Sourcing install script"
if [ "$TRAVIS_OS_NAME" == "linux" ]; then wrapper source linux-install.sh; fi
if [ "$TRAVIS_OS_NAME" == "osx" ]; then wrapper source mac-install.sh; fi

info "Call dotfiles-install"
dotfiles-install
test_file_exists_and_not_empty() {
  if [[ -s "$1" ]]; then
    fail "${1} does not exist or is empty"
    exit 1
  fi
}
test_file_exists_and_not_empty "$HOME/.gitconfig"
test_file_exists_and_not_empty "$HOME/.shaliases"
test_file_exists_and_not_empty "$HOME/.tmux.conf"
test_file_exists_and_not_empty "$HOME/.tmux/tmux-status-right"
test_file_exists_and_not_empty "$HOME/.zshrc"
test_file_exists_and_not_empty "$HOME/.zsh/git-prompt.zsh"
test_file_exists_and_not_empty "$HOME/.vim/init.vim"
test_file_exists_and_not_empty "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim"
test_file_exists_and_not_empty "$HOME/bin/ack"

