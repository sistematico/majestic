#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

COMPOSER_HOME=$HOME/.composer
PATH=$PATH:$COMPOSER_HOME/vendor/bin

#if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#  exec startx
#fi
