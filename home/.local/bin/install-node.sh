#!/usr/bin/env bash

export NODE_VERSION=v16.14.0

if [ ! -z ${NODE_VERSION+x} ] && [ ! -d /usr/local/lib/nodejs/node-$NODE_VERSION-linux-x64 ]; then
    curl -L -s -o /tmp/node-$NODE_VERSION-linux-x64.tar.xz https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz
    sudo mkdir -p /usr/local/lib/nodejs
    sudo tar -xJvf /tmp/node-$NODE_VERSION-linux-x64.tar.xz -C /usr/local/lib/nodejs 
    [[ $PATH != *usr/local/lib/nodejs* ]] && export PATH=/usr/local/lib/nodejs/node-$NODE_VERSION-linux-x64/bin:$PATH
else
    echo -e "A variável \$NODE_VERSION não está setada.\nOu o nodejs já está instalado!"
fi