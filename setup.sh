#!/bin/bash
# -----------------------------------------------------------------------------
#   github.com/s0nny/dotfiles
#   August, 2013
#   setup.sh
#          Symlink git cloned dotfiles to ~/
# -----------------------------------------------------------------------------

VERSION=0.1.0
USAGE="Usage: $ ./setup.sh"

# --- Functions for printing fancy status messages ----------------------------
## functions used to format & print messages
## Usage: printmsg "msg"; do things; printstt <code/ok/fail> [optional short message/value]
## Example1: printmsg "Doing this thing ..."; <do it> && printstt 0 || printstt -1
## Example2: printmsg "Doing this thing ..."; <do it>; printstt $? # use return code of last command itself
## Example3: printmsg "Doing this thing ..."; <do it>; printstt fail # if return code is unknown or not of any particular command
##
# Doing this thing ...                [ OK ]
#
## works with long messages that needs more than 1 line to print:
# Doing this freaking awesome long complicated hard
# complex impossible thing ...        [FAIL]
##
OK="[ \e[1;32mOK \e[0m]"    # [ OK ]
FAIL="[\e[1;31mFAIL\e[0m]"  # [FAIL]
INFO="[ \e[32m>  \E[0m]"    # [ >> ]

TERM_LINES=$(tput lines)
TERM_COLS=$(tput cols)

printmsg () {
    # by default ok/fail prompts will line up at 2/3 position
    local ONELINE_MAX_LENGTH=$(expr $TERM_COLS \* 2 / 3)
    local ALLOCATED_LENGTH=$ONELINE_MAX_LENGTH

    # if allocated length is still not enough, allocate one more line
    until [ $(expr length "$1") -lt $ALLOCATED_LENGTH ]; do
        local ALLOCATED_LENGTH=$(expr $ALLOCATED_LENGTH + $TERM_COLS)
    done
    printf "%-${ALLOCATED_LENGTH}s" "$1"

}

printstt () {
    case "$1" in
        "ok") echo -e "$OK $2";;                # ok with message
        "fail") echo -e "$FAIL $2";;            # fail with message
        "failexit") echo -e "$FAIL $2"; exit;;  # fail and exit with message
        "0") echo -e "$OK $2";;                 # ok with message
        *) echo -e "$FAIL code: $1; $2";;       # fail with code
    esac
}

# --- Bash options ------------------------------------------------------------
## Exit if any commands fail (non zero return code; except 
## if conditions and && constructs)
## To unset: set +e
#set -e
#
## Trace: print commands before executing
## useful for debugging
## usage: set -x; <code>; set +x
#set -x
#
## Verbose: prints shell input lines as they are read
#set -v
#
## Noexec: check for syntax errors only; do not execute
#set -n
#
## Nounset: gives error messages when undefined variables are used
#set -u
#
# --- SNIPPETS ----------------------------------------------------------------
## Determine directory in which the scripts resides
## Note that this oneliner does not work with file symlinks, source, or .
#SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
#echo Script is in $SCRIPT_DIR #test
#
## Determine name of the script (dont resolve symlinks)
#SCRIPT_NAME=$(basename "$BASH_SOURCE")
#echo Script name is $SCRIPT_NAME #test
#
# --- MAIN --------------------------------------------------------------------
# --- Parse options
MODE="local"
[ "$1" = "server" ] && MODE="server"
backupdir () {
    if [ -d "$1" ]; then
        mv "$1" "$1\~"
    fi
}
# if GIT_BASE_DIR does not exist
if [ -z "$GIT_BASE_DIR" ]; then
    GIT_BASE_DIR=$HOME/git
fi

# clone and setup symlinks
echo "Creating symlinks ..."

# shells: zsh, bash
printmsg "Symlinking shells config files ..."
ln -sb $GIT_BASE_DIR/dotfiles/.bash_profile ~
ln -sb $GIT_BASE_DIR/dotfiles/.bashrc ~
ln -sb $GIT_BASE_DIR/dotfiles/.zshrc ~
[ $MODE = "local" ] && ln -sb $GIT_BASE_DIR/dotfiles/.zprofile-local ~/.zprofile
[ $MODE = "server" ] && [ -f $GIT_BASE_DIR/dotfiles.zprofile-server ] && \
    ln -sb $GIT_BASE_DIR/dotfiles.zprofile-server ~/.zprofile
printstt ok

# editors
backupdir "~/.emacs.d"
printmsg "Symlinking editors config files ..."
ln -s $GIT_BASE_DIR/dotfiles/.emacs.d ~
ln -sb $GIT_BASE_DIR/dotfiles/.vimrc ~
printstt ok

# misc
printmsg "Symlinking git, screen, irssi config files ..."
ln -sb $GIT_BASE_DIR/dotfiles/.gitconfig ~
ln -sb $GIT_BASE_DIR/dotfiles/.screenrc ~
backupdir "~/.irssi"
ln -s $GIT_BASE_DIR/dotfiles/.irssi ~
printstt ok

# X, gtk
printmsg "Symlinking .Xdefaults, .gtkrc-2.0 ..."
ln -sb $GIT_BASE_DIR/dotfiles/.Xdefaults ~
ln -sb $GIT_BASE_DIR/dotfiles/.gtkrc-2.0 ~
printstt ok

# mpd & ncmpcpp
printmsg "Symlinking mpd, ncmpcpp config files ..."
backupdir "~/.mpd"
ln -s $GIT_BASE_DIR/dotfiles/.mpd ~/.mpd
ln -sb $GIT_BASE_DIR/dotfiles/.mpd/mpd.conf ~/.mpdconf
ln -sb $GIT_BASE_DIR/dotfiles/.ncmpcpp ~/.ncmpcpp
printstt ok

# xfce4-terminal
printmsg "Symlinking xfce-terminal config ..."
mkdir -p ~/.config/xfce4/terminal
backupdir "~/.config/xfce4/terminal"
ln -s $GIT_BASE_DIR/dotfiles/.config/xfce4/terminal ~/.config/xfce4/terminal
printstt ok
