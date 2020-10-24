#!/bin/bash

declare -a ARQUIVOS

EPOCH=$(date +%s)

# https://wallhaven.cc/settings/account
APIKEY=""

# Where should the Wallpapers be stored?
LOCATION=${HOME}/img/wallhaven

# How many Wallpapers should be downloaded, should be multiples of the
# value in the THUMBS Variable
WPNUMBER=48

# What page to start downloading at, default and minimum of 1.
STARTPAGE=1

# Type standard (newest, oldest, random, hits, mostfav), search, collections
# (for now only the default collection), useruploads (if selected, only
# FILTER variable will change the outcome)
TYPE=standard

# From which Categories should Wallpapers be downloaded, first number is
# for General, second for Anime, third for People, 1 to enable category,
# 0 to disable it
CATEGORIES=100

# filter wallpapers before downloading, first number is for sfw content,
# second for sketchy content, third for nsfw content, 1 to enable,
# 0 to disable
FILTER=110

# Which Resolutions should be downloaded, leave empty for all
# separate multiple resolutions with , eg. 1920x1080,1920x1200
RESOLUTION="1920x1080"

# alternatively specify a minimum resolution
ATLEAST=

# Which aspectratios should be downloaded, leave empty for all
# (possible values: 4x3, 5x4, 16x9, 16x10, 21x9, 32x9, 48x9, 9x16, 10x16)
ASPECTRATIO="16x9"

# relevance, random, date_added, views, favorites, toplist, toplist-beta
MODE=random

# if MODE is set to toplist show the toplist for the given timeframe
# possible values: 1d (last day), 3d (last 3 days), 1w (last week),
# 1M (last month), 3M (last 3 months), 6M (last 6 months), 1y (last year)
TOPRANGE=

# desc, asc
ORDER=desc

# Collections, only used if TYPE = collections
# specify the name of the collection you want to download
# Default is the default collection name on wallhaven
# If you want to download your own Collections make sure USR is set to your username
# If you want to download someone elses public collection enter the name here
# and the username under USR
# Please note that the only filter option applied to Collections is the Number
# of Wallpapers to download, there is no filter for resolution, purity, ...
COLLECTION="Default"

# Searchterm, only used if TYPE = search
# you can also search by tags, use id:TAGID
# to get the tag id take a look at: https://wallhaven.cc/tags/
# for example: to search for nature related wallpapers via the nature tag
# instead of the keyword use QUERY="id:37"
QUERY=""

# values are RGB (000000 = black, ffffff = white, ff0000 = red, ...)
COLOR=""

# 0 for no separate folder, 1 for separate subfolder
SUBFOLDER=0

# used for TYPE=useruploads and TYPE=collections
USR="AksumkA"

# custom thumbnails per page
# changeable here: https://wallhaven.cc/settings/browsing
# valid values: 24, 32, 64
# if set to 32 or 64 you need to provide an api key
THUMBS=24

# dependencies=(wget jq sed)

# arg1: API key
function setAPIkeyHeader {
    httpHeader="X-API-Key: $APIKEY"
}

# downloads Page with Thumbnails
function getPage {
    WGET -O tmp "https://wallhaven.cc/api/v1/$1"
}

# downloads all the wallpaper from a wallpaperfile
# arg1: the file containing the wallpapers
function downloadWallpapers {
    for ((i=0; i<THUMBS; i++))
    do
        imgURL=$(jq -r ".data[$i].path" tmp)
        [[ $page -gt $(jq -r ".meta.last_page" tmp) ]] && downloadEndReached=true

        filename=$(echo "$imgURL"| sed "s/.*\///" )
        if ! grep -w "$filename" /var/tmp/downloaded.txt >/dev/null
        then
            if WGET "$imgURL"
            then
                echo "$filename" >> /var/tmp/downloaded.txt
            fi
        fi
    done
}

# wrapper for wget with some default arguments
# arg0: additional arguments for wget (optional)
# arg1: file to download
#
function WGET {
    wget -q --header="$httpHeader" --keep-session-cookies --save-cookies cookies.txt --load-cookies cookies.txt "$@"
}

# optionally create a separate subfolder for each search query
# might download duplicates as each search query has its own list of
# downloaded wallpapers
if [ "$TYPE" == search ] && [ "$SUBFOLDER" == 1 ]
then
    LOCATION+=/$(echo "$QUERY" | sed -e "s/ /_/g" -e "s/+/_/g" -e  "s/\\//_/g")
fi

# creates Location folder if it does not exist
[ ! -d "$LOCATION" ] && mkdir -p "$LOCATION"
cd "$LOCATION" || exit
[ ! -f /var/tmp/downloaded.txt ] && touch /var/tmp/downloaded.txt

# set auth header only when it is required ( for example to download your
# own collections or nsfw content... )
if  [ "$FILTER" == 001 ] || [ "$FILTER" == 011 ] || [ "$FILTER" == 111 ] || [ "$TYPE" == collections ] || [ "$THUMBS" != 24 ]
then
    setAPIkeyHeader "$APIKEY"
fi

if [ "$TYPE" == standard ]
then
    for (( count=0, page="$STARTPAGE"; count< "$WPNUMBER"; count=count+"$THUMBS", page=page+1 ));
    do
        #printf "Download Page %s\\n" "$page"
        s1="search?page=$page&categories=$CATEGORIES&purity=$FILTER&"
        s1+="atleast=$ATLEAST&resolutions=$RESOLUTION&ratios=$ASPECTRATIO"
        s1+="&sorting=$MODE&order=$ORDER&topRange=$TOPRANGE&colors=$COLOR"
        getPage "$s1"
        #printf "\\t- done!\\n"
        #printf "Download Wallpapers from Page %s\\n" "$page"
        downloadWallpapers
        #printf "\\t- done!\\n"
        [ "$downloadEndReached" = true ] && break
    done

elif [ "$TYPE" == search ] || [ "$TYPE" == useruploads ]
then
    for ((  count=0, page="$STARTPAGE"; count< "$WPNUMBER"; count=count+"$THUMBS", page=page+1 ));
    do
        #printf "Download Page %s\\n" "$page"
        s1="search?page=$page&categories=$CATEGORIES&purity=$FILTER&"
        s1+="atleast=$ATLEAST&resolutions=$RESOLUTION&ratios=$ASPECTRATIO"
        s1+="&sorting=$MODE&order=desc&topRange=$TOPRANGE&colors=$COLOR"
        if [ "$TYPE" == search ]
        then
            s1+="&q=$QUERY"
        elif [ "$TYPE" == useruploads ]
        then
            s1+="&q=@$USR"
        fi

        getPage "$s1"
        #printf "\\t- done!\\n"
        #printf "Download Wallpapers from Page %s\\n" "$page"
        downloadWallpapers
        #printf "\\t- done!\\n"
        [ "$downloadEndReached" = true ] && break
    done

elif [ "$TYPE" == collections ]
then
    if [ "$USR" == "" ]
    then
        printf "Please check the value specified for USR\\n"
        printf "to download a Collection it is necessary to specify a User\\n\\n"
        printf "Press any key to exit\\n"
        read -r
        exit
    fi

    getPage "collections/$USR"

    i=0
    while
        label=$(jq -e -r ".data[$i].label" tmp)
        id=$(jq -e -r ".data[$i].id" tmp)
        collectionsize=$(jq -e -r ".data[$i].count" tmp)
        [[ $label != "$COLLECTION" && $label != null ]]
    do
        (( i++ ))
    done

    if [ -z "$id" ]
    then
        printf "Please check the value specified for COLLECTION\\n"
        printf "it seems that a collection with the name \"%s\" does not exist\\n\\n" \
                "$COLLECTION"
        printf "Press any key to exit\\n"
        read -r
        exit
    fi

    for ((  count=0, page="$STARTPAGE";
            count< "$WPNUMBER" && count< "$collectionsize";
            count=count+"$THUMBS", page=page+1 ));
    do
        printf "Download Page %s\\n" "$page"
        getPage "collections/$USR/$id?page=$page"
        printf "\\t- done!\\n"
        printf "Download Wallpapers from Page %s\\n" "$page"
        downloadWallpapers
        printf "\\t- done!\\n"
    done
else
    printf "error in TYPE please check Variable\\n"
fi

for f in $LOCATION/*.jpg;
do
    echo "Mod: $f $(stat --printf=%Y $f)"

    if [ $(stat --printf=%Y $f) -gt $EPOCH ]
    then
        ARQUIVOS+=("$f")
    fi
done

echo "Epoch: $EPOCH"

size=${#ARQUIVOS[@]}
echo $size

if [ $size -gt 1 ]
then
    index=$(($RANDOM % $size))

    if [ "$(file -b --mime-type ${ARQUIVOS[$index]})" == "image/jpeg" ]; then
        if [ "$DESKTOP_SESSION" == "mate" ]; then
            gsettings set org.mate.background picture-filename "${ARQUIVOS[$index]}"
        elif [ "$DESKTOP_SESSION" == "gnome" ]; then
            gsettings set org.gnome.desktop.background picture-uri "file://${ARQUIVOS[$index]}"
        else
            feh --bg-fill "${ARQUIVOS[$index]}"
        fi
    fi
fi

rm -f cookies.txt
