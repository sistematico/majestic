#!/bin/bash
#
# Get a random wallpaper from http://wallhaven.cc and install it
# (uses nitrogen by default).
#
# (c) 2016 Oleksandr Dunayevskyy <oleksandr.dunayevskyy@gmail.com>
# https://github.com/aldn/wallpaper-wallhaven-dl
#
# Heavily based on https://github.com/macearl/Wallhaven-Downloader
#

WORKING_DIR=$(mktemp -d)
WALLPAPER_FILE=$WORKING_DIR/wallpaper.jpg
USERAGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.99 Safari/537.36"

#####################################
###   Needed for NSFW/Favorites   ###
#####################################
# Enter your Username
USER=""
# Enter your password
PASS=""
#####################################
### End needed for NSFW/Favorites ###
#####################################

#####################################
###     Configuration Options     ###
#####################################
# Command which installs the wallpaper
if [ "$DESKTOP_SESSION" == "mate" ]; then 
    SET_WALLPAPER_COMMAND="gsettings set org.mate.background picture-filename $WALLPAPER_FILE"
elif [ "$DESKTOP_SESSION" == "gnome" ]; then 
    SET_WALLPAPER_COMMAND="gsettings set org.gnome.desktop.background picture-uri file://${WALLPAPER_FILE}"
else
    SET_WALLPAPER_COMMAND="nitrogen --set-zoom-fill $WALLPAPER_FILE"
fi  
# What page to start downloading at, default and minimum of 1.
STARTPAGE=1
# Number of pages to download, starting from $STARTPAGE
NUMPAGES=1
# Type standard (newest, oldest, random, hits, mostfav), search, favorites (for now only the default collection), useruploads (if selected, only FILTER variable will change the outcome)
TYPE=standard
# From which Categories should Wallpapers be downloaded, first number is for General, second for Anime, third for People, 1 to enable category, 0 to disable it
CATEGORIES=100
# filter wallpapers before downloading, first number is for sfw content, second for sketchy content, third for nsfw content, 1 to enable, 0 to disable
FILTER=110
# Which Resolutions should be downloaded, leave empty for all (most common resolutions possible, for details see wallhaven site), separate multiple resolutions with , eg. 1920x1080,1920x1200
RESOLUTION=
# Which aspectratios should be downloaded, leave empty for all (possible values: 4x3, 5x4, 16x9, 16x10, 32x9, 48x9), separate mutliple ratios with , eg. 4x3,16x9
ASPECTRATIO=
# Which Type should be displayed (relevance, random, date_added, views, favorites)
MODE=views
# How should the wallpapers be ordered (desc, asc)
ORDER=desc
# Searchterm, only used if TYPE = search
QUERY="nature"
# User from which wallpapers should be downloaded (only used for TYPE=useruploads)
USR=
#####################################
###   End Configuration Options   ###
#####################################

#
# logs in to the wallhaven website to give the user more functionality
# requires 2 arguments:
# arg1: username
# arg2: password
#
function login {
    # checking parameters -> if not ok print error and exit script
    if [ $# -lt 2 ] || [ $1 == '' ] || [ $2 == '' ]; then
        printf "Please check the needed Options for NSFW Content (username and password)\n\n"
        printf "For further Information see Section 13\n\n"
        printf "Press any key to exit\n"
        read
        exit
    fi

    # everythings ok --> login
    wget -q -U "$USERAGENT" --keep-session-cookies --save-cookies=cookies.txt --referer=https://alpha.wallhaven.cc https://alpha.wallhaven.cc/auth/login
    token="$(cat login | grep 'name="_token"' | sed 's:.*value="::' | sed 's/.\{2\}$//')"
    wget -q -U "$USERAGENT" --load-cookies=cookies.txt --keep-session-cookies --save-cookies=cookies.txt --referer=https://alpha.wallhaven.cc/auth/login --post-data="_token=$token&username=$USER&password=$PASS" https://alpha.wallhaven.cc/auth/login
} # /login

#
# downloads Page with Thumbnails
#
function getPage {
    # checking parameters -> if not ok print error and exit script
    if [ $# -lt 1 ]; then
        printf "getPage expects at least 1 argument\n"
        printf "arg1:    parameters for the wget -q command\n\n"
        printf "press any key to exit\n"
        read
        exit
    fi

    # parameters ok --> get page
    wget -q -U "$USERAGENT" --keep-session-cookies --save-cookies=cookies.txt --load-cookies=cookies.txt --referer=https://alpha.wallhaven.cc -O tmp "https://alpha.wallhaven.cc/$1"
} # /getPage

function getImgUrls()
{
    URLSFORIMAGES="$(cat tmp | grep -o '<a class="preview" href="https://alpha.wallhaven.cc/wallpaper/[0-9]*"' | sed  's .\{24\}  ')"
    echo $URLSFORIMAGES >> urls
}

function downloadWallpaper {
    imgURL=$(echo $1 | xargs)
    # "https://alpha.wallhaven.cc/wallpaper/74042"  --> 74042
    number="$(echo $imgURL | cut -c 38-)"
    wget -q -U "$USERAGENT" --keep-session-cookies --save-cookies=cookies.txt --load-cookies=cookies.txt --referer=https://alpha.wallhaven.cc $imgURL
    cat $number | echo "https://$(egrep -m 1 -o "wallpapers[a-zA-Z0-9\./_-]*(png|jpg|gif)" | head -n1)" | wget -q -U "$USERAGENT" --keep-session-cookies --save-cookies=cookies.txt --load-cookies=cookies.txt --referer=https://alpha.wallhaven.cc/wallpaper/$number -i - -O $WALLPAPER_FILE
} #/downloadWallpaper

#
# displays help text (valid command line arguments)
#
function helpText {
    APP="wallpaper-wallhaven-dl.sh"
    printf 'Download a random wallpaper from wallhaven.cc and set it using a custom command.\n\n'
    printf "$APP"' [OPTIONS]\n'
    printf 'If no options are specified, default values from within the script will be used\n\n'
    printf '  -l, --command\t\t Command which sets the wallpaper.\n\t\t\t To pass the filename of the wallpaper as argument, use %%f\n'
    printf '  -s, --startpage\t Page to start downloading from\n'
    printf '  -n, --numpages\t Number of pages to process\n'
    printf '  -t, --type\t\t Type of download Operation: standard, search, \n\t\t\t favorites, useruploads\n'
    printf '  -c, --categories\t categories to download from, eg. 111 for General,\n\t\t\t Anime and People, 1 to include, 0 to exclude\n'
    printf '  -f, --filter\t\t filter out content based on purity rating, eg. 111 \n\t\t\t for SFW, sketchy and NSFW content, 1 to include, \n\t\t\t 0 to exclude\n'
    printf '  -r, --resolution\t resolutions to download, separate mutliple \n\t\t\t resolutions by ,\n'
    printf '  -a, --aspectratio\t only download wallpaper with given aspectratios, \n\t\t\t separate multiple aspectratios by ,\n'
    printf '  -m, --mode\t\t sorting mode for wallpapers: relevance, random,\n\t\t\t date_added, views, favorites \n'
    printf '  -o, --order\t\t order ascending (asc) oder descending (desc)\n'
    printf '  -q, --query\t\t search query, eg. '\''mario'\'', single quotes needed,\n\t\t\t for searching exact phrases use double quotes \n\t\t\t inside single quotes, eg. '\''"super mario"'\'' \n'
    printf '  -u, --user\t\t download wallpapers from given user\n'
    printf '  -h, --help\t\t show this help text and exit\n\n'
    printf 'Examples:\n'
    printf "$APP"' -l "nitrogen --set-zoom-fill %%f"  -s 1 -n 2 -t standard -c 101 -f 111 -r 1920x1080 \n\t       -a 16x9 -m random -o desc\n\n'
    printf 'Download a random wallpaper with a resolution of 1920x1080 and \nan aspectratio of 16x9 starting with page 1 and ending with page 3 from the \ncategories general and people including SFW, sketchy and NSWF Content\nand set the wallpaper using nitrogen\n\n'
    printf "$APP"' -t search -c 111 -f 111 -r 1920x1080 \n\t       -a 16x9 -m relevance -o desc -q '\''"super mario"'\''\n\n'
    printf 'Download a random wallpaper related to the search query "super mario" with\na resolution of 1920x1080 and an aspectratio of 16x9 starting\nwith page 1 from the categories general, anime and people including SFW,\nsketchy and NSWF Content\n\n\n'
    printf 'Latest version available at: https://github.com/aldn/wallpaper-wallhaven-dl\n'
} # helptext

# Command line Arguments
while [[ $# -ge 1 ]]
    do
    key="$1"

    case $key in
        -l|--command)
            SET_WALLPAPER_COMMAND="$(echo "$2" | sed -e "s|%f|$WALLPAPER_FILE|")"
            shift;;
        -n|--numpages)
            NUMPAGES="$2"
            shift;;
        -s|--startpage)
            STARTPAGE="$2"
            shift;;
        -t|--type)
            TYPE="$2"
            shift;;
        -c|--categories)
            CATEGORIES="$2"
            shift;;
        -f|--filter)
            FILTER="$2"
            shift;;
        -r|--resolution)
            RESOLUTION="$2"
            shift;;
        -a|--aspectratio)
            ASPECTRATIO="$2"
            shift;;
        -m|--mode)
            MODE="$2"
            shift;;
        -o|--order)
            ORDER="$2"
            shift;;
        -q|--query)
            QUERY=$(echo "$2" | sed s/\'//g)
            shift;;
        -u|--user)
            USR="$2"
            shift;;
        -h|--help)
            helpText
            exit
            ;;
        *)
            printf "unknown option: $1\n"
            helpText
            exit
            ;;
    esac
    shift # past argument or value
    done

cd $WORKING_DIR



# login only when it is required ( for example to download favourites or nsfw content... )
if [ $FILTER == 001 ] || [ $FILTER == 011 ] || [ $FILTER == 111 ] || [ $TYPE == favorites ] ; then
   login $USER $PASS
fi

if [ $TYPE == standard ]; then
    for (( count=0, page="$STARTPAGE"; count< "$NUMPAGES"; count=count+1, page=page+1 ));
    do
        printf "Download Page $page"
        getPage "search?page=$page&categories=$CATEGORIES&purity=$FILTER&resolutions=$RESOLUTION&ratios=$ASPECTRATIO&sorting=$MODE&order=$ORDER"
        getImgUrls
        printf "\n    - done!\n"
    done

elif [ $TYPE == search ] ; then
    # SEARCH
    for (( count=0, page="$STARTPAGE"; count< "$NUMPAGES"; count=count+1, page=page+1 ));
    do
        printf "Download Page $page"
        getPage "search?page=$page&categories=$CATEGORIES&purity=$FILTER&resolutions=$RESOLUTION&ratios=$ASPECTRATIO&sorting=$MODE&order=desc&q=$QUERY"
        getImgUrls
        printf "\n    - done!\n"
    done

elif [ $TYPE == favorites ] ; then
    # FAVORITES
    # currently using sum of all collections
    for (( count=0, page="$STARTPAGE"; count< "$NUMPAGES" ; count=count+1, page=page+1 ));
    do
        printf "Download Page $page"
        getPage "favorites?page=$page"
        getImgUrls
        printf "\n    - done!\n"
    done

elif [ $TYPE == useruploads ] ; then
    # UPLOADS FROM SPECIFIC USER
    for (( count=0, page="$STARTPAGE"; count< "$NUMPAGES"; count=count+1, page=page+1 ));
    do
        printf "Download Page $page"
        getPage "user/$USR/uploads?page=$page&purity=$FILTER"
        getImgUrls
        printf "\n    - done!\n"
    done

else
    printf "error in TYPE please check Variable\n"
fi

# convert list of ULRs to the newline-separated form,
# randomly permutate it and pick one URL from the top
WALLPAPER_URL=$(cat urls | awk '{NF++;while(NF-->1)print $NF}' | shuf | head -n1)

echo "downloading wallpaper:" $WALLPAPER_URL

downloadWallpaper $WALLPAPER_URL

# display the downloaded wallpaper
echo "setting wallpaper using: $SET_WALLPAPER_COMMAND"
$SET_WALLPAPER_COMMAND

# cleanup
rm -rf $WORKING_DIR

# vim:ts=4:sw=4:et:
