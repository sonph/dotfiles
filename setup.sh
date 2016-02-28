#!/bin/bash

ANYKEY='  >>  Press any key to continue or C-c to cancel...'

# symlink files
echo '  >>  Symlinking files...'
echo "$ANYKEY"; read

DIR="home"

for file in $(ls $DIR); do
    ln -s $PWD/$DIR/$file $HOME/.${file}
done

ln -s $PWD/bin $HOME/bin

# setup vim
echo '  >>  Setting up vim...'
echo "$ANYKEY"; read

vim $HOME/.vimrc.plugins -c "PluginInstall"

