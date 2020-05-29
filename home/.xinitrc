#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

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

#GTK_THEME=Adwaita:dark
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -drx &

session=${1:-bspwm}
case $session in
    i3|i3wm)
        ln -sfT "/usr/share/dbus-1/services/org.knopwob.dunst.service" "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.fr>
		exec i3
    ;;
    bspwm)
        ln -sfT "/usr/share/dbus-1/services/org.knopwob.dunst.service" "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.fr>
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
