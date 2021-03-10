#!/bin/sh
#
# $interface (ex: wlan0)
# $profile (ex: wlan0-essid)
# $action (ex: CONNECT, see wpa_actiond --help)
# $ssid

if [ "$profile" = "wireless" ]
then
    case "$action" in
		# CONNECT, LOST, REESTABLISHED, FAILED, DISCONNECT
        "LOST"|"FAILED"|"DISCONNECT")
            rmmod rtl8xxxu
            modprobe rtl8xxxu
			if [ "$DISPLAY" ]; then
				notify-send "NetCtl" "Modulo de rede wi-fi recarregado..."
			fi
            ;;

        "CONNECT")
            if [ "$DISPLAY" ]; then
                notify-send "NetCtl" "Conectado!"
            fi
            ;;
        "REESTABLISHED")
            if [ "$DISPLAY" ]; then
                notify-send "NetCtl" "Reconectado!"
            fi
            ;;

        #*)
        #    unset http_proxy
        #    ;;
    esac
fi
