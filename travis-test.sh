#!/bin/bash

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
RESET="$(tput sgr0)"
info() { echo "[${BLUE}INFO${RESET}] $@"; }
fail() { echo "[${RED}FAIL${RESET}] $@"; }
ok() { echo "[ ${GREEN}OK${RESET} ] $@"; }

wrapper() {
  set +e
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
  set -e
}

set -e

info "Sourcing install script"
if [ "$TRAVIS_OS_NAME" == "linux" ]; then wrapper source linux-install.sh; fi
if [ "$TRAVIS_OS_NAME" == "osx" ]; then wrapper source mac-install.sh; fi

# info "Call dotfiles-install"
# dotfiles-install

