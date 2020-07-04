#!/usr/bin/env bash

CSSDEST=''

case $1 in
    bulma)
        CSS='css/bulma.min.css'
        URL='https://api.github.com/repos/jgthms/bulma/releases/latest'
    ;;
    bootstrap)
        CSS='dist/css/bootstrap.min.css'
        JS='dist/js/bootstrap.bundle.min.js'
        URL='https://api.github.com/repos/twbs/bootstrap/releases/latest'
    ;;
    jquery)
        JS='dist/jquery.min.js'
        URL='https://api.github.com/repos/jquery/jquery/releases/latest'
    ;;
    fontawesome)
        CSSDEST='fontawesome.min.css'
        CSS='css/all.min.css'
        URL='https://api.github.com/repos/FortAwesome/Font-Awesome/releases/latest'
    ;;
    *)
        echo "Uso: $(basename $0) [bulma|jquery|bootstrap|fontawesome]"
        exit
    ;;
esac

VERSION=$(curl -s $URL | jq -r '.tag_name')
NAME="${1}-${VERSION}"
DOWNLOAD=$(curl -s $URL | jq -r '.tarball_url')
[ ! -f /tmp/${NAME}.tar.gz ] && curl -s -L -o /tmp/${NAME}.tar.gz $DOWNLOAD
OLDNAME=$(tar -tf /tmp/${NAME}.tar.gz | head -1 | cut -f1 -d"/")
tar xzf /tmp/${NAME}.tar.gz -C /tmp

[ ! -d css ] && mkdir css
[ ! -d js ] && mkdir js

if [ ! -z $CSS ] && [ -f /tmp/$OLDNAME/$CSS ]
then
    cp /tmp/$OLDNAME/$CSS css/$CSSDEST
fi
if [ ! -z $JS ] && [ -f /tmp/$OLDNAME/$JS ]
then
    cp /tmp/$OLDNAME/$JS js/
fi
