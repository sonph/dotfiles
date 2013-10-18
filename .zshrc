# Created by newuser for 4.3.17

autoload -U compinit promptinit colors
compinit
promptinit
colors

# prompt style
# for list of prompts, run `prompt -l`
# `prompt` requires `autoload -U promptinit && promptinit`
#prompt walters

# key bindings style
bindkey -v  # -v for vim, -e for emacs

# arrow key driven autocomplete interface
zstyle ':completion:*' menu select

# environment variables
export GIT_BASE_DIR="$HOME/git"
export XDG_CONFIG_HOME="$HOME/.config"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# path
typeset -U path
path=(/usr/local/heroku/bin $path) # heroku toolbelt
path=(/home/$USER/bin $path)

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

# git prompt
# wiki.archlinux.org/index.php/Git#Git_Prompt
export GIT_PS1_SHOWDIRTYSTATE=" " # show */+ for unstaged/staged changes
export GIT_PS1_SHOWSTASHSTATE=" " # show $ if something is stashed
export GIT_PS1_SHOWUNTRACKEDFILES=" " # show % if there are untracked files
export GIT_PS1_SHOWUPSTREAM="auto" # show </>/<> to indicate behind/ahead/diverged w/ upstream
setopt PROMPT_SUBST # set zsh to evaluate functions/substitutions in prompt PS1
source ~/.git-prompt.sh
# wiki.archlinux.org/index.php/Zsh#Colors
PROMPT='%n@%{$fg[green]%}%m%{$reset_color%} %1d%{$fg[cyan]%}$(__git_ps1 " [%s]")%{$reset_color%} %# '
RPROMPT='%{$fg[green]%}[%?] %d%{$reset_color%}' 

# fix broken backspace key on some keyboards
stty erase ^H

# colored manpage w/ less
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}