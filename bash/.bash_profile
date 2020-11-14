#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ $AUTOSTART_XORG -eq 1 && ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
