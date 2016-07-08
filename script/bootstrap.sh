#!/usr/bin/env bash
#
# Bootstrap links files and invoke install scripts.

set -e

TIME_FORMAT="+%T"

info() {
  echo -e "$(date $TIME_FORMAT)  [ \033[00;34m..\033[0m ] $1"
}

prompt() {
  echo -ne "$(date $TIME_FORMAT)  [ \033[0;33m??\033[0m ] $1: "
}

success() {
  echo -e "$(date $TIME_FORMAT)\033[2K  [ \033[00;32mOK\033[0m ] $1"
}

fail() {
  echo -e "$(date $TIME_FORMAT)\033[2K  [\033[0;31mFAIL\033[0m] $1"
  exit 1
}

get_platform() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Darwin"
  elif [[ "$(expr substr $(uname -s) 1 5)" = "Linux" ]]; then
    echo "Linux"
  else
    echo "Windows"
  fi
}

link() {
  ln -s "$1" "$2" 2> /dev/null
}

PLATFORM="$(get_platform)"

cd "$(dirname "$0")/.."
DOTFILES_DIR="$(pwd -P)"


# Check binaries:
vim
tmux
make
pip
node/npm





source /tmp/test.sh

exit





# symlink files {
echo '  >>  Symlinking files...'
echo "$ANYKEY"; read

DIR="home"

# List files for symlinking only.
# See http://askubuntu.com/questions/289321/listing-files-in-a-directory-without-listing-subdirectories-and-their-contents-i
for file in $(ls -p $DIR | grep -v /); do
  ln -s $PWD/$DIR/$file $HOME/.${file}
done

[[ ! -e $HOME/bin ]] && ln -s $PWD/bin $HOME/bin
# }

# check binaries {
echo '  >>  Checking for binaries...'
echo "$ANYKEY"; read
BINARIES=('tmux' 'ctags' 'vim' 'zsh' 'curl' 'wget' 'python' 'nvim' 'pip')
for BIN in ${BINARIES[@]}; do
  which $BIN 2>&1 > /dev/null || echo "$BIN not found"
done

if which tmux 2>&1 > /dev/null && [[ "$(tmux -V)" < "tmux 2.2" ]]; then
  echo "  >>  Tmux version is $(tmux -V); need at least tmux 2.2 for true color support."
fi
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

# setup neovim configs {
# See https://neovim.io/doc/user/nvim_from_vim.html
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
ln -s $PWD/home/vim $XDG_CONFIG_HOME/nvim
ln -s $PWD/home/vimrc $PWD/home/vim/init.vim

which pip 2>&1 > /dev/null && sudo pip install neovim || \
  cat <<END
  >>  pip is not installed. Please install pip by
        \`sudo apt-get install python-pip\` or
        \`wget https://bootstrap.pypa.io/get-pip.py && sudo python ./get-pip.py\`
      then
        \`sudo pip install neovim\`
END
# }
