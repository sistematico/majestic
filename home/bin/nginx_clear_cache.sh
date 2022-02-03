#!/bin/bash
sudo service nginx stop
sudo rm -rf /var/cache/nginx/*
sudo service nginx start | mail -s "Nginx Purged" me@gmail.com
exit 0
