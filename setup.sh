#!/bin/bash

# special prompt at beginning of line
# looks like '[>]' 
BEG="\E[32m [>]\E[0m"

# if GIT_BASE_DIR does not exist
if [ -z "$GIT_BASE_DIR" ]; then
    GIT_BASE_DIR=$HOME/git
fi

# setup directory to store clone
# default is $HOME/git
#GIT_BASE_DIR="$HOME/git"
#echo "$BEG Directory to clone git and store 'dotfiles' folder:"
#echo -n "default [$GIT_BASE_DIR]: "
#read INPUT
#if [ -n "$INPUT" ]; then
	#GIT_BASE_DIR="$INPUT"

# confirm
#echo
#echo -n "$BEG Clone dotfiles into $GIT_BASE_DIR; confirm? "
#read

# clone and setup symlinks

echo "$BEG creating symlinks ..."
# shells: zsh, bash
ln -sb $GIT_BASE_DIR/dotfiles/.bash_profile ~
ln -sb $GIT_BASE_DIR/dotfiles/.bashrc ~
ln -sb $GIT_BASE_DIR/dotfiles/.zshrc ~

# editors
ln -sb $GIT_BASE_DIR/dotfiles/.vimrc ~
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi
ln -s $GIT_BASE_DIR/dotfiles/.emacs.d ~

# misc
ln -sb $GIT_BASE_DIR/dotfiles/.gitconfig ~
ln -sb $GIT_BASE_DIR/dotfiles/.screenrc ~
ln -sb $GIT_BASE_DIR/dotfiles/.vimrc ~
if [ -d .irssi/ ]; then
    mv .irssi .irssi~
fi
ln -s $GIT_BASE_DIR/dotfiles/.irssi ~

# urxvt
ln -s $GIT_BASE_DIR/dotfiles/.Xdefaults ~

# .gtkrc-2.0
ln -s $GIT_BASE_DIR/dotfiles/.gtkrc-2.0 ~

# mpd & ncmpcpp
ln -s $GIT_BASE_DIR/dotfiles/.mpd ~/.mpd
ln -s $GIT_BASE_DIR/dotfiles/.mpd/mpd.conf ~/.mpdconf
ln -s $GIT_BASE_DIR/dotfiles/.ncmpcpp ~/.ncmpcpp

# xfce4-terminal
ln -s $GIT_BASE_DIR/dotfiles/.config/xfce4/terminal ~/.config/xfce4/terminal
