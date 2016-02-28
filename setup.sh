#!/bin/bash

ANYKEY='  >>  Press any key to continue or C-c to cancel...'

# symlink files {
echo '  >>  Symlinking files...'
echo "$ANYKEY"; read

DIR="home"

for file in $(ls $DIR); do
  ln -s $PWD/$DIR/$file $HOME/.${file}
done

ln -s $PWD/bin $HOME/bin
# }

# check binaries {
echo '  >>  Checking for binaries...'
echo "$ANYKEY"; read
BINARIES=('tmux' 'ctags' 'vim' 'zsh' 'curl' 'wget' 'python' 'make')
for BIN in ${BINARIES[@]}; do
  which $BIN 2>&1 > /dev/null || echo "$BIN not found"
done
# }

# setup vim {
echo '  >>  Setting up vim plugins...'
echo "$ANYKEY"; read

# setup vundle
if [ -z "$(ls -A $HOME/.vim/bundle/Vundle.vim)" ]; then
  echo '  >>  Pulling Vundle.vim submodule...'
  cd $HOME/.vim/bundle/Vundle.vim
  git submodule init
  git submodule update
fi

# setup plugins
which vim 2>&1 > /dev/null && vim $HOME/.vimrc.plugins -c "PluginInstall" -c "qall!" || echo "  >>  vim is not installed"

# setup vimproc.vim (plugin for unite.vim)
cd $HOME/.vim/bundle/vimproc.vim
which make 2>&1 > /dev/null && make || '  >>  make is not installed. Please install make and make $HOME/.vim/bundle/vimproc.vim'

# setup YouCompleteMe (completion engine)
which python 2>&1 > /dev/null && python $HOME/.vim/bundle/YouCompleteMe/install.py || \
  echo '  >>  python is not installed. Please install python and python $HOME/.vim/bundle/YouCompleteMe/install.py or disable YouCompleteMe in $HOME/.vimrc.plugins'
# }
