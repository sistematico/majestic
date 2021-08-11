#!/usr/bin/env bash

sink=$(pactl list short sinks | awk 'NR==1{print $2}')
active=$(LANG=C pactl list sinks | awk '{if ($1 == "Active" && $2 == "Port:") {gsub(/[ \t]+$/, "", $2);print $3; exit;}}')

port_one=$(LANG=C pactl list sinks | awk '/Ports/{getline;gsub(":","");gsub(/[ \t]+$/, "", $2);print $1;}')
port_two=$(LANG=C pactl list sinks | awk '/Ports/{getline;getline;gsub(":","");gsub(/[ \t]+$/, "", $2);print $1;}')

if [[ $port_one == *"$active"* ]]; then
    pacmd set-sink-port $sink $port_two
    exit 0
fi

if [[ $port_two == *"$active"* ]]; then
    pacmd set-sink-port $sink $port_one
    exit 0
fi
