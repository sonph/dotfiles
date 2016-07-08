#!/usr/bin/env bash

info 'Setting up vim...'

VIM_DIR="vim"


# Symlink vim files.
VIM_SYMLINK_DST="$HOME"
for FILE in $(ls "$VIM_DIR"/*.symlink); do
  ln -s "$DOTFILES_DIR/$VIM_DIR/$FILE" "$VIM_SYMLINK_DST/.$FILE"
done
success 'Setting up vim: symlink vim files'


# Symlink neovim files.
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
link "$VIM_DIR/vimrc" "$VIM_DIR/vim/init.vim"
link "$VIM_DIR/vim" "$XDG_CONFIG_HOME/nvim"
sudo pip install neovim
success 'Setting up vim: neovim'


# Setup Vundle.vim.
VIM_BUNDLE_DIR="$VIM_DIR/vim/bundle"
VIM_VUNDLE_DIR="$VIM_BUNDLE_DIR/Vundle.vim"
if [[ ! -d  "$VIM_VUNDLE_DIR" ]]; then
  mkdir -p "$VIM_VUNDLE_DIR"
  git clone "https://github.com/VundleVim/Vundle.vim" "$VIM_VUNDLE_DIR"
fi
success 'Setting up vim: Vundle.vim'

# Setup plugins.
vim $HOME/.vimrc.plugins -c "PluginInstall" -c "qall!"
success 'Setting up vim: install plugins with Vundle'

# Setup vimproc.vim
cd "$VIM_DIR/vim/bundle/vimproc.vim"
make
cd "$DOTFILES_DIR"
success 'Setting up vim: compile vimproc.vim'

# Setup YouCompleteMe
python "$VIM_DIR/vim/bundle/YouCompleteMe/install.py"
success 'Setting up vim: compile YouCompleteMe'


