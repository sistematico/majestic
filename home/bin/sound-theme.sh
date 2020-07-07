#!/usr/bin/env bash

xfconf-query -c xsettings -p /Net/EnableEventSounds -s true
xfconf-query -c xsettings -p /Net/EnableInputFeedbackSounds -s true
xfconf-query -c xsettings -p /Net/SoundThemeName -s "Borealis"


