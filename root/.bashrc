#
# ~/.bashrc
#

##################
##### History  ###
##################
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups

# Size
export HISTSIZE=10000
export HISTFILESIZE=10000

##################
##### Aliases ####
##################
if [[ -f ~/.bash_aliases ]]; then
    source ~/.bash_aliases
fi

##################
##### Sources ####
##################
if [[ -f /etc/cores.inc ]]; then
	source /etc/cores.inc
fi

if [[ -f /usr/share/doc/pkgfile/command-not-found.bash ]]; then
	source /usr/share/doc/pkgfile/command-not-found.bash
fi

if [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
	source /usr/share/git/completion/git-prompt.sh
fi

# # Use bash-completion, if available
if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
	source /usr/share/bash-completion/bash_completion
fi

##################
##### Funções ####
##################
if [[ -f ~/.bash_functions ]]; then
    source ~/.bash_functions
fi

##################
##### Prompt #####
##################
PS1="\[${Red}\][\[${Color_Off}\]\u@\h \W\[${Red}\]]\[${Color_Off}\]:\$ "
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

fortune chucknorris
echo
