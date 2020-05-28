#!/bin/sh

# Zenity Examples
szAnswer=$(zenity --entry --text "where are you?" --entry-text "at home"); echo $szAnswer
zenity --error --text "Installation failed! "
zenity --info --text "Join us at irc.freenode.net #lbe."

# For Examples
array=( "um" "dois" "tres" )

for arr in ${array[@]} 
do
    echo $arr
done

