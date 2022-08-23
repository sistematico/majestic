#
# ~/.zprofile
#

export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH=$PATH:$PNPM_HOME:/home/lucas/.spicetify

export WORDCHARS='~!#$%^&*(){}[]<>?+;'

test -r $HOME/.dircolors && eval "$(dircolors $HOME/.dircolors)"

#[ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && exec startx
