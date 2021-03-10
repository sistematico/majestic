#!/usr/bin/env bash
#
# Arquivo: beats.sh
#
# Devolve a hora atual em beats.
#
# Desenvolvido por Lucas Saliés Brum <lucas@archlinux.com.br>
#
# Swatch Internet Time
# http://www.timeanddate.com/time/internettime.html
# https://www.swatch.com/en/internettime/
# https://en.wikipedia.org/wiki/Swatch_Internet_Time#Calculation_from_UTC.2B1
#
# Criado em: 20/12/2017 19:27:31
# Última Atualização: 31/10/2018 12:36:38

if [ "$DESKTOP_SESSION" == "mate" ]; then
	icone="@"
fi

function beats {
    command -v bc >/dev/null 2>&1 || { echo "bc não encontrado." ; exit 1; }
    read h m s <<<$(date -u "+%H %M %S")
    # (UTC+1sec + (UTC+1min * 60) + (UTC+1hr * 3600)) / 86.4 
    b=$(bc -l <<< "scale=0; ($s + ($m * 60) + (($h) * 3600)) / 86.4")
}

case $1 in
    1)
        echo $(date +'%H:%M')
    ;;
    2)
        beats
        echo "$(date +'%H:%M') @$b"
    ;;
    3)
        beats
        echo "$(date +'%d/%m %H:%M') @$b"
    ;;
    *)
        beats
        echo $icone$b
    ;;
esac


