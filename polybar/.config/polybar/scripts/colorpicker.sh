#!/bin/bash

COLORFILE="$HOME/.config/colorpickerlist"
ACTIONFILE="/tmp/i3colorpicker"

## mode :
## 0 => hex
## 1 => rgb
mode=0

rgb_to_hsl() {
  local r=$(echo "scale=2; $1 / 255" | bc)
  local g=$(echo "scale=2; $2 / 255" | bc)
  local b=$(echo "scale=2; $3 / 255" | bc)

  local max=$r
  if (( $(echo "$g > $max" | bc -l) )); then
    max=$g
  fi
  if (( $(echo "$b > $max" | bc -l) )); then
    max=$b
  fi
  local min=$r
  if (( $(echo "$g < $min" | bc -l) )); then
    min=$g
  fi
  if (( $(echo "$b < $min" | bc -l) )); then
    min=$b
  fi

  local h=$(echo "($max + $min) / 2" | bc -l)
  local s=$h
  local l=$h

  if (( $(echo "$max == $min" | bc -l ) )); then
    h=0
    s=0
  else
    local d=$(echo "$max - $min" | bc -l)
    if (( $(echo "$l > 0.5" | bc -l) )); then
      local t=$(echo "2 - $max - $min" | bc -l)
    else
      local t=$(echo "$max + $min" | bc -l)
    fi
    s=$(echo "$d / $t" | bc -l)

    if (( $(echo "$max == $r" | bc -l) )); then
      if (( $(echo "$g < $b" | bc -l) )); then
        local t=6
      else
        local t=0
      fi
      h=$(echo "($g - $b) / $d + $t" | bc -l)
    elif (( $(echo "$max == $g" | bc -l) )); then
        h=$(echo "($b - $r) / $d + 2" | bc -l)
    elif (( $(echo "$max == $b" | bc -l) )); then
        h=$(echo "($r - $g) / $d + 4" | bc -l)
    fi
  fi

  h=$(echo "scale=2; $h / 6" | bc -l)
  s=$(echo "scale=2; $s * 2 / 2" | bc -l)
  l=$(echo "scale=2; $l * 2 / 2" | bc -l)

  echo "$h $s $l"
}

hue_to_rgb() {
  local p=$1
  local q=$2
  local t=$3

  if (( $(echo "$t < 0" | bc -l) )); then
    t=$(echo "$t + 1" | bc -l)
  fi
  if (( $(echo "$t > 1" | bc -l) )); then
    t=$(echo "$t - 1" | bc -l)
  fi
  if (( $(echo "$t < (1/6)" | bc -l) )); then
    echo "$(echo "$p + ($q - $p) * 6 * $t" | bc -l)"
  elif (( $(echo "$t < (1/2)" | bc -l) )); then
    echo $q
  elif (( $(echo "$t < (2/3)" | bc -l) )); then
    echo "$(echo "$p + ($q - $p) * (2/3 - $t) * 6" | bc -l)"
  else
    echo $p;
  fi
}

hex_to_rgb() {
  local hex=$1

  local r=`echo $hex | cut -c-2`
  local g=`echo $hex | cut -c3-4`
  local b=`echo $hex | cut -c5-6`

  r=`echo "ibase=16; $r" | bc`
  g=`echo "ibase=16; $g" | bc`
  b=`echo "ibase=16; $b" | bc`

  echo $r $g $b
}

toggle() {
  mode=$(((mode + 1) % 2))
}

clipboard() {
  hexcolor=$( tail -n 1 $COLORFILE )
	color=$hexcolor
	if [ $mode -eq 1 ]; then
		res=$(hex_to_rgb ${hexcolor:1:6})
		IFS=' ' read -r -a res <<< "$res"
		r=${res[0]}
		g=${res[1]}
		b=${res[2]}
		color="rgb($r,$g,$b)"
	fi
	echo $color | xclip -sel c
}

open_popup() {
	BAR_HEIGHT=22  # polybar height
	BORDER_SIZE=1  # border size from your wm settings
	YAD_WIDTH=690  # 690 is minimum possible value
	YAD_HEIGHT=325 # 325 is minimum possible value

	if [ "$(xdotool getwindowfocus getwindowname)" = "yad-color" ]; then
		exit 0
	fi

	eval "$(xdotool getmouselocation --shell)"
	eval "$(xdotool getdisplaygeometry --shell)"

	if [ "$((X + YAD_WIDTH / 2 + 2 + BORDER_SIZE))" -gt "$WIDTH" ]; then #Right side
		: $((pos_x = WIDTH - YAD_WIDTH - BORDER_SIZE - 4))
	elif [ "$((X - YAD_WIDTH / 2 - 2 - BORDER_SIZE))" -lt 1 ]; then #Left side
		: $((pos_x = BORDER_SIZE))
	else #Center
		: $((pos_x = X - YAD_WIDTH / 2 - 2))
	fi

	# Y
	if [ "$Y" -gt "$((HEIGHT / 2))" ]; then #Bottom
		: $((pos_y = HEIGHT - YAD_HEIGHT - 4 - BAR_HEIGHT - BORDER_SIZE))
	else #Top
		: $((pos_y = BAR_HEIGHT + BORDER_SIZE))
	fi

	COLORS=""
	while IFS= read -r hexcolor
	do
		res=$(hex_to_rgb ${hexcolor:1:6})
		IFS=' ' read -r -a res <<< "$res"
		r=${res[0]}
		g=${res[1]}
		b=${res[2]}
		COLORS="$r $g $b $hexcolor
	$COLORS"
		INITCOLOR=$hexcolor
	done < "$COLORFILE"
	echo "$COLORS" > /tmp/colors

	yad --color --on-top --tooltip \
		--width=$YAD_WIDTH --height=$YAD_HEIGHT --posx=$pos_x --posy=$pos_y \
		--title="i3 color picker" --expand-palette \
		--palette="/tmp/colors" --init-color=$INITCOLOR >/dev/null &
}

next_color() {
  hexcolor=$( head -n 1 $COLORFILE )
  sed -i "/$hexcolor/d" $COLORFILE
  echo "$hexcolor" >> $COLORFILE
}

previous_color() {
  hexcolor=$( tail -n 1 $COLORFILE )
  sed -i "/$hexcolor/d" $COLORFILE
  sed -i "1i$hexcolor" $COLORFILE
}

handler() {
  action=$(cat $ACTIONFILE)
  if [ "$action" = "toggle" ]; then
    toggle
  elif [ "$action" = "open_popup" ]; then
    open_popup
  elif [ "$action" = "clipboard" ]; then
    clipboard
  elif [ "$action" = "next_color" ]; then
    next_color
  elif [ "$action" = "previous_color" ]; then
    previous_color
  fi

  unlink $ACTIONFILE
}

if [ "$1" = "--pick" ]; then
  X=""
  Y=""

  #MOUSE_ID=$(xinput --list | grep -m 1 'Mouse' | grep -o 'id=[0-9]\+' | grep -o '[0-9]\+')
  MOUSE_ID=$(xinput --list | grep -m 1 'Abyssus' | grep -o 'id=[0-9]\+' | grep -o '[0-9]\+')
  sleep 0.1
  STATE1=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
  while true; do
    sleep 0.1
    STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
    mousediff=$(comm -13 <(echo "$STATE1") <(echo "$STATE2"))
    if [ ! -z $(echo "$mousediff" | grep -i "up") ]; then
      eval $(xdotool getmouselocation --shell)
      COLOR=`xwd -root -silent | convert xwd:- -depth 8 -crop "1x1+$X+$Y" txt:- | grep -om1 '#\w\+'`
      sed -i "/$COLOR/d" $COLORFILE
      echo $COLOR >> $COLORFILE
      #update
      break;
    fi
    STATE1=$STATE2
  done
elif [ "$1" = "--update" ]; then
echo "update" >> $HOME/debug.log
	echo "$(cat $COLORFILE)" > $COLORFILE
elif [ "$1" = "--popup" ]; then
	open_popup
else
  trap "handler" USR1

	FIRST=true
	while $FIRST || test "$( inotifywait -q -e modify "$COLORFILE")" = "" || true; do
		FIRST=false
		hexcolor=$( tail -n 1 $COLORFILE )
    if [ -z $hexcolor ]; then
      echo "empty"
    else
      hexcolor2=${hexcolor:1:6}

      res=$(hex_to_rgb $hexcolor2)
      IFS=' ' read -r -a res <<< "$res"
      r=${res[0]}
      g=${res[1]}
      b=${res[2]}

      res="$(rgb_to_hsl $r $g $b)"
      IFS=' ' read -r -a res <<< "$res"
      l=${res[2]}

      if (( $(echo "$l > 0.5" | bc -l) )); then
        fhexcolor="#000000"
      else
        fhexcolor="#FFFFFF"
      fi

      displaycolor=$hexcolor
      if [ $mode -eq 1 ]; then
        displaycolor="rgb($r,$g,$b)"
      fi

      echo "%{u$hexcolor}$displaycolor %{-u}%{B$hexcolor}      %{B-}"
      # echo "%{B$hexcolor}%{F$fhexcolor}  $displaycolor  %{B- F-}"
    fi
	done
fi
