# Created by newuser for 4.3.17

autoload -U compinit promptinit
compinit
promptinit

# prompt style
# for list of prompts, run `prompt -l`
# `prompt` requires `autoload -U promptinit && promptinit`
prompt walters

# arrow key driven autocomplete interface
zstyle ':completion:*' menu select

# path
typeset -U path
path=(/usr/local/heroku/bin $path) # heroku toolbelt

# ALIASES
# 2.1) Safety
alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -iv"
set -o noclobber

# 2.2) Listing, directories, and motion
alias ls='ls --color=auto'
alias ll="ls -alrtF --color"
alias la="ls -A"
alias l="ls -CF"
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias m='less'
alias ..='cd ..'
alias ...='cd ..;cd ..'
alias ~='cd ~'
alias md='mkdir'
alias cl='clear'
alias du='du -ch --max-depth=1'
alias treeacl='tree -A -C -L 2'

# 2.3) Text and editor commands
alias em='emacs -nw'     # No X11 windows
alias eqq='emacs -nw -Q' # No config and no X11
export EDITOR='vim'
#export VISUAL='vim' 

# 2.4) grep options
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;31' # green for matches

# 2.5) sort options
# Ensures cross-platform sorting behavior of GNU sort.
# http://www.gnu.org/software/coreutils/faq/coreutils-faq.html#Sort-does-not-sort-in-normal-order_0021
unset LANG
export LC_ALL=POSIX

# 2.6) Install rlwrap if not present
# http://stackoverflow.com/a/677212
command -v rlwrap >/dev/null 2>&1 || { echo >&2 "Install rlwrap to use node: sudo apt-get install -y rlwrap";}

# 2.7) node.js and nvm
# http://nodejs.org/api/repl.html#repl_repl
alias node="env NODE_NO_READLINE=1 rlwrap node"
alias node_repl="node -e \"require('repl').start({ignoreUndefined: true})\""
export NODE_DISABLE_COLORS=1
if [ -s ~/.nvm/nvm.sh ]; then
    NVM_DIR=~/.nvm
    source ~/.nvm/nvm.sh
    nvm use v0.10.12 &> /dev/null # silence nvm use; needed for rsync
fi

# environment variables
export GIT_BASE_DIR=$HOME/git
export XDG_CONFIG_HOME=$HOME/.config
export LANG=en_US.UTF-8
export LC_ALL=POSIX
export TERM=rxvt-unicode

# apt
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias purge='sudo apt-get remove --purge'
alias update='sudo apt-get update && sudo apt-get upgrade'
alias upgrade='sudo apt-get upgrade'
alias clean='sudo apt-get autoclean && sudo apt-get autoremove'
alias search='apt-cache search'
alias show='apt-cache show'
alias sources='(gksudo gedit /etc/apt/sources.list &)'

# misc aliases
alias uzbl='uzbl-tabbed'
