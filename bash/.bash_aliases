# Core
alias ls='ls --color=always --group-directories-first'
#alias ls='exa -g --group-directories-first'
alias cat='bat'
alias fd='fd -H'
alias rm='rm -Iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias mkdir='mkdir -pv'

# AUR Helpers
alias yay='yay --noconfirm'
alias trizen='trizen --noconfirm'

# Main
alias rehash='source ~/.bashrc && source ~/.bash_aliases && source ~/.bash_functions'
alias lixo='dd if=/dev/zero of=file.txt count=1024 bs=1048576'
alias els='els --els-icons=fontawesome'
alias ufw='sudo ufw'
alias copiar='xclip -sel clip <'
alias e='exit'
alias s='sudo su'
alias pacman='sudo pacman'
alias neofetch='neofetch --config ~/.neofetch.conf'
alias baixarmp3='youtube-dl --extract-audio --audio-format mp3'
alias baixarlista='youtube-dl --username sistematico --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"'
alias fullsync='rsync -aAXvzz --exclude={"usr/libexec/openssh/ssh-keysign","var/cache/","usr/src/kernels/","var/lib/php/sessions/","var/log/journal/","var/cache/apt/","*.mp3",".local/share/Trash/",".local/share/Steam/",".cache/","var/spoll/anacron/","var/log/btmp","var/lib/systemd/random-seed","tmp/backup","usr/bin/ssh-agent","var/cache/yum","/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/var/tmp/","/lost+found",".vzfifo",".cpt_hardlink*",".autorelabel","/etc/shadow","/etc/shadow-","/etc/gshadow","/etc/gshadow-"}'
alias pacman-clean='sudo pacman -Qdtq | pacman -Rs -'
alias vim="vim -c 'startinsert'"
alias showip='curl icanhazip.com'
alias lostfiles='sudo lostfiles strict | egrep -vi "/etc/systemd/user/sockets.target.wants|/etc/systemd/user/default.target.wants|/usr/local/bin|/usr/share/(themes|icons|hplip|fonts|cinnamon|backgrounds|docky|mime|pixmaps|\.mono|nginx|agave)|/var/(default|cache)|/usr/lib/python3\.8|-disabled"'
alias ue='systemctl list-unit-files | grep enabled'
alias uue='systemctl --user list-unit-files | grep enabled'
alias stpshr='systemctl --user stop ngrok dropbox google-drive onedrive yandex && sudo systemctl stop cronie nginx php-fpm sshd ddclient && touch ~/github/majestic/.noup ~/github/sistematico.github.io/.noup'
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias castnow="castnow --myip 192.168.0.1 --address 192.168.0.5 --device QuartoFazenda"
alias git-cron='~/.local/bin/git-cron'
alias tx='tmux a'
alias ranger='VISUAL=vim ranger'
alias heic='mogrify -format jpg *.heic'

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

# ncmpcpp
alias music='\tmux new-session "\tmux source-file ~/.config/ncmpcpp/tmux_session"' # Tmux session with ncmpcpp and cover art

# pastebin
alias tb="nc termbin.com 9999"
