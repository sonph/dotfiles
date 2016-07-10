#!/usr/bin/env bash
# Do common stuffs and invoke install scripts.

TIME_FORMAT="+%T"
MESSAGE=""

prompt() {
  echo -ne "$(date $TIME_FORMAT) [ \033[0;33m??\033[0m ] $@"
}

info() {
  echo -e "$(date $TIME_FORMAT) [ \033[00;34m..\033[0m ] $@"
  MESSAGE="$@"
}

success() {
  echo -e "$(date $TIME_FORMAT) [ \033[00;32mOK\033[0m ] $MESSAGE"
}

fail() {
  echo -e "$(date $TIME_FORMAT) [\033[0;31mFAIL\033[0m] $MESSAGE"
  read
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
  SRC="$1"
  DST="$2"
  if [[ -e "$DST" ]]; then
    mv "$DST" "${DST}.orig"
    info "Moved $DST -> ${DST}.orig"
  fi
  ln -s "$1" "$2"
}

binary_exists() {
  which "$1" 2>&1 > /dev/null
  return $?
}

PLATFORM="$(get_platform)"
success "Platform: $PLATFORM"

cd "$(dirname "$0")/.."
DOTFILES_DIR="$(pwd -P)"
success "Dotfiles directory: $DOTFILES_DIR"

success "User: $(whoami)"
if [[ "$(whoami)" == "root" ]]; then
  SUDO=""
else
  SUDO="sudo"
  binary_exists 'sudo' \
    && success 'sudo is installed' \
    || info 'sudo is NOT installed'
fi

# Config.sh
prompt "Launching editor for script/config.sh..."
read

${EDITOR:=vim} script/config.sh
info "Checking for syntax errors with \`bash -n script/config.sh\`"
prompt "If there are errors, please correct them and check again with \`bash -n\`..."
read

source script/config.sh

# Install necessary binaries.
if [[ "$PLATFORM" == "Darwin" ]]; then
  # Homebrew
  info 'Installing homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
    && success \
    || fail 'Follow guide on http://brew.sh to install Homebrew'

  for FORMULA in ${CONFIG_BREW_FORMULAS[@]}; do
    info "Installing homebrew $FORMULA"
    brew install $FORMULA \
      && success \
      || fail "Pls manually install $FORMULA with \`brew install\`"
  done

  if [[ $CONFIG_INSTALL_NEOVIM == "yes" ]]; then
    info 'Installing neovim'
    brew install neovim/neovim/neovim \
      && success \
      || fail 'Follow guide on https://github.com/neovim/homebrew-neovim' \
              'to install neovim'
  fi

  # Brew cask
  info 'Installing brew cask'
  brew tap caskroom/cask \
    && success \
    || fail 'Follow guide on https://caskroom.github.io to install Brew cask'

  for FORMULA in ${CONFIG_CASK_FORMULAS[@]}; do
    info "Installing cask $FORMULA"
    brew cask install $FORMULA \
      && success \
      || fail "Pls manually install $FORMULA with \`brew cask install\`"
  done
fi

if [[ "$PLATFORM" == "Linux" ]]; then
  # Install Linuxbrew.
  info 'Installing linuxbrew'
  $SUDO apt-get install -y build-essential curl git python-setuptools ruby \
    && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)" \
    && success \
    || fail 'Please follow guide on https://github.com/Linuxbrew/brew' \
            'to install linuxbrew'

  for FORMULA in ${CONFIG_LINUXBREW_FORMULAS[@]}; do
    info "Installing $FORMULA"
    linuxbrew install $FORMULA \
      && sucess \
      || fail "Please manually install $FORMULA with \`linuxbrew install\`"
  done
fi

# TODO: npm
# TODO: pip


for DIR in $(ls -d */); do
  if [[ -f "$DIR/install.sh" ]]; then
    echo
    prompt "Running ${DIR}install.sh..." && read
    source $DIR/install.sh
    cd "$DOTFILES_DIR"
  fi
done

exit




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
