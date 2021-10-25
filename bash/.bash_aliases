# Core
alias c='clear'
alias ls='ls --color=always --group-directories-first'
#alias ls='exa -g --group-directories-first'
alias rm='rm -Iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias mkdir='mkdir -pv'
alias e='exit'
alias s='sudo su'
alias pacman='sudo pacman'
alias pacman-clean='sudo pacman -Qdtq | pacman -Rs - 2>/dev/null'
alias pikaur='pikaur --noconfirm'
alias yay='pikaur --noconfirm'
alias trizen='pikaur --noconfirm'
#alias rg='rg --hidden --follow --no-messages'
alias rg='rg -uuu'
alias fd='fd -uu'
alias cat='bat'
alias journalctl='sudo journalctl'
alias script='script -a'
alias host='getent hosts'

# Main
alias rehash='source ~/.bashrc && source ~/.bash_aliases && source ~/.bash_functions && source ~/.bash_profile'
alias lixo='dd if=/dev/zero of=file.txt count=1024 bs=1048576'
alias els='els --els-icons=fontawesome'
alias ufw='sudo ufw'
alias copiar='xclip -sel clip <'
alias neofetch='neofetch --config ~/.neofetch.conf'
alias baixarmp3='youtube-dl --extract-audio --audio-format mp3'
alias baixarlista='youtube-dl --username sistematico --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"'

# Devel
#alias crlf='find . -not -type d -exec file "{}" ";" | grep CRLF | egrep -v "vendor|node_modules" 2> /dev/null'
alias crlf='find . -type d \( -name node_modules -o -name vendor -o -name zz-old \) -prune -false -o -type f -exec file "{}" ";" | grep CRLF 2> /dev/null'
alias a='php artisan'

# Simple Terminal
#alias str='cd ~/aur/st && vim config.h && makepkg --nobuild && makepkg -eicf --noconfirm'
alias str='cd ~/aur/st && makepkg --nobuild && makepkg -eicf --noconfirm'

# Code
#alias code='codium --disable-gpu'
alias codium='codium --disable-gpu'

# Misc
alias vim="vim -c 'startinsert'"
#alias showip='curl icanhazip.com'
alias showip='dig +short myip.opendns.com @resolver1.opendns.com'
alias lostfiles='sudo lostfiles strict | egrep -vi "/etc/X11/xorg.conf.d|/etc/pacman.d/hooks|/opt/containerd|/etc/fonts|/etc/systemd/user/sockets.target.wants|/etc/systemd/user/default.target.wants|/usr/local/bin|/usr/share/(themes|icons|hplip|fonts|cinnamon|backgrounds|docky|mime|pixmaps|\.mono|nginx|agave)|/var/(default|cache)|/usr/lib/python3\.8|-disabled"'
alias ue='systemctl list-unit-files | grep enabled'
alias uue='systemctl --user list-unit-files | grep enabled'
alias stpshr='systemctl --user stop ngrok dropbox google-drive onedrive yandex && sudo systemctl stop cronie nginx php-fpm sshd ddclient && touch ~/github/majestic/.noup ~/github/sistematico.github.io/.noup'
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias castnow="castnow --myip 192.168.0.1 --address 192.168.0.5 --device QuartoFazenda"
alias git-cron='~/.local/bin/git-cron'
alias tx='tmux a'
alias tmux='tmux a'
alias ranger='VISUAL=vim ranger'
alias heic='mogrify -format jpg *.heic'
alias id3='id3v2'
alias noid3='find . -type f -exec id3v2 -l {} + | grep "No ID3 tag"'

# VPS
alias artemis='ssh root@artemis'
alias hera='ssh root@hera'
alias atlas='ssh root@atlas'

# Docker
alias dip='docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dst='docker start'
alias dsp='docker stop'
alias drs='docker restart'
alias dps='docker ps -a'

# pastebin
alias tb="nc termbin.com 9999"

# Grub
alias setlinux='sudo grub-set-default 0'
alias setwin='sudo grub-set-default 3'

# Laravel
alias laravel-start='docker start laravel-nginx laravel-php laravel-memcached laravel-mailhog laravel-redis'
alias laravel-restart='docker restart laravel-nginx laravel-php laravel-memcached laravel-mailhog laravel-redis'
alias laravel-stop='docker stop laravel-nginx laravel-php laravel-memcached laravel-mailhog laravel-redis'

# Python
alias pip-update='pip3 list --outdated --format=freeze | grep -v "^\-e" | cut -d = -f 1 | xargs -n1 pip3 install -U'

# Audio
#alias loopback='pactl load-module module-loopback latency_msec=1 source=1 sink=0'
alias loopback='pactl load-module module-loopback latency_msec=1'

# ffmpeg
alias ffmpeg='nice 5 ffmpeg'
