#!/bin/bash
# ------------------------------------------------
# Script to install additional stuffs on a new kali install.
# ------------------------------------------------

apt-get update
apt-get install -y neovim python3 python3-pip apt-file ttyrec zsh tmux xcape \
  htop nmon tor torbrowser-launcher xbindkeys xbindkeys-config lynx lm-sesors
apt-get autoremove

pip3 install neovim

searchsploit -u

mkdir /code
cd /code
git clone https://github.com/sonph/onehalf
source onehalf/gnome-terminal/onehalfdark.sh

chsh -s /usr/bin/zsh root
touch ~/.zprofile
echo "setxkbmap -option 'caps:ctrl_modifier'" >> ~/.zprofile
echo "xcape -e 'Caps_Lock=Escape'" >> ~/.zprofile

# tor
torbrowser-launcher

systemctl start tor
systemctl enable tor

# nvm
apt-get install -y build-essential libssl-dev
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

npm install -g diff-so-fancy

# reaver
# flux
