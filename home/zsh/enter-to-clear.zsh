# Press Enter on an empty buffer (no command) triggers the clear command.
# See http://superuser.com/questions/625652/alias-empty-command-in-terminal

enter-to-clear() {
  if [[ -z $BUFFER ]]
  then
    zle clear-screen
  else
    zle accept-line
  fi
}

zle -N enter-to-clear
bindkey "^M" enter-to-clear
