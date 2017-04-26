#!/bin/bash
# Common functions for testing scripts.
if [[ -z "$SONPH_COMMON_UTILS" ]]; then
SONPH_COMMON_UTILS=yes  # Include guard.
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
RESET="$(tput sgr0)"
info() { echo "[${BLUE}INFO${RESET}] $@"; }
fail() { echo "[${RED}FAIL${RESET}] $@"; }
ok() { echo "[ ${GREEN}OK${RESET} ] $@"; }
fi
