#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

##################
##### Vars    ####
##################
export AUTOSTART_XORG=1

##################
##### History  ###
##################
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups

# Size
export HISTSIZE=10000
export HISTFILESIZE=10000

##################
##### Opções  ####
##################
# Ignora a caixa e alguns erros ao trocar de diretório
shopt -s cdspell

# Checa o tamanho da janela e redimensiona
shopt -s checkwinsize

# Muda de diretório sem o cd
shopt -s autocd

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

##################
##### Funções ####
##################
if [[ -f ~/.bash_functions ]]; then
    source ~/.bash_functions
fi

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
##### Prompt #####
##################
# Sem cor
#PS1='[\u@\h \W]:\$ '

# Com cor
PS1="\[${Purple}\][\[${Color_Off}\]\u@\h \W\[${Purple}\]]\[${Color_Off}\]:\$ "


