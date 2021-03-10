#!/bin/bash

cpu=$(top -b -n1 | grep "CPU(s)" | awk '{print $2 + $4}')
echo $cpu