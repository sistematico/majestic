#!/bin/bash

CHECKINTERVAL=0.1
DEVICE="eno1"

if [ "$1" == "out" ]; then
  #ICONE=""
  ICONE=""
else
  #ICONE=""
  ICONE=""
fi

getNetStat() {
  #cat /proc/vmstat|egrep "pgpgin|pgpgout"
  #cat /proc/net/dev | grep wlp2s0 | cut -d ':' -f 2 | awk '{print $1, $9}'
  if [ "$1" == "out" ]; then
    cat /proc/net/dev | grep $DEVICE | cut -d ':' -f 2 | awk '{print $9}'
  else
    cat /proc/net/dev | grep $DEVICE | cut -d ':' -f 2 | awk '{print $1}'
  fi
}

NEW=$(getNetStat)
OLD=$(getNetStat)

while true; do
  sleep $CHECKINTERVAL
  NEW=$(getNetStat)
  if [ "$NEW" = "$OLD" ]; then
    echo "%{F#D08770}%{T4}$ICONE%{T-}%{F-}"
  else
    echo "%{F#FFFFFF}%{T4}$ICONE%{T-}%{F-}"
    sleep $CHECKINTERVAL
    echo "%{F#D08770}%{T4}$ICONE%{T-}%{F-}"
  fi
  OLD=$NEW
done
