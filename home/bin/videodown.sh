#!/usr/bin/env bash
################################################################################
#                                                                              #
# videodown.sh                                                                 #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 30-04-2019 01:55:09 pm                                             #
# Modificado em: 05-12-2019 4:31:28 pm                                         #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

[ -f $HOME/.config/user-dirs.dirs ] && source $HOME/.config/user-dirs.dirs

#xclip -out -selection primary | xclip -in -selection clipboard

nome="Video Down"
SECONDS=0
comeco=$SECONDS
LOG=0 # 0 = Sem log, 1 = Log no arquivo erro.log
aria=1
ts=$(date +"%s")
dir="${XDG_DESKTOP_DIR:-${HOME}/desk}"
icone="${HOME}/.local/share/icons/elementary/video-display.png"
tmp="/tmp/videodown/$$"
logs="${dir}/status.log"
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
	#/usr/bin/notify-send -i $icone "Video Downloader" "O link é inválido!"
	$HOME/bin/notify.sh "Video Down" "O link é inválido!" "$nome" "$icone"
    exit
else
	#titulo="$(curl "$url" -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)' | iconv -f utf8 -t ascii//TRANSLIT | sed 's/[^[:alnum:]]\+/ /g')"
	titulo="$(curl "$url" -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)' | sed 's/[^[:alnum:]]\+/ /g' | head -n1)"

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

#/usr/bin/notify-send -i $icone "Video Downloader" "Transferencia de: \n\n<b>$titulo</b> iniciada."
$HOME/bin/notify.sh "Video Downloader" "Transferencia de: \n\n<b>$titulo</b> iniciada." "$nome" "$icone"

if [ $aria == 1 ]; then
    # -j, --max-concurrent-downloads
    # -x, --max-connection-per-server
    # -m, --max-tries
    # -k, --min-split-size
    # -s, --split restricted by --max-connection-per-server
    # -t, --timeout

    #youtube-dl -o "${titulo}.%(ext)s" --external-downloader aria2c --external-downloader-args '-l '/tmp/aria.log' -t 10 -m 10 -c -j 2 -x 1 -s 2 -k 2M' "${url}"
    #youtube-dl -o "${titulo}.%(ext)s" --external-downloader aria2c --external-downloader-args '-l '/tmp/aria.log' -t 10 -m 10 -c -j 4 -x 2 -s 2 -k 2M' "${url}"
    #youtube-dl -o "${titulo}.%(ext)s" --external-downloader aria2c --external-downloader-args '-d ${dir}' "${url}"
    youtube-dl -o "${titulo}.%(ext)s" --external-downloader aria2c "${url}"
    status="$?"
else
    youtube-dl -o "${titulo}.%(ext)s" "${url}"
    status="$?"
fi

if [[ $status -ne 0 ]]; then
    echo "---------------------------------------------------------------" >> "$logs"
    echo "Status:       ERRO" >> "$logs"
    echo "Título:       $titulo" >> "$logs"
    echo "URL:          $url" >> "$logs"
    echo "Path:         $dir" >> "$logs"
    echo "Temp:         $tmp" >> "$logs"
    echo "Processos:    $proc" >> "$logs"    
    echo "Código:       $status" >> "$logs"
    $HOME/bin/notify.sh "Video Downloader" "Erro na transferencia de:\n\n<b>${titulo}*</b>" "$nome" "$icone"
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
    arquivos=$(ls "${titulo}"* | egrep -vi '.mp4|.avi|.mkv|.log')
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
            $HOME/bin/notify.sh "Video Downloader" "Já existe um arquivo:\n\n<b>$titulo</b>\n\nEm:\n\n$dir" "$nome" "$icone"
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

            $HOME/bin/notify.sh "Video Downloader" "Sucesso, vídeo salvo:\n\n<b>$titulo</b>\n\nEm:\n\n$dir\n\nTempo decorrido: ${hora}:${minuto}:${segundo}\nTamanho do arquivo: ${tamanho}\nVelocidade média: ${tempo}KBps" "$nome" "$icone"
            mv "${titulo}"* "$dir"
            cd "$dir"
            [ -d "$tmp" ] && rm -rf "$tmp"
        fi
    else
        $HOME/bin/notify.sh "Video Downloader" "Erro na transferencia de:\n\n<b>${tmp}/${titulo}*</b>.\n\nInstâncias: $proc" "$nome" "$icone"
    fi
else
    $HOME/bin/notify.sh "Video Downloader" "Erro na transferencia de:\n\n<b>$titulo</b>\n\nInstâncias: $proc" "$nome" "$icone"
fi

