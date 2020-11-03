#!/bin/bash
active="$(xdotool getactivewindow)"
while read -r window; do
    if [[ "$window" != "$active" ]]; then
        xdotool windowclose "$window"
    fi
done < <(xdotool search --onlyvisible '.*')
