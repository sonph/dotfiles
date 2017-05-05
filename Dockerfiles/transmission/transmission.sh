#!/bin/bash

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
RESET="$(tput sgr0)"
info() { echo "[${BLUE}INFO${RESET}] $@"; }
fail() { echo "[${RED}FAIL${RESET}] $@"; }
ok() { echo "[ ${GREEN}OK${RESET}  ] $@"; }

SETTINGS_FILE='/etc/transmission-daemon/settings.json'

function configure() {
  local password="$1"

  service transmission-daemon start
  service transmission-daemon stop

  info "Rpc username: transmission"
  info "Rpc password: $password"
  info "Rpc port: 9091"

  cp -f /settings.json $SETTINGS_FILE
  sed -i "s/RPC_PASSWORD/$password/g" $SETTINGS_FILE

  service transmission-daemon start
}

function start() {
  service transmission-daemon start || systemctl start transmission-daemon
  # TODO(sonph): Figure out where is the log file and tail that shit.
  # Tail is used so the container doesn't exit immediately.
  tail -f $SETTINGS_FILE
}

"$@"
