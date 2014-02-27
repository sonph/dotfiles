# zsh components
autoload -U compinit promptinit colors
compinit
promptinit
colors

# builtin prompt style
# for list of prompts, run `prompt -l`
# `prompt` requires `autoload -U promptinit && promptinit`
#prompt walters

# key bindings style
bindkey -v  # -v for vim, -e for emacs

# arrow key driven autocomplete interface
zstyle ':completion:*' menu select

# PATH
typeset -U path
#path=(/usr/local/heroku/bin $path) # heroku toolbelt
path=($HOME/bin $path)

# PROMPT
# git status
# reference: wiki.archlinux.org/index.php/Git#Git_Prompt
setopt PROMPT_SUBST     # set zsh to evaluate functions/substitutions in prompt PS1
source ~/.git-prompt.sh

# shell prompt
# reference: wiki.archlinux.org/index.php/Zsh#Colors
PROMPT='%n@%{$fg[green]%}%m%{$reset_color%} %1d%{$fg[cyan]%}$(__git_ps1 " [%s]")%{$reset_color%} %# '
RPROMPT='%{$fg[green]%}[%?] %d%{$reset_color%}' 

# fix broken backspace key on some keyboards
# stty erase ^H

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

. $HOME/.shexports          # exports
. $HOME/.shaliases          # aliases
