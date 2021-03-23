#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Sem cor
#PS1='[\u@\h \W]:\$ 

# Dracula
PS1="${RED}[${GRN}\u@\h \W${RED}]:\$${DEF} " 

test -r $HOME/.dircolors && eval "$(dircolors $HOME/.dircolors)"

#if [[ $AUTOSTART_XORG -eq 1 && ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#  exec startx
#fi

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
