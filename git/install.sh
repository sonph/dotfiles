#!/usr/bin/env bash

cd 'git'
info 'Setting up gitconfig'

# Setup gitconfig.
if [[ ! -f gitconfig.local ]]; then
  info 'Setup gitconfig'
  sed -e "s/{AUTHORNAME}/${CONFIG_GITCONFIG_NAME}/g" \
    -e "s/{AUTHOREMAIL}/${CONFIG_GITCONFIG_EMAIL}/g" \
    gitconfig.local.example > gitconfig.local \
    && success || fail
fi

# Symlink files
info 'Setting up gitconfig: symlink files'
for FILE in $(ls); do
  link "$GITCONFIG_DIR/$FILE" "$HOME/.$FILE"
done
success

