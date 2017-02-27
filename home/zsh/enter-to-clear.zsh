# Press Enter on an empty buffer (no command) triggers the clear command.
# See http://superuser.com/questions/625652

enter-to-clear() {
  if [[ -z $BUFFER ]]
  then
    zle clear-screen

    # Additionally, refresh environment variables.
    # This is sonph's specific setup only.
    command -v get_env 2>&1 > /dev/null && get_env

  else
    zle accept-line
  fi
}

zle -N enter-to-clear
bindkey "^M" enter-to-clear
