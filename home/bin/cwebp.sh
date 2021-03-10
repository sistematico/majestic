#!/usr/bin/env bash
#
# Fonte: https://web.dev/codelab-serve-images-webp/
#
# Uso:
#<picture>
#  <source type="image/webp" srcset="images/flower1.webp">
#  <source type="image/jpeg" srcset="images/flower1.jpg">
#  <img src="images/flower1.jpg">
#</picture>

for arquivo in $1/*;
do
    cwebp -q 50 "$arquivo" -o "${arquivo%.*}.webp";
done

#cwebp -q 50 images/flower1.jpg -o images/flower1.webp