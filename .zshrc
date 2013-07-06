# Created by newuser for 4.3.17
autoload -U compinit promptinit
compinit
promptinit

# prompt style
prompt walters

# arrow key driven autocomplete interface
zstyle ':completion:*' menu select

# aliases
alias ls='ls --color=auto'
alias rm='rm -vi'
alias mv='mv -vi'
alias cp='cp -vi'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ~='cd ~'

# path
typeset -U path
path=(/usr/local/heroku/bin $path)
