#!/usr/bin/env bash

mkfifo /tmp/fast.com.test.fifo
token=$(curl -s https://fast.com/app-ed402d.js|egrep -om1 'token:"[^"]+'|cut -f2 -d'"')

curl -s "https://api.fast.com/netflix/speedtest?https=true&token=$token" | egrep -o 'https[^"]+' | while read url
do
	first=${url/speedtest/speedtest\/range\/0-2048}
	next=${url/speedtest/speedtest\/range\/0-26214400}
	(
		curl -s -H 'Referer: https://fast.com/' -H 'Origin: https://fast.com' "$first" > /tmp/fast.com.test.fifo;
		for i in {1..10};
		do
			curl -s -H 'Referer: https://fast.com/' -H 'Origin: https://fast.com' "$next" >> /tmp/fast.com.test.fifo
		done
	) &
done &

pv /tmp/fast.com.test.fifo > /dev/null
rm /tmp/fast.com.test.fifo

