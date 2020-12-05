#!/usr/bin/env bash
################################################################################
#                                                                              #
# videodown.sh                                                                 #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 30-04-2019 13:55:09                                               #
# Modificado em: 02/09/2020 18:24:49                                           #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

[ -f $HOME/.config/user-dirs.dirs ] && source $HOME/.config/user-dirs.dirs

DISTRO="arch"
SECONDS=0
comeco=$SECONDS
<<<<<<< HEAD
LOG=0 # 0 = Sem log, 1 = Log no arquivo
ARIA=1
=======
LOG=1 # 0 = Sem log, 1 = Log no arquivo
aria=1
>>>>>>> cb2eb936c3fb416f49d85a49c31cf7f97fd6c294
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

if [ -f /etc/os-release ]; then
    source /etc/os-release
    [ ! -z "$ID" ] && DISTRO="$ID"
fi

case $DISTRO in
    debian)
        notifycommand="$HOME/bin/notify.sh VideoDown ${icone}"
        break
    ;;
    *)
        notifycommand="notify-send -h int:transient:1 -i $icone"
    ;;
esac

[ ! -d $tmp ] && mkdir -p $tmp
[ $1 ] && url="$1" || url="$(xclip -o)"
cd $dir

padrao='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! ${url} =~ $padrao ]]; then
<<<<<<< HEAD
	$notifycommand "Video Down" "O link é inválido!"
=======
	notify-send -h int:transient:1 -i "$icone" "Video Down" "O link é inválido!"
>>>>>>> cb2eb936c3fb416f49d85a49c31cf7f97fd6c294
    exit
else
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

<<<<<<< HEAD
$notifycommand "Video Down" "Início: <b>$titulo</b>"
=======
notify-send -h int:transient:1 -i "$icone" "Video Down" "Início: <b>$titulo</b>"
>>>>>>> cb2eb936c3fb416f49d85a49c31cf7f97fd6c294

if [ $ARIA == 1 ]; then
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
    echo "URL:          $url" >>"$logs"
    echo "Path:         $dir" >> "$logs"

<<<<<<< HEAD
	$notifycommand "Video Down" "Erro: <b>$titulo</b>"
=======
	notify-send -h int:transient:1 -i "$icone" "Video Down" "Erro: <b>$titulo</b>"
>>>>>>> cb2eb936c3fb416f49d85a49c31cf7f97fd6c294
    exit
fi

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

if [[ $LOG -ne 0 ]]; then
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "$logs"
    echo "Status:       SUCESSO" >> "$logs"
    echo "Título:       $titulo" >> "$logs"
    echo "URL:          $url" >>"$logs"
    echo "Path:         $dir" >> "$logs"
    echo "Temp:         $tmp" >> "$logs"
    echo "Processos:    $proc" >> "$logs"
    echo >> "$logs"
    echo "Tempo decorrido: ${hora}:${minuto}:${segundo}" >> "$logs"
    echo "Tamanho do arquivo: ${tamanho}\nVelocidade média: ${tempo}KBps" >> "$logs"
    echo "Velocidade média: ${tempo}KBps" >> "$logs"
fi

<<<<<<< HEAD
$notifycommand "Video Down" "Sucesso: <b>$titulo</b>\n\nTempo decorrido: ${hora}:${minuto}:${segundo}\nTamanho do arquivo: ${tamanho}\nVelocidade média: ${tempo}KBps"
=======
notify-send -h int:transient:1 -i "$icone" "Video Down" "Sucesso: <b>$titulo</b>\n\nTempo decorrido: ${hora}:${minuto}:${segundo}\nTamanho do arquivo: ${tamanho}\nVelocidade média: ${tempo}KBps"
>>>>>>> cb2eb936c3fb416f49d85a49c31cf7f97fd6c294
exit

