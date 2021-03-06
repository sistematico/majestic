#!/usr/bin/env bash

cat << EOF > /etc/systemd/network/loopback-alias.network
[Match]
Name=lo

[Network]

[Address]
Label=lo:1
Address=172.16.253.10/32

[Address]
Label=lo:2
Address=172.16.253.11/32

[Route]
EOF

curl -s -L -o /tmp/ads.raw https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/social/hosts

cat /tmp/ads.raw | grep '^0\.0\.0\.0' | awk '{print "local-zone: \""$2"\" redirect\nlocal-data: \""$2" A 172.16.253.11\""}' > /etc/unbound/ads.conf

rm /tmp/ads.raw

grep -qxF 'include: /etc/unbound/ads.conf' /etc/unbound/unbound.conf || sed -i.bkp '/^server:.*/a include: /etc/unbound/ads.conf' /etc/unbound/unbound.conf

unbound-control -c /var/unbound/unbound.conf reload
