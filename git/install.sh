#!/usr/bin/env bash

# Setup gitconfig
if [[ ! -f git/gitconfig.local.symlink ]]; then
  echo
  info 'Setup gitconfig'
  prompt 'Gitconfig full name'
  GITCONFIG_NAME="$(prompt_read)"
  prompt 'Gitconfig email'
  GITCONFIG_EMAIL="$(prompt_read)"

  sed -e "s/{AUTHORNAME}/${GITCONFIG_NAME}/g" \
    -e "s/{AUTHOREMAIL}/${GITCONFIG_EMAIL}/g" \
    git/gitconfig.local.example > git/gitconfig.local

  success 'gitconfig'
fi

# Symlink files

