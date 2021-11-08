#!/bin/bash

export VERSION=v16.13.0
export DISTRO=linux-x64

curl -L -s -o /tmp/node-$VERSION-$DISTRO.tar.xz https://nodejs.org/dist/$VERSION/node-$VERSION-$DISTRO.tar.xz

sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf /tmp/node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs 
