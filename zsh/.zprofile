#
# ~/.zprofile
#

export WORDCHARS='~!#$%^&*(){}[]<>?+;'

test -r $HOME/.dircolors && eval "$(dircolors $HOME/.dircolors)"

[ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && exec startx
