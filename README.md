dotfiles.git
============
This repo contains mostly my own customized config files, including:
 * shells configs
 	+ `.zshrc`
 	+ `.bashrc`, `.bash_profile`
 * editors configs
 	+ `.vimrc`
 	+ `.emacs.d`
 * other tools and config files
 	+ `.screenrc`
 	+ `.irssi/config`
    + `.gitconfig`

and is intended to be used by setup.git when setting up a new linux machine. This repo can also be used to copy config files onto an existing machines by running the included setup.sh script.

```sh
git clone https://github.com/s0nny/dotfiles.git
chmod u+x ./dotfiles/setup.sh && ./dotfiles/setup.sh
```
