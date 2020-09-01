#!/bin/bash
sudo usermod --add-subuids 10000-65536 USERNAME
rm -rf ~/.{config,local/share}/containers /run/user/$(id -u)/{libpod,runc,vfs-*}
