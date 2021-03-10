#!/bin/sh

if [ $1 ]; then
	old=$(pwd)
	new=$(dirname $1)
	cd $new
fi

for arquivo in $(ls *.webp)
do
	saida="${arquivo%.*}"
  	dwebp "$arquivo" -o "${saida}.png"
	if [ $? == 0 ]; then
		mv $arquivo ~/.local/share/Trash/
	fi
done

exit
