# Vars used in functions.
STORAGE="/home/lucas"

# pnpm
npm2() {
    local subcommand

    if (( "$#" == 0 )); then 
        command pnpm
        return
    fi

    subcommand=$1; shift
    
    case $subcommand in
        i|install) 
            if [ $1 ]; then
                command pnpm add "$@"
            else
                command pnpm install
            fi
        ;;
        run)
            command pnpm "$@"
        ;;
        *)
            command pnpm "$subcommand" "$@"
            #command pnpm exec "$@"
        ;;
    esac
}

npx2() {
    command pnpm dlx "$@"
}

list_fonts() {
    fc-list | awk -F':' '{print $2}' | grep -i $1 | awk '{$1=$1};1' | uniq
}

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
    [ ! -d $STORAGE/sites/${1} ] && mkdir -p $STORAGE/sites/${1}
    rsync -aAXvzz \
        --exclude="node_modules/" \
        --exclude="*.mp4" \
        --exclude="*.mp3" \
        --exclude=".git/" \
        --exclude=".gitignore" \
        nginx@${1}:/var/www/ $STORAGE/sites/${1}/
}

function fullsitereverse() {
    if [ -d $STORAGE/sites/${1} ]; then
        rsync -aAXvzz \
            --exclude="vendor/" \
            --exclude="node_modules/" \
            --exclude="*.mp4" \
            --exclude="*.mp3" \
            --exclude=".git/" \
            --exclude=".gitignore" \
            $STORAGE/sites/${1}/var/www/${1}.radiochat.com.br nginx@${1}:/var/www/
    fi
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

    ssh root@${1} "chown -R liquidsoap /opt/liquidsoap/music/"
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
function bitrate () {
    echo `basename "$1"`: `file "$1" | sed 's/.*, \(.*\)kbps.*/\1/' | tr -d " " ` kbps
}

function twitch() {
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
function mpcr () {
    if [ $1 ]; then
        mpc rm $1
        mpc save $1
        mpc clear
        mpc load $1
        mpc play
    fi
}

function mpcl () {
    $HOME/bin/mpc.sh
}

function sudo() {
  local subcommand

  if (( "$#" == 0 )); then command sudo; return; fi    

  subcommand=$1; shift
  case $subcommand in
    mousepad)   command sudo dbus-launch mousepad "$@" ;;
    code)       command sudo dbus-launch code --user-data-dir="~/.vscode-root" "$@" ;;
    *)          command sudo "$subcommand" "$@" ;;
  esac
}

# Gnome
chshell() {
    if [ ! $1 ]; then
        echo "Temas disponíveis:"
        echo
        for tema in $(/usr/bin/ls /usr/share/themes); do
            if [ -d /usr/share/themes/${tema} ]; then
                if [ -d /usr/share/themes/${tema}/gnome-shell ]; then
                    echo $tema
                fi
            fi
        done
        for tema in $(/usr/bin/ls $HOME/.local/share/themes); do
            if [ -d $HOME/.local/share/themes/${tema} ]; then
                if [ -d $HOME/.local/share/themes/${tema}/gnome-shell ]; then
                    echo $tema
                fi
            fi
        done
        return
    fi

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
    if [ ! $1 ]; then
        echo "Temas disponíveis:"
        for tema in $(/usr/bin/ls /usr/share/themes); do
            if [ -d /usr/share/themes/${tema} ]; then
                if [ -d /usr/share/themes/${tema}/gtk-3.0 ]; then
                    echo $tema
                fi
            fi
        done
        if [ -d $HOME/.local/share/themes ]; then 
            for tema in $(/usr/bin/ls $HOME/.local/share/themes); do
                if [ -d $HOME/.local/share/themes/${tema} ]; then
                    if [ -d $HOME/.local/share/themes/${tema}/gtk-3.0 ]; then
                        echo $tema
                    fi
                fi
            done
        fi
        return
    fi

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
    if [ ! $1 ]; then
        echo "Temas disponíveis:"
        for tema in $(/usr/bin/ls /usr/share/icons); do
            if [ -d "/usr/share/icons/${tema}" ]; then
                echo $tema
            fi            
        done
        for tema in $(/usr/bin/ls $HOME/.local/share/icons); do
            if [ -d "$HOME/.local/share/icons/${tema}" ]; then
                echo $tema
            fi
        done
        return
    fi

    if [ ! -d $HOME/.local/share/icons/$1 ]; then
        if [ ! -d /usr/share/icons/$1 ]; then
            echo "Tema inválido"
            return
        fi
    fi
    echo "Trocando o tema" 
    gsettings set org.gnome.desktop.interface icon-theme "$1"
}

rsticon() {
    gsettings reset org.gnome.desktop.interface icon-theme
}

rstshell() {
    gsettings reset org.gnome.shell.extensions.user-theme name
}

rstgtk() {
    gsettings reset org.gnome.desktop.interface gtk-theme
}

rstcursor() {
    gsettings reset org.gnome.desktop.interface cursor-theme
}

dos2unix() {
    sed -i 's/^M$//' "$1"     # DOS to Unix
    #sed 's/$/^M/'            # Unix to DOS
    sed -i $'s/\r$//' "$1"    # DOS to Unix
    #sed $'s/$/\r/'           # Unix to DOS
}

remove-commit() {
    FILTER_BRANCH_SQUELCH_WARNING=1 ; \
    git filter-branch --force --index-filter \                                                                                                                                                                                                                                 [1]
        "git rm --cached --ignore-unmatch $1" \
        --prune-empty --tag-name-filter cat -- --all
}

autocommit() {
    if [ -d .git ]; then
        curl -s -L https://git.io/JzKB2 -o .git/hooks/post-commit
        chmod +x .git/hooks/post-commit
        git config --local commit.template .commit

        if [ ! -f .commit ] || [ ! -s .commit ]; then
            echo "Update automático" > .commit
        fi

        if [ ! -f .gitignore ] || [ ! -s .gitignore ]; then
            echo ".commit" > .gitignore
        else
            if ! grep -Fxq ".commit" .gitignore 2> /dev/null; then
                echo ".commit" >> .gitignore        
            fi
        fi
    fi
}
