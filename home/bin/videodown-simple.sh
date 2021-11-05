#!/usr/bin/env bash
################################################################################
#                                                                              #
# Arquivo: ~/bin/videodown.sh                                                  #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 30/04/2019 13:55:09                                               #
# Modificado em: 09/08/2021 23:34:37                                           #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

[ -f $HOME/.config/user-dirs.dirs ] && source $HOME/.config/user-dirs.dirs

NOME="Video Down"
NOME_CURTO="VideoDown"
SECONDS=0
COMECO=$SECONDS
TS=$(date +"%s")
DIR="${XDG_DESKTOP_DIR:-${HOME}/desk}"
ICONE="/usr/share/icons/Newaita/devices/64/video-display.svg"
LOGS="${DIR}/status.log"
HEADER="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0"
NOTIFY="$HOME/bin/notify.sh $NOME_CURTO $ICONE $NOME_CURTO" # notify-send -h int:transient:1 -i $ICONE
YOUTUBE="youtube-dl" # "youtube-dl -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4"
HISTORY="/var/tmp/videodown.hist"
REQUIRED_APPS=("curl" "xclip" "youtube-dl")

if [ -z "$DESKTOP_SESSION" ]; then
    NOTIFY="notify-send -h int:transient:1 -i ${ICONE} ${NOME_CURTO}"
fi

for APP in "${REQUIRED_APPS[@]}"
do
   :
    if ! command -v $APP &> /dev/null
    then
        $NOTIFY "${APP} não encontrado, instale-o primeiro."
        exit
    fi
done

checkUrl() {
	local url=$1
    padrao='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    if [[ ! $url =~ $padrao ]]; then
        false
    fi
	true
}

[ ! -d "$DIR" ] && mkdir -p $DIR
[ $1 ] && url="$1" || url="$(xclip -o)"

cd $DIR

if [ -z "$url" ]; then
    $NOTIFY "O link é inválido!"
    exit 1
fi

if ! checkUrl ${url}
then
    $NOTIFY "O link é inválido!"
    exit 1
fi

$YOUTUBE "${url}"

if [[ $status -ne 0 ]]; then
    echo "---------------------------------------------------------------" >> "$LOGS"
    echo "Status:       ERRO" >> "$LOGS"
    echo "URL:          $url" >>"$LOGS"
	$NOTIFY "Erro"
    exit 1
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

$NOTIFY "Sucesso!\n\nTempo decorrido: ${hora}:${minuto}:${segundo}"
exit 0
