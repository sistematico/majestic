#!/bin/bash

free=$(free -m | grep Mem)
current=$(echo $free | cut -f3 -d' ')
total=$(echo $free | cut -f2 -d' ')
total=$(echo "scale=2; $current/$total*100" | bc)
printf "%.2s" "$total"