# @sonph's .files

[![travis-build-badge](https://img.shields.io/travis/sonph/dotfiles.svg)](https://travis-ci.org/sonph/dotfiles)

![screenshot](ss.png)

## Installation

Linux

```
sudo apt-get update
mkdir -p ~/code
git clone --depth 3 https://github.com/sonph/dotfiles ~/code/dotfiles
bash ~/code/dotfiles/linux-install.sh group-cli-install  # essential cli stuffs
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

### Karabiner

```
mkdir -p ~/.config/karabiner
rm ~/.config/karabiner/karabiner.json
ln -s $PWD/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
```
