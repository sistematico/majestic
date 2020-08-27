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
cd $dir

padrao='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! ${url} =~ $padrao ]]; then
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

$HOME/bin/notify.sh "$nome" "Início: \n\n<b>$titulo</b> iniciada." "$nome" "$icone"

if [ $aria == 1 ]; then
    # -j, --max-concurrent-downloads
    # -x, --max-connection-per-server
    # -m, --max-tries
    # -k, --min-split-size
    # -s, --split restricted by --max-connection-per-server
    # -t, --timeout

    #youtube-dl -o "${titulo}.%(ext)s" --external-downloader aria2c --external-downloader-args '-l '/tmp/aria.log' -t 10 -m 10 -c -j 2 -x 1 -s 2 -k 2M' "${url}"
    #youtube-dl -o "${titulo}.%(ext)s" --external-downloader aria2c --external-downloader-args '-l '/tmp/aria.log' -t 10 -m 10 -c -j 4 -x 2 -s 2 -k 2M' "${url}"
    #youtube-dl -o "${titulo}.%(ext)s" --external-downloader aria2c --external-downloader-args "-d ${dir}/${titulo}" "${url}"
    #youtube-dl -o "${titulo}.%(ext)s" --external-downloader aria2c "${url}"
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

    $HOME/bin/notify.sh "$nome" "Erro: <b>$titulo</b>" "$nome" "$icone"
    exit
fi

$HOME/bin/notify.sh "$nome" "Sucesso: <b>$titulo</b>" "$nome" "$icone"
exit

