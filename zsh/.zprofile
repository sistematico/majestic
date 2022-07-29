#
# ~/.zprofile
#

export WORDCHARS='~!#$%^&*(){}[]<>?+;'

test -r $HOME/.dircolors && eval "$(dircolors $HOME/.dircolors)"

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
