#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

if [[ $AUTOSTART_XORG -eq 1 && ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

alias ls='ls -GFh'
