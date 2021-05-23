#!/usr/bin/env bash
################################################################################
#                                                                              #
# Arquivo: ~/bin/mp3down.sh                                                    #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 30-04-2019 13:55:09                                               #
# Modificado em: 23/05/2021 13:04:44                                           #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

[ -f $HOME/.config/user-dirs.dirs ] && source $HOME/.config/user-dirs.dirs

NOME="MP3 Down"
NOME_CURTO="mp3down"
SECONDS=0
COMECO=$SECONDS
LOG=0 # 0 = Sem log, 1 = Log no arquivo
ARIA=1
TS=$(date +"%s")
DIR="${XDG_DESKTOP_DIR:-${HOME}/desk}"
ICONE="/usr/share/icons/Newaita-dark/devices/symbolic/video-display-symbolic.svg"
TMP="/tmp/mp3down/$$"
LOGS="${DIR}/status.log"
PROC=$(pgrep -fc "bash $0")
HEADER="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0"
NOTIFY="$HOME/bin/notify.sh $NOME_CURTO $ICONE $NOME_CURTO" # notify-send -h int:transient:1 -i $ICONE
YOUTUBE="youtube-dl --extract-audio --audio-format mp3" # "youtube-dl -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4"

if [ -z "$DESKTOP_SESSION" ]; then
    NOTIFY="notify-send -h int:transient:1 -i ${icone} ${nome}"
fi

[ ! -d "$DIR" ] && mkdir -p $DIR
[ ! -d $TMP ] && mkdir -p $TMP
[ $1 ] && url="$1" || url="$(xclip -o)"

cd $DIR

padrao='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! ${url} =~ $padrao ]]; then
	$NOTIFY "O link é inválido!"
    exit
else
	titulo="$(curl -A "$HEADER" "$url" -Lso - | grep -iPo '(?<=<title>)(.*)(?=</title>)' | sed 's/[^[:alnum:]]\+/ /g' | head -n1)"
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

$NOTIFY "Início: <b>$titulo</b>"

$YOUTUBE -o "${titulo}.%(ext)s" "${url}"

if [[ $status -ne 0 ]]; then
    echo "---------------------------------------------------------------" >> "$LOGS"
    echo "Status:       ERRO" >> "$LOGS"
    echo "Título:       $titulo" >> "$LOGS"
    echo "URL:          $url" >>"$LOGS"
    echo "Path:         $DIR" >> "$LOGS"
	$NOTIFY "Erro: <b>$titulo</b>"
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

$NOTIFY "Tempo decorrido: ${hora}:${minuto}:${segundo}\nTamanho do arquivo: ${tamanho}\nVelocidade média: ${tempo}KBps\n\nSucesso: <b>$titulo</b>"
exit

