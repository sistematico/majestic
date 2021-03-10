#!/bin/bash

CHECKINTERVAL=0.1

getVmstat() {
  cat /proc/vmstat|egrep "pgpgin|pgpgout"
}

NEW=$(getVmstat)
OLD=$(getVmstat)

while true; do
  sleep $CHECKINTERVAL
  NEW=$(getVmstat)
  if [ "$NEW" = "$OLD" ]; then
    echo "%{F#D08770}%{T2}%{T-}%{F-}"
  else
    echo "%{F#FFFFFF}%{T2}%{T-}%{F-}"
    sleep $CHECKINTERVAL
    echo "%{F#D08770}%{T2}%{T-}%{F-}"
  fi
  OLD=$NEW
done
