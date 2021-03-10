#!/usr/bin/env bash

command -v yad 1> /dev/null 2> /dev/null
if [ $? = 1 ]; then
    echo "yad não instalado."
    exit
fi

gtk3="$HOME/.config/gtk-3.0/settings.ini"
gtk2="$HOME/.gtkrc-2.0"

toggle() {
    if [ -f $1 ]; then
		pattern="$2"
		value="$3"
        if grep -q "$pattern" "$1"; then
			sed -i "s|${pattern}=.*|${pattern}=$value|g" $1
        fi
    fi
}

tema=$(yad --width 300 --entry --title "Tema de Som" \
    --image=gnome-shutdown                        \
    --button="gtk-ok:0" --button="gtk-close:1"    \
    --text "Choose action:"                       \
    --entry-text                                  \
    $(ls /usr/share/sounds))

if [ $tema ]; then
	if [ -f $gtk2 ]; then
		if grep -q 'gtk-sound-theme-name' "$gtk2"; then
			sed -i 's/Var2=.*/Var2=smurf/' $gtk2
		fi
	fi

    if [ -f $HOME/.config/gtk-3.0/settings.ini ]; then
		if grep -q 'gtk-sound-theme-name' "$gtk3"; then
        	#sed -i 's/gtk-sound-theme-name=.*/gtk-sound-theme-name=smurf/' $gtk3
			sed -i "s|$var|r_str|g"
		fi
    fi

	#xfconf-query -c xsettings -p /Net/SoundThemeName -s $tema
	#DISPLAY=:0 canberra-gtk-play -i complete
fi
