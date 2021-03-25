#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

[ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services" ] && mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services"

# D-BUS
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

# Vars
export TERMINAL=urxvt
export EDITOR=nano
export BROWSER=firefox
export COMPOSER_HOME=${HOME}/.composer

# PATH
[ -d ${HOME}/bin ] && export PATH=$PATH:$HOME/bin
[ -d ${HOME}/apps ] && export PATH=${PATH}:${HOME}/apps
[ -d ${HOME}/.npm/bin ] && export PATH=${PATH}:${HOME}/.npm/bin
[ -d ${COMPOSER_HOME}/vendor/bin ] && export PATH=${PATH}:${COMPOSER_HOME}/vendor/bin

# iBus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -drx &

# Lang
#unset LC_ALL
export LANG=pt_BR.UTF-8
#export LC_MESSAGES=C
#export LC_TIME=en_DK.UTF-8

#GTK_THEME=Adwaita:dark

# Autostart
numlockx on &

session=${1:-i3}
case $session in
    i3|i3wm)
        ln -sfT "/usr/share/dbus-1/services/org.knopwob.dunst.service" "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.fr>
		exec i3
    ;;
    bspwm)
        #ln -sfT "/usr/share/dbus-1/services/org.knopwob.dunst.service" "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.fr>
		exec bspwm
    ;;
    xfce)
        ln -sfT "/usr/share/dbus-1/services/org.xfce.xfce4-notifyd.Notifications.service" "${XDG_DATA_HOME:-$HOME/.local/share}/dbu>
		exec startxfce4
    ;;
    *)
        ln -sfT "/usr/share/dbus-1/services/org.knopwob.dunst.service" "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.fr>
        exec $session
    ;;
esac
