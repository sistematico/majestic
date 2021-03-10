#!/usr/bin/env bash
################################################################################
#                                                                              #
# audiodown.sh                                                                 #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 05-12-2019 4:25:37 pm                                             #
# Modificado em: 05-12-2019 4:49:06 pm                                         #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

nome="Audio Downloader"
SECONDS=0
comeco=$SECONDS
log=0 # 0 = Sem log, 1 = Log no arquivo erro.log
ts=$(date +"%s")
dir="${HOME}/desk"
icone="${HOME}/.local/share/icons/elementary/video-display.png"
som='complete'
tmp="/tmp/audiodown/$$"
logs="${dir}/status.log"
proc=$(pgrep -fc "bash $0")

[ ! -d $tmp ] && mkdir -p $tmp
[ $1 ] && url="$1" || url="$(xclip -o)"

[ -z "$url" ] && echo "Você precisa especificar a url. Abortando..." && exit

cd $tmp

padrao='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! ${url} =~ $padrao ]]; then
	notify-send -i $icone "$nome" "O link é inválido!"
    exit
else
	titulo="$(curl "$url" -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)' | iconv -f utf8 -t ascii//TRANSLIT | sed 's/[^[:alnum:]]\+/ /g')"
fi

if [[ $log -ne 0 ]]; then
    echo "---------------------------------------------------------------" >> "$logs"
    echo "Status:       INICIO" >> "$logs"
    echo "Título:       $titulo" >> "$logs"
    echo "URL:          $url" >>"$logs"
    echo "Path:         $dir" >> "$logs"
    echo "Temp:         $tmp" >> "$logs"
    echo "Processos:    $proc" >> "$logs"
fi

notify-send -i $icone "$nome" "Transferencia de: \n\n<b>$titulo</b> iniciada."
youtube-dl --extract-audio --audio-format mp3 --output "${titulo}.%(ext)s" "${url}"
status="$?"

if [[ $status -ne 0 ]]; then
    echo "---------------------------------------------------------------" >> "$logs"
    echo "Status:       ERRO" >> "$logs"
    echo "Título:       $titulo" >> "$logs"
    echo "URL:          $url" >> "$logs"
    echo "Path:         $dir" >> "$logs"
    echo "Temp:         $tmp" >> "$logs"
    echo "Processos:    $proc" >> "$logs"    
    echo "Código:       $status" >> "$logs"
    notify-send -i $icone "$nome" "Erro na transferencia de:\n\n<b>${titulo}*</b>.\n\nInstâncias: $proc"
    canberra-gtk-play -i $som
    exit
fi

if [[ $status -eq 0 ]]; then
    if [[ $log -ne 0 ]]; then
        echo "---------------------------------------------------------------" >> "$logs"
        echo "Status:       SUCESSO" >> "$logs"
        echo "Título:       $titulo" >> "$logs"
        echo "URL:          $url" >> "$logs"
        echo "Path:         $dir" >> "$logs"
        echo "Temp:         $tmp" >> "$logs"
        echo "Processos:    $proc" >> "$logs"
    fi
    arquivos=$(ls "${titulo}"* | egrep -vi '.mp3|.log')
    for i in "${arquivos[@]}"
    do
        if [ -f "$i" ]; then
            mod=$(stat -c "%Y" "$i")
            if [[ $mod > $ts ]]; then
                rm -f "$i"
            fi
        fi
    done

    if ls "${titulo}"* 1> /dev/null 2>&1; then
        if ls "${dir}/${titulo}"* 1> /dev/null 2>&1; then
            notify-send -i $icone "$nome" "Já existe um arquivo:\n\n<b>$titulo</b>\n\nEm:\n\n$dir\n\nInstâncias: $proc"
            canberra-gtk-play -i $som
        else
        	final=$SECONDS
        	diff=$((final - comeco))
            tamanho=$(stat --printf="%s" "${titulo}"*)
            tamanho="$((tamanho / 1024))"

            hora=$(printf "%02d" $((diff / 3600)))
            minuto=$(printf "%02d" $((diff / 60)))
            segundo=$(printf "%02d" $((diff % 60)))

            tempo=$((tamanho / diff))

            if [ $tamanho -gt 1024 ]; then
                tamanho="$((tamanho / 1024)) MB"
            elif [ $tamanho -gt 1048576 ]; then
                tamanho="$((tamanho / 1024 / 1024)) GB"
            else 
                tamanho="${tamanho} KB"
            fi

            notify-send -i $icone "$nome" \
            "Sucesso, vídeo salvo:\n\n<b>$titulo</b>\n\nEm:\n\n$dir\n\nTempo decorrido: ${hora}:${minuto}:${segundo}\nTamanho do arquivo: ${tamanho}\nVelocidade média: ${tempo}KBps"
            mv "${titulo}"* "$dir"
            cd $dir && rm -rf $tmp
        fi
    else
        notify-send -i $icone "$nome" "Erro na transferencia de:\n\n<b>${tmp}/${titulo}*</b>."
        canberra-gtk-play -i $som
    fi
else
    notify-send -i $icone "$nome" "Erro na transferencia de:\n\n<b>$titulo</b>"
    canberra-gtk-play -i $som
fi

