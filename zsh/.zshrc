export PATH=$PATH:/home/lucas/.spicetify

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

setopt autocd extendedglob notify
bindkey -e

bindkey "^[[H"    beginning-of-line
bindkey "^[[1~"   beginning-of-line
bindkey "^[[4~"   end-of-line
bindkey "^[[P"    delete-char
bindkey "^[[3~"   delete-char

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

bindkey "^H"      kill-word

zstyle :compinstall filename '/home/lucas/.zshrc'

autoload -Uz compinit
compinit

alias ls='ls --color=always --group-directories-first'
alias e='exit'
alias s='sudo su'
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'
alias pacman='sudo pacman'
alias pacman-clean='sudo pacman -Qdtq | pacman -Rs - 2>/dev/null'
alias pikaur='pikaur --noconfirm'
alias paru='paru --noconfirm'
alias trizen='trizen --noconfirm'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias host='getent hosts'
alias loopback='pactl load-module module-loopback latency_msec=1'
alias tb='nc termbin.com 9999'
alias reload="source $HOME/.zshrc"
alias rdwm='cd ~/bitbucket/dwm/ && rm -f config.h && make && sudo make install clean'
alias rdwmblocks='cd ~/bitbucket/dwmblocks/ && rm -f blocks.h && make && sudo make install clean'
alias rdmenu='cd ~/bitbucket/dmenu/ && rm -f config.h && make && sudo make install clean'
alias rst='cd ~/bitbucket/st/ && rm -f config.h && make && sudo make install clean'
alias copiar='xclip -sel clip <'
alias code='code --disable-gpu'
alias codium='codium --disable-gpu'
alias fd='fd -uuu'

paste() {
    [ ! -f $1 ] && exit
    curl -F"file=@${1}" https://0x0.st
}

commit() {
    [ -f .commit ] && msg="$(cat .commit)" || msg="Commit automático"
    [ $1 ] && msg="$@"
    git add .
    git commit -m "$msg"
    git push
}

git-revert() {
    git clean -fd
    git checkout -fxd
    git reset --hard
}

fix-whatsapp() {
    ffmpeg -i "$1" -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p "$(basename $1)-fix.mp4"
}

mpcr() {
    [ ! $1 ] && return
    mpc rm $1
    mpc save $1
    mpc clear
    mpc load $1
    mpc play
}

[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"

# pnpm
export PNPM_HOME="/home/lucas/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
