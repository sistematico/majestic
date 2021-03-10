#!/bin/bash

linha=$(cat api | grep $1)
echo $linha | sed -ne '/:/ { s/^[^:]*:[\t\v\f ]*//p ; q0 }'
