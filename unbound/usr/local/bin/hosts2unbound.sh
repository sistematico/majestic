#!/bin/bash

grep '^127\.0\.0\.1' /etc/hosts.block | awk '{print "local-zone: \""$2"\" always_nxdomain"}' > /etc/unbound/blacklist.conf
