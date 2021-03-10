#!/usr/bin/env sh

#sudo apt-get install dir2ogg
#dir2ogg -r /path/to/mp3s/

for file in *.mp3
  do ffmpeg -i "${file}" "${file/%mp3/ogg}"
done
