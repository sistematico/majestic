STORAGE=$HOME

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export PNPM_HOME="/home/lucas/.local/share/pnpm"
export FLYCTL_INSTALL="/home/lucas/.fly"
export PATH="$PATH:$FLYCTL_INSTALL/bin:$PNPM_HOME"

setopt autocd extendedglob notify
bindkey -e

bindkey "^[[F"    end-of-line
bindkey "^[[4~"   end-of-line
bindkey "^[[H"    beginning-of-line
bindkey "^[[1~"   beginning-of-line
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
alias rg='rg -luu --ignore-file "$HOME/.config/ripgrep-excludes.lst"'
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
alias rdwm='cd ~/bitbucket/dwm/ && rm -f config.h && make && sudo make install clean && rm -f config.h'
alias rst='cd ~/bitbucket/st/ && rm -f config.h && make && sudo make install clean && rm -f config.h'
alias rdmenu='cd ~/bitbucket/dmenu/ && rm -f config.h && make && sudo make install clean && rm -f config.h'
alias rsurf='cd ~/bitbucket/surf/ && rm -f config.h && make && sudo make install clean && rm -f config.h'
alias rtabbed='cd ~/bitbucket/tabbed/ && rm -f config.h && make && sudo make install clean && rm -f config.h'
alias rdwmblocks='cd ~/bitbucket/dwmblocks/ && rm -f blocks.h && make && sudo make install clean && rm -f blocks.h'
alias copiar='xclip -sel clip <'
alias code='code --disable-gpu'
alias codium='codium --disable-gpu'
alias fd='fd -uuu'
#alias surf='surf-open.sh'
alias a='php artisan'
alias ncp='~/.config/ncmpcpp/ueberzug'
alias ncmpcpp='~/.config/ncmpcpp/ueberzug'
alias logs='lnav ~/.dwm/logs/'

default() {
    local TYPE=$(xdg-mime query filetype "$1")
    ANTIGO=$(xdg-mime query default $TYPE)
    echo "xdg-mime default $2.desktop $TYPE"
    echo "$ANTIGO -> ${2}.desktop"
}

fullsync() {
    if [ ! $1 ]; then
        echo "Pelo menos um parâmetro é esperado."
    else
        [ ! -d $STORAGE/vps/$1 ] && mkdir -p $STORAGE/vps/${1}

        rsync -aAXvzz \
        --exclude-from "$HOME/.config/rsync-excludes.list" \
        root@${1}:/ \
        $STORAGE/vps/${1}/
    fi
}

paste() {
    [ ! -f $1 ] && exit
    curl -F"file=@${1}" https://0x0.st
}

bfc() {
    [ $1 ] && msg="$@" || msg="Primeiro commit"
    git init
    git add .
    git commit -m "$msg"
    git branch -M main
    git remote add origin git@bitbucket.org:sistematico/$(basename $(pwd)).git
    git push -u origin main
}

ghfc() {
    [ $1 ] && msg="$@" || msg="Primeiro commit"
    git init
    git add .
    git commit -m "$msg"
    git branch -M main
    git remote add origin git@github.com:sistematico/$(basename $(pwd)).git
    git push -u origin main
}

commit() {
    [ -f .commit ] && msg="$(cat .commit)" || msg="Commit automático"
    [ $1 ] && msg="$@"
    git add .
    git commit -m "$msg"
    git push
}

auto-commit() {
    if [ -d .git ]; then
        curl -sLo .git/hooks/post-commit 'https://git.io/JzKB2'
        chmod +x .git/hooks/post-commit
        git config --local commit.template .commit

        if [ ! -f .commit ] || [ ! -s .commit ]; then
            echo "Update automático" > .commit
        fi

        if [ ! -f .gitignore ] || [ ! -s .gitignore ]; then
            echo ".commit" > .gitignore
        else
            if ! grep -Fxq ".commit" .gitignore 2> /dev/null; then
                echo ".commit" >> .gitignore
            fi
        fi
    fi
}

remove-commit() {
    [ ! $1 ] && exit

    FILTER_BRANCH_SQUELCH_WARNING=1 \
    git filter-branch --force --index-filter \
        "git rm --cached --ignore-unmatch $1" \
        --prune-empty --tag-name-filter cat -- --all
}

git-revert() {
    git clean -fd
    git checkout -fxd
    git reset --hard
}

fix-whatsapp() {
    ffmpeg -i "$1" -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p "$(basename $1)-fix.mp4"
}

mpcl() {
    local CURRENT="$(mpc -f "%file%" playlist | sha512sum )"
    mpc lsplaylist | while read line
    do
        i="$(mpc -f "%file%" playlist $line | sha512sum )"
        if [ "$i" = "$CURRENT" ]; then
            echo "$line"
        fi
    done
}

mpcr() {
    local lista="$(mpcl)"
    [ -z "$lista" ] && echo "sem lista" && lista="Dance"
    mpc rm $lista
    mpc save $lista
    mpc clear
    mpc load $lista
    mpc play
}

[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH=$PATH:/home/lucas/.spicetify
