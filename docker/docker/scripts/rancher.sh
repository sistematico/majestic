#!/bin/sh
docker run -d --restart=unless-stopped -p 8080:80 -p 443:443 rancher/rancher --name=rancher
