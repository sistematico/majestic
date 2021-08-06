#!/bin/sh

# prepare the string format for the yad dialog
for dirs in "$@"
do
    DIRS="$DIRS\n$dirs"
done

# ask for confirmation
if yad \
    --image "dialog-question" \
    --title "Alert" \
    --button=gtk-yes:0 \
    --button=gtk-no:1 \
    --text "Are you sure you want to move the contents of:\n\n$DIRS"

then
    # move files to parent    
    for dir in "$@"
    do
        find "$dir" -mindepth 1 -maxdepth 1 -type f -exec mv "{}" "$dir" . \;
    done
    
else
    # or bow out
    exit 1
fi
exit 0