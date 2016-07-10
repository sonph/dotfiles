#!/usr/bin/env bash

cd "$(dirname "$0")"
GITCONFIG_DIR="$(pwd -P)"

infoln 'Setting up gitconfig'

# Setup gitconfig.
if [[ ! -f gitconfig.local ]]; then
  echo
  info 'Setup gitconfig'
  prompt 'Gitconfig full name'
  read GITCONFIG_NAME
  prompt 'Gitconfig email'
  read GITCONFIG_EMAIL

  sed -e "s/{AUTHORNAME}/${GITCONFIG_NAME}/g" \
    -e "s/{AUTHOREMAIL}/${GITCONFIG_EMAIL}/g" \
    git/gitconfig.local.example > git/gitconfig.local

  success 'gitconfig'
fi

# Symlink files

