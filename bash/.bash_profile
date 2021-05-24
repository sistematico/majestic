#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

test -r $HOME/.dircolors && eval "$(dircolors $HOME/.dircolors)"

#if [[ ! $DISPLAY ]] && [[ $XDG_VTNR -eq 1 ]]; then
#  exec startx
#fi
