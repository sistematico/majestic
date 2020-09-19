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
    #(mpv --really-quiet --profile=youtube ytdl://ytsearch10:"$params") > /dev/null 2>&1 &
	#(mpv --really-quiet --profile=youtube ytdl://ytsearch10:"$params") > /dev/null 2> /dev/null &
	(mpv --really-quiet --profile=youtube-cache ytdl://ytsearch:"$params") > /dev/null 2> /dev/null &

	#i3-msg '[class="mpv"] sticky enable' > /dev/null 2> /dev/null &

    #mpv --really-quiet --profile=youtube ytdl://ytsearch10:"$params" > /dev/null 2>&1 &
    #i3-msg '[class="mpv"] sticky enable' > /dev/null 2>&1
}

function mma() {
    #mpv --no-video --ytdl-format=bestaudio ytdl://ytsearch10:"$@"
    mpv --no-video --ytdl-format=bestaudio ytdl://ytsearch:"$@"
}

# rsync
function fullsync() {
	[ ! -d $HOME/vps/$1 ] && mkdir -p $HOME/vps/$1
	
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
mpcreload () {
	if [ $1 ]; then
		mpc rm $1
		mpc save $1
	fi
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
alias fullsync='rsync -aAXvzz --exclude={"var/lib/snapd/void","usr/libexec/openssh/ssh-keysign","var/cache/","usr/src/kernels/","var/lib/php/sessions/","var/log/journal/","var/cache/apt/","*.mp3",".local/share/Trash/",".local/share/Steam/",".cache/","var/spoll/anacron/","var/log/btmp","var/lib/systemd/random-seed","tmp/backup","usr/bin/ssh-agent","var/cache/yum","/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/var/tmp/","/lost+found",".vzfifo",".cpt_hardlink*",".autorelabel","/etc/shadow","/etc/shadow-","/etc/gshadow","/etc/gshadow-"}'
