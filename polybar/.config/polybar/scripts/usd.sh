#!/bin/bash

if [ -f $HOME/.config/api-keys.sh ]; then
	source $HOME/.config/api-keys.sh
else
	echo "Arquivo de APIs não encontrado."
	exit
fi

# BTC 1, USD 2781, BRL 2783
api=$(curl -s -H "X-CMC_PRO_API_KEY: ${coinmarketcap}" -H "Accept: application/json" -d "id=2781&amount=1&convert=BRL" -G https://pro-api.coinmarketcap.com/v1/tools/price-conversion)
quote=$(echo $api | jq -r ".data.quote.BRL.price")
quote=$(LANG=C printf "%'.2f" "${quote}")

echo "USD $quote"
