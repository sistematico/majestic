#
# ~/.zprofile
#

export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH=$PATH:$PNPM_HOME:$HOME/bin:$HOME/.local/bin:/home/lucas/.spicetify
export WORDCHARS='~!#$%^&*(){}[]<>?+;'

test -r $HOME/.dircolors && eval "$(dircolors $HOME/.dircolors)"
