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

NOME="Video Down"
DISTRO="arch"
SECONDS=0
COMECO=$SECONDS
LOG=0 # 0 = Sem log, 1 = Log no arquivo
ARIA=1
TS=$(date +"%s")
DIR="${XDG_DESKTOP_DIR:-${HOME}/desk}"
#ICONE="${HOME}/.local/share/icons/Elementary/devices/48/video-display.svg"
ICONE="${HOME}/.local/share/icons/Newaita-dark/devices/symbolic/video-display-symbolic.svg"
TMP="/tmp/videodown/$$"
LOGS="${DIR}/status.log"
PROC=$(pgrep -fc "bash $0")

if [ ! -d "$DIR" ]; then
	DIR="${HOME}/desk"
	if [ ! -d $DIR ]; then
		mkdir -p $DIR
	fi
fi

notifycommand="$HOME/bin/notify.sh VideoDown ${ICONE}"
#notifycommand="notify-send -h int:transient:1 -i $ICONE"

[ ! -d $TMP ] && mkdir -p $TMP
[ $1 ] && url="$1" || url="$(xclip -o)"
cd $DIR

padrao='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! ${url} =~ $padrao ]]; then
	$notifycommand "Video Down" "O link é inválido!"
    exit
else
    #titulo=$(curl "$url" -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)')
	titulo="$(curl "$url" -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)' | sed 's/[^[:alnum:]]\+/ /g' | head -n1)"

	if [ ${#titulo} -gt 250 ]; then
		diff=$((${#titulo}-250))
		trim=$((${#titulo}-$diff))
		titulo=${titulo::-$trim}
	fi
fi

if [[ $LOG -ne 0 ]]; then
    echo "---------------------------------------------------------------" >> "$LOGS"
    echo "Status:       INICIO" >> "$LOGS"
    echo "Título:       $titulo" >> "$LOGS"
    echo "URL:          $url" >>"$LOGS"
    echo "Path:         $DIR" >> "$LOGS"
    echo "Temp:         $TMP" >> "$LOGS"
    echo "Processos:    $PROC" >> "$LOGS"
fi

$notifycommand "Video Down" "Início: <b>$titulo</b>"

if [ $ARIA == 1 ]; then
    youtube-dl -o "${titulo}.%(ext)s" --external-downloader aria2c "${url}"
    status="$?"
else
    youtube-dl -o "${titulo}.%(ext)s" "${url}"
    status="$?"
fi

if [[ $status -ne 0 ]]; then
    echo "---------------------------------------------------------------" >> "$LOGS"
    echo "Status:       ERRO" >> "$LOGS"
    echo "Título:       $titulo" >> "$LOGS"
    echo "URL:          $url" >>"$LOGS"
    echo "Path:         $DIR" >> "$LOGS"

	$notifycommand "Video Down" "Erro: <b>$titulo</b>"
    exit
fi

final=$SECONDS
diff=$((final - COMECO))
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
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "$LOGS"
    echo "Status:       SUCESSO" >> "$LOGS"
    echo "Título:       $titulo" >> "$LOGS"
    echo "URL:          $url" >>"$LOGS"
    echo "Path:         $DIR" >> "$LOGS"
    echo "Temp:         $TMP" >> "$LOGS"
    echo "Processos:    $PROC" >> "$LOGS"
    echo >> "$LOGS"
    echo "Tempo decorrido: ${hora}:${minuto}:${segundo}" >> "$LOGS"
    echo "Tamanho do arquivo: ${tamanho}\nVelocidade média: ${tempo}KBps" >> "$LOGS"
    echo "Velocidade média: ${tempo}KBps" >> "$LOGS"
fi

$notifycommand "Video Down" "Tempo decorrido: ${hora}:${minuto}:${segundo}\nTamanho do arquivo: ${tamanho}\nVelocidade média: ${tempo}KBps\n\nSucesso: <b>$titulo</b>"
exit

