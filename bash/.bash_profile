#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Sem cor
#PS1='[\u@\h \W]:\$ 

# Dracula
PS1="${RED}[${GRN}\u@\h \W${RED}]:\$${DEF} " 
#PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

if [[ $AUTOSTART_XORG -eq 1 && ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

#alias ls='ls -GFh'
