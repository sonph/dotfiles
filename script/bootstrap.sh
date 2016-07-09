#!/usr/bin/env bash
# Do common stuffs and invoke install scripts.

TIME_FORMAT="+%T"

info() {
  # Print '  [ .. ] $1'
  # Follow this with 'success' or 'fail'.
  echo -ne "$(date $TIME_FORMAT) [ \033[00;34m..\033[0m ] $1"
}

success() {
  # Replace the '[ .. ]' of the info line with '[ OK ]'.
  # Optionally overwrite the message.
  echo -e "\r$(date $TIME_FORMAT) [ \033[00;32mOK\033[0m ] $1"
}

fail() {
  # Replace the '[ .. ]' of the info line with '[FAIL]'.
  # Optionally overwrite the message.
  echo -e "\r$(date $TIME_FORMAT) [\033[0;31mFAIL\033[0m] $1"
}

prompt() {
  # Print '  [ ?? ] $1'. Follow this with 'read SOMETHING'.
  echo -ne "$(date $TIME_FORMAT) [ \033[0;33m??\033[0m ] $1"
}

infoln() {
  # Print an info line.
  info "$1\n"
}

successln() {
  # Print a success line. Use this if the command is expected to spew out some
  # output that we can't just replace the last line '[ .. ]' with '[ OK ]'.
  # Generally $1 should be the same as infoln.
  echo -e "$(date $TIME_FORMAT) [ \033[00;32mOK\033[0m ] $1"
}

failln() {
  # Same as successln.
  echo -e "$(date $TIME_FORMAT) [\033[0;31mFAIL\033[0m] $1"
}


succeeded() {
  # Return the last command's status.
  # if succeeded; then; success; else; fail; fi
  return $?
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

execute() {
  # Print some info, execute, report and show what to do next.
  # Usage: execute "info" "command" "to do".
  infoln "$1"
  eval "$2"
  if [[ $? -eq 0 ]]; then
    successln "$1"
  else
    failln "$1"
    prompt "$3"
    read
  fi
}

PLATFORM="$(get_platform)"
successln "Platform: $PLATFORM"

cd "$(dirname "$0")/.."
DOTFILES_DIR="$(pwd -P)"
successln "Dotfiles directory: $DOTFILES_DIR"

# Config.sh
prompt "Launching editor for script/config.sh..."
read
$EDITOR script/config.sh
infoln "Checking for syntax errors with \`bash -n script/config.sh\`"
prompt "If there are errors, please correct them and check again with \`bash -n\`..."
read

source script/config.sh

if [[ "$PLATFORM" == "Darwin" ]]; then
  execute 'Installing homebrew' \
    '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"' \
    'Follow guide on http://brew.sh to install Homebrew...'

  execute 'Installing brew cask' \
    'brew tap caskroom/cask' \
    'Follow guide on https://caskroom.github.io to install Brew cask...'

  for FORMULA in ${CONFIG_BREW_FORMULAS[@]}; do
    execute "Installing homebrew $FORMULA" \
      "brew install $FORMULA" \
      "Pls manually install $FORMULA with \`brew install\` and resolve any issues..."
  done

  if [[ $CONFIG_INSTALL_NEOVIM == "yes" ]]; then
    execute 'Installing neovim' \
      'brew install neovim/neovim/neovim' \
      'Follow guide on https://github.com/neovim/homebrew-neovim to install neovim...'
  fi

  for FORMULA in ${CONFIG_CASK_FORMULAS[@]}; do
    execute "Installing cask $FORMULA" \
      "brew cask install $FORMULA" \
      "Pls manually install $FORMULA with \`brew cask install\` and resolve any issues..."
  done
fi

if [[ "$PLATFORM" == "Linux" ]]; then
  STEP1='sudo apt-get install build-essential curl git python-setuptools ruby'
  STEP2='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"'
  execute 'Installing linuxbrew' \
    "$STEP1 && $STEP2" \
    'Please follow guide on https://github.com/Linuxbrew/brew to install linuxbrew...'

  for FORMULA in ${CONFIG_LINUXBREW_FORMULAS[@]}; do
    execute "Installing $FORMULA" \
      "linuxbrew install $FORMULA" \
      "Please manually install $FORMULA with \`linuxbrew install\` and resolve any issues..."
  done
fi


for DIR in $(ls -d */); do
  if [[ -f "$DIR/install.sh" ]]; then
    echo
    infoln "Running $DIR/install.sh..."
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
