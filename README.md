# @sonph's .files

[![travis-build-badge](https://img.shields.io/travis/sonph/dotfiles.svg)](https://travis-ci.org/sonph/dotfiles)

![screenshot](ss.png)

## Installation

linux

```
sudo apt-get update
ping github.com
git clone https://github.com/sonph/dotfiles ~/.files
~/.files/linux-install.sh group-cli-install  # essential cli stuffs
~/.files/linux-install.sh group-gui-install  # gui stuffs
```

### VSCode

MacOS:

```
mkdir -p ~/Library/Application\ Support/Code/User
rm ~/Library/Application\ Support/Code/User/settings.json
ln -s $PWD/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
rm ~/Library/Application\ Support/Code/User/keybindings.json
ln -s $PWD/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```
