#!/bin/sh
docker run -d --name portainer --restart=unless-stopped -p 8080:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
