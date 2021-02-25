# Vars used in functions.
STORAGE="$HOME/storage"

function cpr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 "$@"
} 
function mvr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files "$@"
}

# Docker
dlg () {
  docker exec -it $1 bash
}

dbl () {
    docker build -t $1 .
}

dru () {
    docker run --name $1 --network host -itd $2
}

# mpv
function mm() {
	params=\"$@\"
	killall mpv 1> /dev/null 2> /dev/null
	sleep 1
	(mpv --really-quiet --profile=youtube-cache ytdl://ytsearch:"$params") > /dev/null 2> /dev/null &
}

function mma() {
    mpv --no-video --ytdl-format=bestaudio ytdl://ytsearch:"$@" # ytdl://ytsearch10:"$@"
}

# rsync
function fullsync() {
	[ ! -d $STORAGE/vps/$1 ] && mkdir -p $STORAGE/vps/${1}
	
    rsync -aAXvzz \
    --exclude-from "$HOME/.config/rsync-excludes.list" \
    root@${1}:/ $STORAGE/vps/${1}/
}

function fullsite() {
    [ ! -d $STORAGE/sites/${1}/var/www ] && mkdir -p $STORAGE/sites/${1}/var/www
	rsync -aAXvzz \
    --exclude="node_modules/" \
    --exclude="*.mp4" \
    --exclude="*.mp3" \
    --exclude=".git/" \
    --exclude=".gitignore" \
    nginx@${1}:/var/www/ $STORAGE/sites/${1}/var/www/
}

function songdown() {
    [ ! -d $STORAGE/audio/${1} ] && mkdir -p $STORAGE/audio/${1}

    rsync -aAXvzz \
    nginx@${1}:/opt/liquidsoap/music/ \
	$STORAGE/audio/${1}/ $2

    find $STORAGE/audio/${1} -type d -exec chmod 755 '{}' \; 
	find $STORAGE/audio/${1} -type f -exec chmod 644 '{}' \;
}

function songup() {
    [ ! -d $STORAGE/audio/${1} ] && mkdir -p $HOME/audio/${1}   

    if [ -d $STORAGE/audio/${1} ]; then 
		find $STORAGE/audio/${1} -type d -exec chmod 755 '{}' \; 
		find $STORAGE/audio/${1} -type f -exec chmod 644 '{}' \;
	fi

    rsync -aAXvzz \
    $STORAGE/audio/${1}/ \
    nginx@${1}:/opt/liquidsoap/music/ $2
}

function checkiso() {
	if [ -f SHA512SUMS ]; then
        sha512sum --ignore-missing -c SHA512SUMS
        return
	fi
	
	if [ -f SHA256SUMS ]; then
        sha256sum --ignore-missing -c SHA256SUMS
        return
	fi
}

# mp3
bitrate () {
    echo `basename "$1"`: `file "$1" | sed 's/.*, \(.*\)kbps.*/\1/' | tr -d " " ` kbps
}

twitch() {
     INRES="1920x1080" # input resolution
     OUTRES="1920x1080" # output resolution
     FPS="15" # target FPS
     GOP="30" # i-frame interval, should be double of FPS, 
     GOPMIN="15" # min i-frame interval, should be equal to fps, 
     THREADS="2" # max 6
     CBR="1000k" # constant bitrate (should be between 1000k - 3000k)
     QUALITY="ultrafast"  # one of the many FFMPEG preset
     AUDIO_RATE="44100"
     STREAM_KEY=$(cat $HOME/.twitch) # use the terminal command Streaming streamkeyhere to stream your video to twitch or justin
     SERVER="live-sao" # twitch server in frankfurt, see http://bashtech.net/twitch/ingest.php for list
     
     ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 -f pulse -i 0 -f flv -ac 2 -ar $AUDIO_RATE \
       -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
       -s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal \
       -bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"
 }

# mpc
mpcr () {
	if [ $1 ]; then
		mpc rm $1
		mpc save $1
		mpc clear
		mpc load $1
		mpc play
	fi
}

mpcl () {
	$HOME/bin/mpc.sh
}

sudo() {
  local subcommand

  if (( "$#" == 0 )); then command sudo; return; fi    

  subcommand=$1; shift
  case $subcommand in
    mousepad) command sudo dbus-launch mousepad "$@" ;;
    *)        command sudo "$subcommand" "$@" ;;
  esac
}

# Gnome
chshell() {
    if [ ! -d $HOME/.local/share/themes/$1/gnome-shell ]; then
        if [ ! -d /usr/share/themes/$1/gnome-shell ]; then
            echo "Tema inválido"
            return
        fi
    fi
    echo "Trocando o tema"
    gsettings set org.gnome.shell.extensions.user-theme name "$1"
}

chgtk() {
    if [ ! -d $HOME/.local/share/themes/$1/gtk-3.0 ]; then
        if [ ! -d /usr/share/themes/$1/gtk-3.0 ]; then
            echo "Tema inválido"
            return
        fi
    fi
    echo "Trocando o tema"    
    gsettings set org.gnome.desktop.interface gtk-theme "$1"
}

chicon() {
    if [ ! -d $HOME/.local/share/icons/$1 ]; then
        if [ ! -d /usr/share/icons/$1 ]; then
            echo "Tema inválido"
            return
        fi
    fi
    echo "Trocando o tema" 
    gsettings set org.gnome.desktop.interface icon-theme "$1"
}


