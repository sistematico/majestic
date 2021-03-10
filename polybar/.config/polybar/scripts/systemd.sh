#!/usr/bin/env bash
# @Author: Lucas Saliés Brum
# @Date:   2019-12-09 09:32:52
# @Last Modified by:   Lucas Saliés Brum
# @Last Modified time: 2019-12-09 11:28:43

if [ $2 ]; then
    [ "$1" == "-u" ] && param="--user"

    if systemctl $param is-active --quiet $2; then
        if [ $3 ]; then
            systemctl $param stop $2
            echo " $2"
        else
            echo "%{F#D08770}%{F-} $2"            
        fi
    else
        if [ $3 ]; then
            systemctl $param start $2
            echo "%{F#D08770}%{F-} $2"
        else
            echo " $2"            
        fi
    fi
fi
