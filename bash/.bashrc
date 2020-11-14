#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

##################
##### Vars    ####
##################
export AUTOSTART_XORG=0

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

# rsync
function fullsync() {
	[ ! -d $HOME/vps/$1 ] && mkdir -p $HOME/vps/${1}
	rsync -aAXvzz --exclude={"usr/lib/x86_64-linux-gnu/","usr/lib/gcc/x86_64-linux-gnu/","var/lib/snapd/void/","usr/libexec/openssh/ssh-keysign","var/cache/","usr/src/kernels/","var/lib/php/sessions/","var/log/journal/","var/cache/apt/","*.mp3",".local/share/Trash/",".local/share/Steam/",".cache/","var/spoll/anacron/","var/log/btmp","var/lib/systemd/random-seed","tmp/backup","usr/bin/ssh-agent","var/cache/yum","/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/var/tmp/","/lost+found",".vzfifo",".cpt_hardlink*",".autorelabel","/etc/shadow","/etc/shadow-","/etc/gshadow","/etc/gshadow-"} root@${1}:/ ${HOME}/vps/${1}/
}

function checkiso() {
	if [ -f SHA512SUMS ]; then
        sha512sum --ignore-missing -c SHA512SUMS
        return
	fi
	
	if [ -f SHA256SUMS ]; then
        sha256sum --ignore-missing -c SHA256SUMS
        return
	fi
}

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
##### Prompt #####
##################
# Sem cor
#PS1='[\u@\h \W]:\$ '

# Com cor
PS1="\[${Purple}\][\[${Color_Off}\]\u@\h \W\[${Purple}\]]\[${Color_Off}\]:\$ "


