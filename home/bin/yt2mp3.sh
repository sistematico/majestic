#!/usr/bin/env bash
#################################################################################
#                                                                               #
# yt2mp3.sh                                                                     #
#                                                                               #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>          #
#                                                                               #
# Criado em: 07-07-2020 07:21:15                                                #
# Modificado em: 07-07-2020 07:29:23                                            #
#                                                                               #
# Este trabalho está licenciado com uma Licença Creative Commons                #
# Atribuição 4.0 Internacional                                                  #
# http://creativecommons.org/licenses/by/4.0/                                   #
#                                                                               #
#################################################################################

[ -f $HOME/.config/user-dirs.dirs ] && source $HOME/.config/user-dirs.dirs

NOME="MP3 Down"
SECONDS=0
comeco=$SECONDS
LOG=0 # 0 = Sem log, 1 = Log no arquivo erro.log
aria=1
ts=$(date +"%s")
dir="${HOME:-${XDG_MUSIC_DIR}}"
icone="${HOME}/.local/share/icons/elementary/video-display.png"
tmp="/tmp/yt2mp3/$$"
logs="${tmp}/status.log"
proc=$(pgrep -fc "bash $0")

if [ ! -d "$dir" ]; then
    dir="${HOME}/desk"
    if [ ! -d $dir ]; then
        mkdir -p $dir
    fi
fi

[ ! -d $tmp ] && mkdir -p $tmp
[ $1 ] && url="$1" || url="$(xclip -o)"
cd $tmp

padrao='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! ${url} =~ $padrao ]]; then
    notify-send -i $icone "$NOME" "O link é inválido!"
    exit
else
    #titulo="$(curl "$url" -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)' | sed 's/[^[:alnum:]]\+/ /g' | head -n1)"
    titulo="$(youtube-dl -s -f mp4 -o '%(id)s.%(ext)s' --print-json --no-warnings "$url" | jq -r '.title')"

    if [ ${#titulo} -gt 250 ]; then
        diff=$((${#titulo}-250))
        trim=$((${#titulo}-$diff))
        titulo=${titulo::-$trim}
    fi
fi

if [[ $LOG -ne 0 ]]; then
    echo "---------------------------------------------------------------" >> "$logs"
    echo "Status:       INICIO" >> "$logs"
    echo "Título:       $titulo" >> "$logs"
    echo "URL:          $url" >>"$logs"
    echo "Path:         $dir" >> "$logs"
    echo "Temp:         $tmp" >> "$logs"
    echo "Processos:    $proc" >> "$logs"
fi

notify-send -i $icone "$NOME" "Transferencia de: \n\n<b>$titulo</b> iniciada."

#youtube-dl -o "${titulo}.%(ext)s" "${url}"
youtube-dl --extract-audio --audio-format mp3 -o "${titulo}.%(ext)s" "${url}"

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
    notify-send -i $icone "$NOME" "Erro na transferencia de:\n\n<b>${titulo}*</b>.\n\nInstâncias: $proc" "$NOME" "$ICONE"
    exit
fi

if [[ $status -eq 0 ]]; then
    if [[ $LOG -ne 0 ]]; then
        echo "---------------------------------------------------------------" >> "$logs"
        echo "Status:       SUCESSO" >> "$logs"
        echo "Título:       $titulo" >> "$logs"
        echo "URL:          $url" >> "$logs"
        echo "Path:         $dir" >> "$logs"
        echo "Temp:         $tmp" >> "$logs"
        echo "Processos:    $proc" >> "$logs"
    fi
    arquivos=$(ls "${titulo}"* | egrep -vi '.mp3')
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
            notify-send -i $icone "$NOME" "Já existe um arquivo:\n\n<b>$titulo</b>\n\nEm:\n\n$dir\n\nInstâncias: $proc" "$NOME" "$ICONE"
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

            notify-send -i $icone "$NOME" "Sucesso, vídeo salvo:\n\n<b>$titulo</b>\n\nEm:\n\n$dir\n\nTempo decorrido: ${hora}:${minuto}:${segundo}\nTamanho do arquivo: ${tamanho}\nVelocidade média: ${tempo}KBps" "$NOME" "$ICONE"
            mv "${titulo}"* "$dir"
            cd "$dir"
            [ -d "$tmp" ] && rm -rf "$tmp"
        fi
    else
        notify-send -i $icone "$NOME" "Erro na transferencia de:\n\n<b>${tmp}/${titulo}*</b>.\n\nInstâncias: $proc" "$NOME" "$ICONE"
    fi
else
    notify-send -i $icone "$NOME" "Erro na transferencia de:\n\n<b>$titulo</b>\n\nInstâncias: $proc" "$NOME" "$ICONE"
fi

