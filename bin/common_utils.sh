#!/bin/bash
# Common functions for testing scripts.
if [[ -z "$SONPH_COMMON_UTILS" ]]; then
SONPH_COMMON_UTILS=yes  # Include guard.
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
PURPLE="$(tput setaf 5)"
RESET="$(tput sgr0)"
info() { echo "[${BLUE}INFO${RESET}] $@"; }
ok() { echo "[ ${GREEN}OK${RESET} ] $@"; }
warn() { echo "[${YELLOW}WARN${RESET}] $@" >&2; }
fail() { echo "[${RED}FAIL${RESET}] $@" >&2; }
log_and_exec() { echo "[${PURPLE}EXEC${RESET}] $@"; eval "$@"; }
fi
