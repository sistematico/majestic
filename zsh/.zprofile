#
# ~/.zprofile
#

export WORDCHARS='~!#$%^&*(){}[]<>?+;'

. "$HOME/.cargo/env"

test -r $HOME/.dircolors && eval "$(dircolors $HOME/.dircolors)"

if [[ "$(systemctl is-enabled gdm 2> /dev/null)" != "enabled" ]] && 
   [[ "$(systemctl is-enabled lightdm 2> /dev/null)" != "enabled" ]] && 
   [[ ! $DISPLAY ]] && 
   [[ $XDG_VTNR -eq 1 ]]; then
  exec startx
fi