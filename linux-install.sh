#!/bin/bash
# ------------------------------------------------
# Script to install additional stuffs on a new linux install.
# Assume Debian-based and XFCE.
# ------------------------------------------------

source bin/common_utils.sh

if [ "$(whoami)" == 'root' ]; then
  SUDO=''
else
  if command -v > /dev/null 'sudo' 2>&1; then
    SUDO='sudo'
  else
    fail 'User is not root, yet sudo is not available'
  fi
fi

DOTFILES_DIR="$HOME/code/dotfiles"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
[[ ! -d "$XDG_CONFIG_HOME" ]] && mkdir -p "$XDG_CONFIG_HOME"

CODE_DIR="$HOME/code"
[[ ! -d "$CODE_DIR" ]] && mkdir -p "$CODE_DIR"
[[ ! -e '/code' ]] && $SUDO ln -s "$CODE_DIR" '/code'

BIN_DIR="$HOME/bin"

# TODO: sort all this stuff into sections.

function group_cli_install() {
  common_install_pkg zsh tmux htop nmon ctags cmake lynx
  dotfiles_install
  curl_install
  git_install
  python23_install
  pip23_install
  neovim_install
  tor_install
  user_setup
  pipenv_install
}

function group_security_install() {
  common_install_pkg nmap tor proxychains
  exploitdb_install
}

function common_bin_exists() {
  command -v "$1" > /dev/null 2>&1
  # By default return code is from the last command.
}

function common_install_pkg() {
  if common_bin_exists 'apt-get'; then
    $SUDO apt-get install -y "$@"
  else
    fail 'Apt-get not found (only apt-get is supported at the moment).'
    return 1
  fi
}

function exploitdb_install() {
  readonly local url='https://github.com/offensive-security/exploit-database'
  common_bin_exists searchsploit && return
  # deps
  git_install
  # install
  pushd "$CODE_DIR" > /dev/null 2>&1
  git clone "$url" exploitdb
  ln -s "$CODE_DIR/exploitdb/searchsploit" "$BIN_DIR/searchsploit"
  popd > /dev/null 2>&1
}

function curl_install() {
  common_bin_exists 'curl' || common_install_pkg 'curl'
}

function git_install() {
  common_bin_exists 'git' || common_install_pkg 'git'
}

function python23_install() {
  common_bin_exists 'python' && common_bin_exists 'python3' && return
  # install
  # For yum: python*-devel
  common_install_pkg 'python' 'python3' 'python-dev' 'python3-dev'
}

function pip23_install() {
  common_bin_exists 'pip' && common_bin_exists 'pip3' && return
  # deps
  python23_install
  # install
  common_install_pkg 'python-pip' 'python3-pip'
}

function pipenv_install() {
  readonly local url='https://github.com/kennethreitz/pipenv'
  # test
  common_bin_exists 'pipenv' && return
  # deps
  pip23_install
  # install
  pip install 'pipenv'
}

function neovim_install() {
  readonly local url='https://neovim.io/doc/'
  command -v nvim > /dev/null 2>&1 && return
  # deps
  pip23_install; git_install
  # install
  if common_bin_exists 'apt-get'; then
    if [ "$(apt-cache search '^neovim$' | wc -l)" -lt 1 ]; then
      add_apt_repository_install
      $SUDO add-apt-repository -y ppa:neovim-ppa/stable
      $SUDO apt-get update -q
    fi
  else
    fail 'Pkg manager other than apt-get is not yet supported'
    return 1
  fi
  common_install_pkg 'neovim'
  $SUDO pip install neovim
  $SUDO pip3 install neovim
  # cmake needed for compiling YouCompleteMe
  common_bin_exists 'make' || common_install_pkg 'make'

  local VIM_DIR="$DOTFILES_DIR/home/vim"
  local NVIM_CONFIG_DIR="$XDG_CONFIG_HOME/nvim"
    [[ ! -e "$NVIM_CONFIG_DIR" ]] && ln -s "$VIM_DIR" "$NVIM_CONFIG_DIR"

  local VIM_DEIN_REPOS_DIR="$VIM_DIR/bundle/repos"
  local VIM_SHOUGO_DIR="$VIM_DEIN_REPOS_DIR/github.com/Shougo"
  mkdir -p "$VIM_SHOUGO_DIR"
  pushd > /dev/null "$VIM_SHOUGO_DIR" 2>&1
  git clone https://github.com/Shougo/dein.vim
  popd > /dev/null 2>&1
  nvim -c ":call dein#install()"
  nvim -c ":call dein#recache_runtimepath()"
}

function searchsploit_update() {
  # update
  searchsploit -u
}

function searchsploit_install() {
  # deps
  # xmllint for reading nmap xml output
  common_bin_exists 'xmllint' || common_install_pkg 'libxml2-utils'
}

function nmap_update() {
  nmap --script-updatedb
}

function tor_install() {
  common_bin_exists 'tor' || common_install_pkg 'tor'
  $SUDO systemctl start tor
  $SUDO systemctl enable tor
}

function gcloud_install() {
  readonly local url='https://cloud.google.com/sdk/downloads'
  common_bin_exists 'gcloud' && return
  # install
  curl https://sdk.cloud.google.com | bash
}

function dotfiles_install() {
  pushd "$DOTFILES_DIR" > /dev/null 2>&1
  git submodule init && git submodule update
  popd > /dev/null 2>&1
  if [[ ! -e "$HOME/bin" ]]; then
    ln -s "$DOTFILES_DIR/bin" "$HOME/bin"
  fi
  if [[ ! -e "$HOME/.tmux" ]]; then
    for FILE in $(ls "$DOTFILES_DIR/home"); do
      ln -s "$DOTFILES_DIR/home/$FILE" "$HOME/.$FILE"
    done
  fi
}

function user_setup() {
  common_bin_exists 'zsh' && chsh -s "$(command -v zsh)" "$(whoami)"
}

function docker_install() {
  readonly local url='https://docs.docker.com/engine/installation/linux/debian/#install-using-the-repository'
  # test
  common_bin_exists 'docker' && return
  # install
  common_install_pkg apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL "https://download.docker.com/linux/debian/gpg" | sudo apt-key add -
  if [[ $($SUDO apt-key fingerprint "0EBFCD88" | grep -c "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88") -le 0 ]]; then
    fail "GPG key fingerprint is invalid or not found"
    fail "See: $url"
    return 1
  fi
  $SUDO add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  $SUDO apt-get update -q
  common_install_pkg docker-ce
  $SUDO docker run hello-world
}

function shellcheck_install() {
  local url='https://github.com/koalaman/shellcheck#installing'
  common_bin_exists 'shellcheck' && return
  common_install_pkg shellcheck
}

function tig_install() {
  common_bin_exists 'tig' && return
  common_install_pkg tig
}

# If SOURCE_AS_LIBRARY is defined, then don't execute the functions.
if [[ -z "$SOURCE_AS_LIBRARY" ]]; then
  if [ $# -eq 0 ]; then
    compgen -A function | grep -Ev '^(fail|info|ok)'
    exit 0
  fi
  "$@"
fi
