#!/usr/bin/env bash

find $1 ! -empty -type f -exec md5sum {} + | sort | uniq -w32 -dD
