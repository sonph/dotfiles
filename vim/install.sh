#!/usr/bin/env bash
# Install vim-related stuffs.

cd "$(dirname "$0")"
VIM_DIR="$(pwd -P)"

infoln 'Setting up vim'


# Symlink vim files.
INFO='Setting up vim: symlink files'
infoln "$INFO"
VIM_SYMLINK_DST="$HOME"

for FILE in $(ls); do
  link "$VIM_DIR/$FILE" "$VIM_SYMLINK_DST/.$FILE"
done
successln "$INFO"



# Setup Vundle.vim.
INFO='Setting up vim: clone Vundle.vim'
infoln "$INFO"
VIM_BUNDLE_DIR="$VIM_DIR/vim/bundle"
VIM_VUNDLE_DIR="$VIM_BUNDLE_DIR/Vundle.vim"
if [[ ! -d  "$VIM_VUNDLE_DIR" ]]; then
  mkdir -p "$VIM_VUNDLE_DIR"
  git clone "https://github.com/VundleVim/Vundle.vim" "$VIM_VUNDLE_DIR"
fi
successln "$INFO"


# Setup plugins.
INFO='Setting up vim: clone plugins'
infoln "$INFO"
vim $HOME/.vimrc.plugins -c "PluginInstall" -c "qall!"
successln "$INFO"

# Setup vimproc.vim
INFO='Setting up vim: make vimproc.vim'
infoln "$INFO"
cd "$VIM_DIR/vim/bundle/vimproc.vim"
make \
  && successln "$INFO" \
  || failln "$INFO"
cd "$DOTFILES_DIR"


# Setup YouCompleteMe
INFO='Setting up vim: compile YouCompleteMe'
infoln "$INFO"
python "$VIM_DIR/vim/bundle/YouCompleteMe/install.py"
successln "$INFO"


# Setup neovim.
if [[ "$CONFIG_INSTALL_NEOVIM" == "yes" ]]; then
  INFO='Setting up vim: neovim'
  infoln "$INFO"
  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
  link "$VIM_DIR/vimrc" "$VIM_DIR/vim/init.vim"
  link "$VIM_DIR/vim" "$XDG_CONFIG_HOME/nvim"
  $SUDO pip install neovim \
    && successln "$INFO" \
    || failln 'Make sure pip is installed (on macOS: brew install python) and pip install neovim'
fi

cd $DOTFILES_DIR
