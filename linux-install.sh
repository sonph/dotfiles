#!/bin/bash
# ------------------------------------------------
# Script to install additional stuffs on a new linux install.
# Assume Debian-based and XFCE.
# ------------------------------------------------

DOTFILES_DIR="$HOME/.files"
DOTFILES_FONT_DIR="$DOTFILES_DIR/fonts"
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
[[ ! -d "$XDG_CONFIG_HOME" ]] && mkdir -p "$XDG_CONFIG_HOME"
CODE_DIR='/code'
[[ ! -d "$CODE_DIR" ]] && mkdir -p "$CODE_DIR"

group-cli-install() {
  dotfiles-install
  curl-install
  diff-so-fancy-install
  git-install
  python3-install
  pip3-install
  neovim-install
  tor-install
  user-setup
  common_install_pkg ttyrec apt-file software-properties-common lm-sensors
  common_install_pkg zsh tmux xcape htop nmon xbindkeys xbindkeys-config
  common_install_pkg ctags cmake autoconf
  common_install_pkg lynx
}

group-gui-install() {
  gnome-terminal-install
  tor-browser-install
  arc-theme-install
  chromium-install
  fonts-install
  flux-install
}

common_bin_exists() {
  command -v "$1" 2>&1 > /dev/null
  # By default return code is from the last command.
}

common_bin_exists 'apt-get' && apt-get update

common_install_pkg() {
  if common_bin_exists 'apt-get'; then
    sudo apt-get install -y $@
  elif common_bin_exists 'yum'; then
    sudo yum install $@
  else
    err 'Either apt-get or yum not found.'
    return 1
  fi
}

err() {
  >&2 echo $@
}


curl-install() {
  common_bin_exists 'curl' && return
  common_install_pkg 'curl'
}

nvm-install() {
  # test
  common_bin_exists 'nvm' && return
  # deps
  curl-install
  # install
  common_install_pkg build-essential libssl-dev
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
}

npm-install() {
  common_bin_exists 'npm' && return
  nvm install --lts
}

diff-so-fancy-install() {
  # test
  common_bin_exists 'diff-so-fancy' && return
  # deps
  npm-install
  # install
  npm install -g diff-so-fancy
}

git-install() {
  # test
  common_bin_exists 'git' && return
  # deps
  diff-so-fancy-install;
  # install
  common_install_pkg 'git'
}

python3-install() {
  # test
  common_bin_exists 'python3' && return
  # install
  common_install_pkg 'python3'
}

pip3-install() {
  # test
  common_bin_exists 'pip3' && return
  # deps
  python3-install
  # install
  common_install_pkg 'python3-pip'
}

neovim-install() {
  local URL='https://neovim.io/doc/'
  # test
  command -v nvim 2>&1 > /dev/null && return
  # deps
  pip3-install; git-install
  # install
  apt-get install -y neovim
  pip3 install neovim

  local VIM_DIR="$DOTFILES_DIR/home/vim"
  local NVIM_CONFIG_DIR="$XDG_CONFIG_HOME/nvim"
    [[ ! -e "$NVIM_CONFIG_DIR" ]] && ln -s "$VIM_DIR" "$NVIM_CONFIG_DIR"

  local VIM_DEIN_REPOS_DIR="$VIM_DIR/bundle/repos"
  local VIM_DEIN_DIR="$VIM_DEIN_REPOS_DIR/github.com/Shougo/dein.vim"
  mkdir -p "$VIM_DEIN_DIR"
  git clone https://github.com/Shougo/dein.vim "$VIM_DEIN_DIR"
  nvim -c ":call dein#install()"
}

gnome-terminal-install() {
  if common_bin_exists; then
  else
    common_install_pkg 'gnome-terminal'
  fi
  pushd "$CODE_DIR" 2>&1 > /dev/null
  git clone 'https://github.com/sonph/onehalf'
  source onehalf/gnome-terminal/onehalfdark.sh
  source onehalf/gnome-terminal/onehalflight.sh
  popd 2>&1 > /dev/null
}

searchsploit-update() {
  # update
  searchsploit -u
}

searchsploit-install() {
  # deps
  # xmllint for reading nmap xml output
  common_bin_exists 'xmllint' || common_install_pkg 'libxml2-utils'
}

nmap-update() {
  nmap --script-updatedb
}

tor-browser-install() {
  local URL="https://torproject.org/projects/torbrowser.html.en"
  tor-install
  common_install_pkg 'torbrowser-launcher'
  torbrowser-launcher
  echo "If the launcher fails to download, visit $URL"
}

tor-install() {
  if ! common_bin_exists 'tor'; then
    common_install_pkg 'tor'
  fi
  systemctl start tor
  systemctl enable tor
  tor-browser-install
}

arc-theme-install() {
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
    git-install
    pushd "$CODE" 2>&1 > /dev/null
    git clone "$URL"
    pushd "$CODE/arc-theme" 2>&1 > /dev/null
    ./autogen.sh --prefix=/usr --disable-transparency $@
    sudo make install
    popd 2>&1 > /dev/null
    popd 2>&1 > /dev/null
  fi

  common_bin_exists 'xfce4-settings-manager' && xfce4-settings-manager
  echo "Select Arc (Dark|Darker) theme in Appearance and Window Manager"
}

chromium-install() {
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

flux-install() {
  local URL='https://github.com/xflux-gui/xflux-gui'
  # test
  common_bin_exists 'fluxgui' && return
  # deps
  git-install
  # install
  common_install_pkg python-appindicator python-xdg python-pexpect \
      python-gconf python-gtk2 python-glade2 libxxf86vm1
  pushd /tmp 2>&1 > /dev/null
  git clone "$URL"
  cd xflux-gui
  python download-xflux.py
  sudo python setup.py install
  popd 2>&1 > /dev/null
  echo 'To start flux, run `fluxgui`'

  # local URL='https://launchpad.net/~nathan-renniewaldock/+archive/ubuntu/flux'
  # if common_bin_exists 'apt-get'; then
    # common_bin_exists 'add-apt-repository' || common_install_pkg 'software-properties-common'
    # # TODO: not working!
    # sudo add-apt-repository ppa:nathan-renniewaldock/flux
    # sudo apt-get update
    # sudo apt-get install fluxgui
  # else
    # err 'flux-install: Yum not supported'
  # fi
}


fonts-install() {
  local USR_FONTS_DIR='/usr/share/fonts/usrfonts'
  # test
  [[ -d "$USR_FONTS_DIR" && -e "$USR_FONTS_DIR/Monaco_Linux.ttf" ]] && return
  # install
  common_bin_exists 'fc-cache' || common_install_pkg 'fontconfig'
  pushd "$DOTFILES_FONT_DIR" 2>&1 > /dev/null
  tar zxvf mac_fonts.tar.gz
  sudo mv fonts "$USR_FONTS_DIR"

  sudo cp Menlo-Regular.ttf "$USR_FONTS_DIR"
  sudo cp source-code-pro/*.ttf "$USR_FONTS_DIR"

  sudo fc-cache -f -v
  popd 2>&1 > /dev/null
}

dotfiles-install() {
  if [[ ! -e "$HOME/bin" ]]; then
    ln -s "$DOTFILES_DIR/bin" "$HOME/bin"
  fi
  if [[ ! -e "$HOME/.tmux" ]]; then
    for FILE in $(ls "$DOTFILES_DIR/home"); do
      ln -s "$DOTFILES_DIR/home/$FILE" "$HOME/.$FILE"
    done
  fi
}

user-setup() {
  common_bin_exists 'zsh' && chsh -s $(command -v zsh) $(whoami)
}

