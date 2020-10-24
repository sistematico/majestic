#!/bin/bash
# dependencies: wget jq sed

LOCATION=${HOME}/img/wallhaven

# How many Wallpapers should be downloaded, should be multiples of the value in the THUMBS Variable
WPNUMBER=48

STARTPAGE=1

# Type standard (newest, oldest, random, hits, mostfav), search, collections
# (for now only the default collection), useruploads (if selected, only
# FILTER variable will change the outcome)
TYPE=standard
CATEGORIES=100 # General, Anime, People, 1 to enable, 0 to disable
FILTER=110 # sfw, sketchy, nsfw, 1 to enable 0 to disable
RESOLUTION="1920x1080" # Empty for all, separate multiple resolutions with , eg. 1920x1080,1920x1200
ASPECTRATIO="16x9" # Empty for all (possible values: 4x3, 5x4, 16x9, 16x10, 21x9, 32x9, 48x9, 9x16, 10x16)
MODE=random # relevance, random, date_added, views, favorites, toplist, toplist-beta

# if MODE is set to toplist show the toplist for the given timeframe
# possible values: 1d (last day), 3d (last 3 days), 1w (last week),
# 1M (last month), 3M (last 3 months), 6M (last 6 months), 1y (last year)
TOPRANGE=
ORDER=desc # desc, asc

# Collections, only used if TYPE = collections
# specify the name of the collection you want to download
# Default is the default collection name on wallhaven
# If you want to download your own Collections make sure USR is set to your username
# If you want to download someone elses public collection enter the name here
# and the username under USR
# Please note that the only filter option applied to Collections is the Number
# of Wallpapers to download, there is no filter for resolution, purity, ...
COLLECTION="Default"
QUERY="" # Searchterm, only used if TYPE = search, you can also search by tags, use id:TAGID, to get the tag id take a look at: https://wallhaven.cc/tags/, for example: to search for nature related wallpapers via the nature tag, instead of the keyword use QUERY="id:37"
COLOR="" # (000000 = black, ffffff = white, ff0000 = red, ...)
SUBFOLDER=0
THUMBS=24 # changeable here: https://wallhaven.cc/settings/browsing, valid values: 24, 32, 64, if set to 32 or 64 you need to provide an api key

randomWallpaper() {
    wallpaper=$(ls $LOCATION/*.jpg | shuf -n1)

    if [ "$(file -b --mime-type $wallpaper)" == "image/jpeg" ]; then
        if [ "$DESKTOP_SESSION" == "mate" ]; then
            gsettings set org.mate.background picture-filename "${wallpaper}"
        elif [ "$DESKTOP_SESSION" == "gnome" ]; then
            gsettings set org.gnome.desktop.background picture-uri "file://${wallpaper}"
        else
            feh --bg-fill "${wallpaper}"
        fi
        echo "$wallpaper" > $HOME/.wallhaven
    fi
    exit 0
}

if [ "$1" == "--delete" ]; then
    if [ -f $HOME/.wallhaven ] && [ -f $(cat $HOME/.wallhaven) ]; then
        rm -f $(cat $HOME/.wallhaven)
        randomWallpaper
    fi
fi

if [ "$1" == "--random" ]; then
    randomWallpaper
fi

# downloads Page with Thumbnails
function getPage {
    WGET -O /var/tmp/download.lst "https://wallhaven.cc/api/v1/$1"
}

function downloadWallpapers {
    for ((i=0; i<THUMBS; i++)); do
        imgURL=$(jq -r ".data[$i].path" /var/tmp/download.lst)
        [[ $page -gt $(jq -r ".meta.last_page" /var/tmp/download.lst) ]] && downloadEndReached=true

        filename=$(echo "$imgURL"| sed "s/.*\///" )
        if ! grep -w "$filename" /var/tmp/downloaded.txt >/dev/null; then
            if WGET "$imgURL"; then
                echo "$filename" >> /var/tmp/downloaded.txt
            fi
        fi
    done
}

function WGET {
    wget -q --header="$httpHeader" --keep-session-cookies --save-cookies /var/tmp/cookies.txt --load-cookies /var/tmp/cookies.txt "$@"
}

if [ "$TYPE" == search ] && [ "$SUBFOLDER" == 1 ]; then
    LOCATION+=/$(echo "$QUERY" | sed -e "s/ /_/g" -e "s/+/_/g" -e  "s/\\//_/g")
fi

[ ! -d "$LOCATION" ] && mkdir -p "$LOCATION"
cd "$LOCATION" || exit
[ ! -f /var/tmp/downloaded.txt ] && touch /var/tmp/downloaded.txt

if [ "$TYPE" == standard ]
then
    for (( count=0, page="$STARTPAGE"; count< "$WPNUMBER"; count=count+"$THUMBS", page=page+1 ));
    do
        s1="search?page=$page&categories=$CATEGORIES&purity=$FILTER&resolutions=$RESOLUTION&ratios=$ASPECTRATIO&sorting=$MODE&order=$ORDER&topRange=$TOPRANGE&colors=$COLOR"
        getPage "$s1"
        downloadWallpapers
        [ "$downloadEndReached" = true ] && break
    done

elif [ "$TYPE" == search ] || [ "$TYPE" == useruploads ]
then
    for (( count=0, page="$STARTPAGE"; count< "$WPNUMBER"; count=count+"$THUMBS", page=page+1 ));
    do
        getPage "search?page=$page&categories=$CATEGORIES&purity=$FILTER&resolutions=$RESOLUTION&ratios=$ASPECTRATIO&sorting=$MODE&order=desc&topRange=$TOPRANGE&colors=$COLOR&q=$QUERY"
        downloadWallpapers
        [ "$downloadEndReached" = true ] && break
    done
else
    printf "error in TYPE please check Variable\\n"
fi

wallpaper=$(ls -t1 $LOCATION/*.jpg | head -n3 | shuf -n1)

if [ "$(file -b --mime-type $wallpaper)" == "image/jpeg" ]; then
    if [ "$DESKTOP_SESSION" == "mate" ]; then
        gsettings set org.mate.background picture-filename "${wallpaper}"
    elif [ "$DESKTOP_SESSION" == "gnome" ]; then
        gsettings set org.gnome.desktop.background picture-uri "file://${wallpaper}"
    else
        feh --bg-fill "${wallpaper}"
    fi
fi

rm -f $LOCATION/*.1
rm -f /var/tmp/cookies.txt
