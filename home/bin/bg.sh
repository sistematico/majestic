#!/usr/bin/env bash
#
# Arquivo: bg.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 28/11/2019 23:50:39
# Última alteração: 01/09/2020 00:23:34

PIDFILE="/var/run/user/$UID/bg.pid"

declare -a PIDs

_screen() {
    xwinwrap -ov -ni -g '1920x1080+0+0' -- mpv --fullscreen \
        --no-stop-screensaver \
        --vo=vdpau --hwdec=vdpau \
        --loop-file --no-audio --no-osc --no-osd-bar -wid WID \
		--no-input-default-bindings --autofit=100%x100% --panscan=1.0 \
        "$1" &
    PIDs+=($!)
}

while read p; do
  [[ $(ps -p "$p" -o comm=) == "xwinwrap" ]] && kill -9 "$p";
done < $PIDFILE

sleep 0.5

_screen "$1"

printf "%s\n" "${PIDs[@]}" > $PIDFILE
