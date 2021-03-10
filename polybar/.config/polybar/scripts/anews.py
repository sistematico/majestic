#!/usr/bin/python
# -*- coding: utf-8 -*-
# Depends on python-feedparser
# Read Arch Linux RSS news;

import feedparser
from subprocess import call
import re
import textwrap

try:
    d = feedparser.parse("https://www.archlinux.org/feeds/news/")
    for f in range(0,1):
        print("%s" % (d.entries[f].title))
        xy = d.entries[f].title
except:
    print("Recuperando notícias")