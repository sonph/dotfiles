#!/bin/bash
# ------------------------------------------------
# Script to install additional stuffs on a new linux install.
# Assume Debian-based and XFCE.
# ------------------------------------------------

source bin/common_utils.sh

if [ $(whoami) == 'root' ]; then
  SUDO=''
else
  if command -v 2>&1 > /dev/null 'sudo'; then
    SUDO='sudo'
  else
    fail 'User is not root, yet sudo is not available'
  fi
fi

DOTFILES_DIR="$HOME/.files"
DOTFILES_FONT_DIR="$DOTFILES_DIR/fonts"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
[[ ! -d "$XDG_CONFIG_HOME" ]] && mkdir -p "$XDG_CONFIG_HOME"

CODE_DIR="$HOME/code"
[[ ! -d "$CODE_DIR" ]] && mkdir -p "$CODE_DIR"
[[ ! -e '/code' ]] && $SUDO ln -s "$CODE_DIR" '/code'

BIN_DIR="$HOME/bin"

# TODO: sort all this stuff into sections.

function group_cli_install() {
  common_install_pkg ttyrec apt-file software-properties-common lm-sensors
  common_install_pkg zsh tmux xcape htop nmon xbindkeys xbindkeys-config
  common_install_pkg ctags cmake autoconf
  common_install_pkg lynx
  dotfiles_install
  curl_install
  diff_so_fancy_install
  git_install
  python23_install
  pip23_install
  neovim_install
  tor_install
  user_setup
  pipenv_install
}

function group_gui_install() {
  gnome_terminal_install
  tor_browser_install
  arc_theme_install
  chromium_install
  fonts_install
  flux_install
}

function group_security_install() {
  common_install_pkg nmap tor proxychains
  exploitdb_install
}

function common_bin_exists() {
  command -v "$1" 2>&1 > /dev/null
  # By default return code is from the last command.
}

function common_install_pkg() {
  if common_bin_exists 'apt-get'; then
    $SUDO apt-get install -y $@
  else
    fail 'Apt-get not found. Only apt-get is supported at the moment.'
    return 1
  fi
}

function exploitdb_install() {
  local URL='https://github.com/offensive-security/exploit-database'
  # test
  common_bin_exists searchsploit && return
  # deps
  git_install
  # install
  pushd $CODE_DIR 2>&1 > /dev/null
  git clone "$URL" exploitdb
  ln -s "$CODE_DIR/exploitdb/searchsploit" "$BIN_DIR/searchsploit"
  popd 2>&1 > /dev/null
}

function curl_install() {
  common_bin_exists 'curl' || common_install_pkg 'curl'
}

function nvm_install() {
  # test
  common_bin_exists 'nvm' && return
  # deps
  curl_install
  # install
  common_install_pkg build-essential libssl-dev
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
}

function npm_install() {
  common_bin_exists 'npm' && return
  nvm_install
  nvm install --lts
}

function diff_so_fancy_install() {
  # test
  common_bin_exists 'diff-so-fancy' && return
  # deps
  npm_install
  # install
  npm install -g diff-so-fancy
}

function git_install() {
  # test
  common_bin_exists 'git' && return
  # deps
  diff_so_fancy_install;
  # install
  common_install_pkg 'git'
}

function python23_install() {
  # test
  common_bin_exists 'python' && common_bin_exists 'python3' && return
  # install
  # For yum: python*-devel
  common_install_pkg 'python' 'python3' 'python-dev' 'python3-dev'
}

function pip23_install() {
  # test
  common_bin_exists 'pip' && common_bin_exists 'pip3' && return
  # deps
  python23_install
  # install
  common_install_pkg 'python-pip' 'python3-pip'
}

function pipenv_install() {
  local URL='https://github.com/kennethreitz/pipenv'
  # test
  common_bin_exists 'pipenv' && return
  # deps
  pip23_install
  # install
  pip install 'pipenv'
}

function neovim_install() {
  local URL='https://neovim.io/doc/'
  # test
  command -v nvim 2>&1 > /dev/null && return
  # deps
  pip23_install; git_install
  # install
  if common_bin_exists 'apt-get'; then
    if [ $(apt-cache search '^neovim$' | wc -l) -lt 1 ]; then
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
  pushd 2>&1 > /dev/null "$VIM_SHOUGO_DIR"
  git clone https://github.com/Shougo/dein.vim
  popd 2>&1 > /dev/null
  nvim -c ":call dein#install()"
  nvim -c ":call dein#recache_runtimepath()"
}

function add_apt_repository_install() {
  # test
  common_bin_exists 'add-apt-repository' && return
  # install
  common_install_pkg 'software-properties-common'
}

function gnome_terminal_install() {
  common_bin_exists || common_install_pkg 'gnome-terminal'
  pushd "$CODE_DIR" 2>&1 > /dev/null
  git clone 'https://github.com/sonph/onehalf'
  # TODO: resolve shell exits problem on sourcing
  echo "Run 'source onehalf/gnome-terminal/onehalfdark.sh' in another shell"
  echo "Run 'source onehalf/gnome-terminal/onehalflight.sh' in another shell"
  # source onehalf/gnome-terminal/onehalfdark.sh
  # source onehalf/gnome-terminal/onehalflight.sh
  popd 2>&1 > /dev/null
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

function tor_browser_install() {
  local URL="https://torproject.org/projects/torbrowser.html.en"
  tor_install
  common_install_pkg 'torbrowser-launcher'
  torbrowser-launcher
  echo "If the launcher fails to download, visit $URL"
}

function tor_install() {
  common_bin_exists 'tor' || common_install_pkg 'tor'
  $SUDO systemctl start tor
  $SUDO systemctl enable tor
}

function arc_theme_install() {
  local URL='https://github.com/horst3180/arc-theme'
  # test: TODO
  # install
  if [[ $# -eq 0 ]]; then
    # with transparency
    common_install_pkg 'arc-theme'
  else
    # manual build with options (see URL for options)
    # --disable-{transparency,cinnamon,gnome-shell,unity,...}
    common_install_pkg autoconf automake pkg-config libgtk-3-dev \
        gnome-themes-standard gtk2-engines-murrine
    git_install
    pushd "$CODE" 2>&1 > /dev/null
    git clone "$URL"
    pushd "$CODE/arc-theme" 2>&1 > /dev/null
    ./autogen.sh --prefix=/usr --disable-transparency $@
    $SUDO make install
    popd 2>&1 > /dev/null
    popd 2>&1 > /dev/null
  fi

  common_bin_exists 'xfce4-settings-manager' && xfce4-settings-manager
  echo "Select Arc (Dark|Darker) theme in Appearance and Window Manager"
}

function chromium_install() {
  # test
  common_bin_exists 'chromium' && return
  # install
  common_install_pkg 'chromium'
  [[ "$(whoami)" = 'root' ]] && \
      echo 'export CHROMIUM_FLAGS="$CHROMIUM_FLAGS --no-sandbox --user-data-dir"' \
      >> /etc/chromium.d/default-flags
  # To do web security testing, run `chromium --disable-web-security`
}

# reaver

function flux_install() {
  local URL='https://github.com/xflux-gui/xflux-gui'
  # test
  common_bin_exists 'fluxgui' && return
  # deps
  git_install
  # install
  common_install_pkg python-appindicator python-xdg python-pexpect \
      python-gconf python-gtk2 python-glade2 libxxf86vm1
  pushd /tmp 2>&1 > /dev/null
  git clone "$URL"
  cd xflux-gui
  python download-xflux.py
  $SUDO python setup.py install
  popd 2>&1 > /dev/null
  echo 'To start flux, run `fluxgui`'

  # local URL='https://launchpad.net/~nathan-renniewaldock/+archive/ubuntu/flux'
  # if common_bin_exists 'apt-get'; then
    # common_bin_exists 'add-apt-repository' || common_install_pkg 'software-properties-common'
    # # TODO: not working!
    # $SUDO add-apt-repository ppa:nathan-renniewaldock/flux
    # $SUDO apt-get update -q
    # common_install_pkg fluxgui
  # else
    # fail 'flux-install: Yum not supported'
  # fi
}

function gcloud_install() {
  local URL='https://cloud.google.com/sdk/downloads'
  # test
  common_bin_exists 'gcloud' && return
  # install
  curl https://sdk.cloud.google.com | bash
}

function travis_install() {
  local URL='https://github.com/travis-ci/travis.rb'
  # test
  common_bin_exists 'travis' && return
  # install
  # TODO: verify if we need gem dependency and $SUDO?
  gem install travis --no-rdoc --no-ri
}

function fonts_install() {
  local USR_FONTS_DIR='/usr/share/fonts/usrfonts'
  # test
  [[ -d "$USR_FONTS_DIR" && -e "$USR_FONTS_DIR/Monaco_Linux.ttf" ]] && return
  # install
  common_bin_exists 'fc-cache' || common_install_pkg 'fontconfig'
  pushd "$DOTFILES_FONT_DIR" 2>&1 > /dev/null
  tar zxvf mac_fonts.tar.gz
  $SUDO mv fonts "$USR_FONTS_DIR"

  $SUDO cp Menlo-Regular.ttf "$USR_FONTS_DIR"
  $SUDO cp source-code-pro/*.ttf "$USR_FONTS_DIR"

  $SUDO fc-cache -f -v
  popd 2>&1 > /dev/null
}

function dotfiles_install() {
  pushd "$DOTFILES_DIR" 2>&1 > /dev/null
  git submodule init && git submodule update
  popd 2>&1 > /dev/null
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
  common_bin_exists 'zsh' && chsh -s $(command -v zsh) $(whoami)
}

function docker_install() {
  local URL='https://docs.docker.com/engine/installation/linux/debian/#install-using-the-repository'
  # test
  common_bin_exists 'docker' && return
  # install
  common_install_pkg apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL "https://download.docker.com/linux/debian/gpg" | sudo apt-key add -
  if [[ $($SUDO apt-key fingerprint "0EBFCD88" | grep "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88" | wc -l) -le 0 ]]; then
    fail "GPG key fingerprint is invalid or not found"
    fail "See: $URL"
    return 1
  fi
  $SUDO add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  $SUDO apt-get update -q
  common_install_pkg docker-ce
  $SUDO docker run hello-world
}

function pylint_install() {
  local URL='https://www.pylint.org/#install'
  common_bin_exists 'pylint' && return
  common_install_pkg pylint
}

function shellcheck_install() {
  local URL='https://github.com/koalaman/shellcheck#installing'
  common_bin_exists 'shellcheck' && return
  common_install_pkg shellcheck
}

if [ $# -eq 0 ]; then
  echo $(compgen -A function) | sed 's/\(fail\|info\|ok\) //g'
  exit 0
fi
$@
