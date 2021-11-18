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

export COMPOSER_HOME=${HOME}/.composer

# PATH
[ -d ${HOME}/bin ] && export PATH=$PATH:$HOME/bin
[ -d ${HOME}/.local/bin ] && export PATH=$PATH:$HOME/.local/bin
[ -d ${HOME}/apps ] && export PATH=${PATH}:${HOME}/apps
[ -d ${HOME}/.npm/bin ] && export PATH=${PATH}:${HOME}/.npm/bin
[ -d ${COMPOSER_HOME}/vendor/bin ] && export PATH=${PATH}:${COMPOSER_HOME}/vendor/bin

# D-BUS
#dbus-update-activation-environment --systemd DISPLAY
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# Vars
export TERMINAL=st
export BROWSER=firefox
export EDITOR=nano
export VISUAL=codium
export XDG_DATA_DIRS=/usr/local/share/:/usr/share/

# VSCodium
export VSCODE_GALLERY_SERVICE_URL='https://marketplace.visualstudio.com/_apis/public/gallery'
export VSCODE_GALLERY_CACHE_URL='https://vscode.blob.core.windows.net/gallery/index'
export VSCODE_GALLERY_ITEM_URL='https://marketplace.visualstudio.com/items'
export VSCODE_GALLERY_CONTROL_URL=''
export VSCODE_GALLERY_RECOMMENDATIONS_URL=''

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

# Autostart
numlockx on &

[ ! -d ${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services ] && mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services"

# IntelliJ Accents
export XMODIFIERS=""

session=${1:-dwm}
case $session in
    dwm)
        #startdwm
    ;;
    i3|i3wm)
        xrandr --output HDMI-0 --primary --mode "2560x1440"

        # Temas
        export GTK2_RC_FILES=$HOME/.local/themes/Nordic-darker-v40/gtk-2.0/gtkrc
        #export GTK_THEME=Adwaita:dark
        export GTK_THEME=Nordic-darker-v40
		export XCURSOR_THEME=Nordzy-cursors
        export XDG_DATA_DIRS=${HOME}/.jail/:$XDG_DATA_DIRS

        SERVICE=org.knopwob.dunst
        ln -sfT \
            "/usr/share/dbus-1/services/${SERVICE:-org.freedesktop.Notifications}.service" \
            "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.freedesktop.Notifications.service"
        exec i3
    ;;
    bspwm)
        xrandr --output HDMI-0 --primary --mode "2560x1440"

        ln -sfT \
            "/usr/share/dbus-1/services/${SERVICE:-org.freedesktop.Notifications}.service" \
            "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.freedesktop.Notifications.service"
        exec bspwm
    ;;
    xfce|xfce4)
        # "/usr/share/dbus-1/services/org.xfce.xfce4-notifyd.Notifications.service" \
        ln -sfT \
            "/usr/share/dbus-1/services/${SERVICE:-org.freedesktop.Notifications}.service" \
            "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.freedesktop.Notifications.service"
        exec startxfce4
    ;;
    mate|mate-session)
        ln -sfT \
            "/usr/share/dbus-1/services/${SERVICE:-org.freedesktop.Notifications}.service" \
            "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.freedesktop.Notifications.service"
        exec mate-session
    ;;
    *)
        ln -sfT \
            "/usr/share/dbus-1/services/${SERVICE:-org.freedesktop.Notifications}.service" \
            "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.freedesktop.Notifications.service"
        exec $session
    ;;
esac
