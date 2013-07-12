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