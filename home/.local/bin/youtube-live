#!/usr/bin/env bash

YOUTUBE_KEY=$(grep YOUTUBE_KEY $HOME/.env | xargs)
YOUTUBE_KEY="${YOUTUBE_KEY#*=}"

INRES="1920x1080"                               # input resolution
OUTRES="1920x1080"                               # output resolution
ABR="44100"                                     # audio rate
VBR="2500k"                                     # Bitrate de la vidéo en sortie
FPS="30"                                        # FPS de la vidéo en sortie
QUAL="ultrafast"                                # Preset de qualité FFMPEG
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"   # URL de base RTMP youtube

TXT_OVERLAY="${HOME}/.local/share/youtube/overlay.txt"   #txt overlay file location
FONT="/usr/share/fonts/ubuntu/Ubuntu-B.ttf"   #font file location. Probably same for all ubuntu. (or all linux ?)

# ffmpeg \
#     -f x11grab \
#     -s "$INRES" \
#     -i $DISPLAY \
#     -f pulse -i 0 \
#     -deinterlace \
#     -vcodec libx264 -pix_fmt yuv420p \
#     -s $OUTRES \
#     -preset $QUAL \
#     -r $FPS -g $(($FPS * 2)) \
#     -b:v $VBR \
#     -ac 2 -acodec libmp3lame \
#     -ar $AUDIO_RATE \
#     -threads 6 -qscale 3 \
#     -b:a 712000 \
#     -bufsize 512k \
#     -f flv "$YOUTUBE_URL/$YOUTUBE_KEY"

# -ar $ABR -threads 6 -q:a 3 -b:a 712000 -bufsize 128k \

ffmpeg \
	-f x11grab -video_size ${INRES} \
    -framerate $FPS \
    -i $DISPLAY -deinterlace \
    -f pulse \
    -ac 2 \
    -i default \
    -c:v libx264 -pix_fmt yuv420p \
    -crf 23 \ 
    -c:a aac -ac 2 -b:a 128k -ar $ABR -threads 6 -q:a 3 -bufsize 128k \
    -preset $QUAL -tune zerolatency -g $(($FPS * 2)) -b:v $VBR \
    -filter_complex "[0:v][1:v] overlay=(W-w):0 [b]; \
    [b] drawtext=fontfile=${FONT}: textfile=${TXT_OVERLAY}: reload=1: \
          x=5: y=450: fontsize=25: fontcolor=white@1.0: box=1: boxcolor=black@0.5" \
    -f flv "$YOUTUBE_URL/$YOUTUBE_KEY"


# VID_SOURCE="/dev/video0"                #for lappy's webcam, it works. for usb cam try changing the location
# IM_SOURCE="/home/rik/Desktop/riktronics_small.bmp"  #logo location
# TXT_OVERLAY_SOURCE="/home/rik/Desktop/txtfile.txt"   #txt overlay file location
# FONT_SOURCE="/usr/share/fonts/truetype/freefont/FreeMono.ttf"   #font file location. Probably same for all ubuntu. (or all linux ?)


# URL="rtmp://a.rtmp.youtube.com/liveStreamName"         #Your live stream url
# KEY="hqd5-pu3v-abcd-vxyz"                     #your stream api
# ffmpeg \
# 	 -f v4l2 -video_size 640x480 -framerate $FPS\
#     -i "$VID_SOURCE" -deinterlace \
#     -i "$IM_SOURCE" \
#     -f lavfi -i anullsrc -c:v copy -c:a aac -strict -2\
#     -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -tune zerolatency -g $(($FPS * 2)) -b:v $VBR \
#     -ar 44100 -threads 6 -q:a 3 -b:a 712000 -bufsize 128k \
#     -filter_complex "[0:v][1:v] overlay=(W-w):0 [b]; \
#     [b] drawtext=fontfile=$FONT_SOURCE: textfile=$TXT_OVERLAY_SOURCE: reload=1:\
#           x=5: y=450: fontsize=25: fontcolor=white@1.0: box=1: boxcolor=black@0.5"\
#     -f flv "$URL/$KEY"
