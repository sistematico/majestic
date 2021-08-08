#!/bin/sh

[ -d /tmp/majestic ] && rm -rf /tmp/majestic

[ -d ~/newdocker ] && rm -rf ~/newdocker

git clone https://github.com/sistematico/majestic /tmp/majestic

cp -a /tmp/majestic/docker/docker ~/newdocker

cd ~/newdocker