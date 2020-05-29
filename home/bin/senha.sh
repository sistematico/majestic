#!/usr/bin/env bash

chars=32
senha="$(openssl rand -base64 $chars)"

echo "${senha}" | xclip -selection clipboard -rmlastnl
echo $senha
