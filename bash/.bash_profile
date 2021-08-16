#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

#test -r $HOME/.dircolors && eval "$(dircolors $HOME/.dircolors)"

if [[ "$(systemctl is-enabled gdm)" != "enabled" ]] && [[ "$(systemctl is-enabled lightdm)" != "enabled" ]] && [[ ! $DISPLAY ]] && [[ $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
