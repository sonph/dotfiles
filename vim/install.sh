#!/usr/bin/env bash
# Install vim-related stuffs.

cd "$DOTFILES_DIR/vim"
info 'Setting up vim'

# Symlink vim files.
info 'Setting up vim: symlink files'
for FILE in $(ls); do
  link "$VIM_DIR/$FILE" "$VIM_SYMLINK_DST/.$FILE"
done
success


# Setup Vundle.vim.
info 'Setting up vim: clone Vundle.vim'
VIM_BUNDLE_DIR="$VIM_DIR/vim/bundle"
VIM_VUNDLE_DIR="$VIM_BUNDLE_DIR/Vundle.vim"
if [[ ! -d  "$VIM_VUNDLE_DIR" ]]; then
  mkdir -p "$VIM_VUNDLE_DIR"
  git clone "https://github.com/VundleVim/Vundle.vim" "$VIM_VUNDLE_DIR" \
    && success || fail
fi


# Setup plugins.
info 'Setting up vim: clone plugins'
vim $HOME/.vimrc.plugins -c "PluginInstall" -c "qall!"
success


# Setup vimproc.vim
info 'Setting up vim: make vimproc.vim'
cd "$VIM_DIR/vim/bundle/vimproc.vim"
make && success || fail
cd "$VIM_DIR"


# Setup YouCompleteMe
info 'Setting up vim: compile YouCompleteMe'
python "$VIM_DIR/vim/bundle/YouCompleteMe/install.py" && success || fail


# Setup neovim.
if [[ "$CONFIG_INSTALL_NEOVIM" == "yes" ]]; then
  info 'Setting up vim: neovim'
  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
  link "$VIM_DIR/vimrc" "$VIM_DIR/vim/init.vim"
  link "$VIM_DIR/vim" "$XDG_CONFIG_HOME/nvim"
  $SUDO pip install neovim \
    && success \
    || fail 'Make sure pip is installed (on macOS: brew install python) and pip install neovim'
fi

cd $DOTFILES_DIR
