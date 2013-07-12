<<<<<<< HEAD
CLONE_DIR="$HOME/git"
echo 'Directory to clone git and store "dotfiles" folder:'
echo -n "default [$CLONE_DIR]: "
read INPUT
if [ -n "$INPUT" ]; then
	CLONE_DIR="$INPUT"

cd $CLONE_DIR 
git clone https://github.com/s0nny/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
mv .emacs.d .emacs.d~
ln -s dotfiles/.emacs.d .
=======
#!/bin/bash

# special prompt at beginning of line
# looks like '[>]' 
BEG="\E[32m [>]\E[0m"

# if GIT_DIR does not exist
if [ -z "$GIT_DIR" ]; then
    GIT_DIR=$HOME/git
fi

# setup directory to store clone
# default is $HOME/git
#GIT_DIR="$HOME/git"
#echo "$BEG Directory to clone git and store 'dotfiles' folder:"
#echo -n "default [$GIT_DIR]: "
#read INPUT
#if [ -n "$INPUT" ]; then
	#GIT_DIR="$INPUT"

# confirm
#echo
#echo -n "$BEG Clone dotfiles into $GIT_DIR; confirm? "
#read

# clone and setup symlinks

echo "$BEG creating symlinks ..."
# shells: zsh, bash
ln -sb $GIT_DIR/dotfiles/.bash_profile ~
ln -sb $GIT_DIR/dotfiles/.bashrc ~
ln -sb $GIT_DIR/dotfiles/.zshrc ~

# editors
ln -sb $GIT_DIR/dotfiles/.vimrc ~
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi
ln -s $GIT_DIR/dotfiles/.emacs.d ~

# misc
ln -sb $GIT_DIR/dotfiles/.gitconfig ~
ln -sb $GIT_DIR/dotfiles/.screenrc ~
ln -sb $GIT_DIR/dotfiles/.vimrc ~
if [ -d .irssi/ ]; then
    mv .irssi .irssi~
fi
ln -s $GIT_DIR/dotfiles/.irssi ~
>>>>>>> bfea1f7b84421c1a005f8dab947c3789784b742f
