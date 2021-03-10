#!/bin/bash

caminho=$1

find "$caminho" -name *.js -exec basename {} \; > /tmp/orphan.txt
find "$caminho" -name *.css -exec basename {} \; > /tmp/orphan.txt

#find "$caminho" -name *.css -exec basename {} \; >> /tmp/orphan.txt
#find "$caminho" -name *.jpg -exec basename {} \; >> /tmp/orphan.txt
#find "$caminho" -name *.png -exec basename {} \; >> /tmp/orphan.txt
#find "$caminho" -name *.gif -exec basename {} \; >> /tmp/orphan.txt

for p in $(cat /tmp/orphan.txt); do
    grep -R $p "$caminho" > /dev/null || echo $p;
done
