#!/bin/bash

if [ -f $HOME/.config/api-keys.sh ]; then
	source $HOME/.config/api-keys.sh
else
	echo "Arquivo de APIs não encontrado."
	exit
fi

api=$(curl -s -H "X-CMC_PRO_API_KEY: ${coinmarketcap}" -H "Accept: application/json" -d "id=1&amount=1&convert=BRL" -G https://pro-api.coinmarketcap.com/v1/tools/price-conversion)
quote=$(echo $api | jq -r ".data.quote.BRL.price")
quote=$(LANG=C printf "%'.2f" "${quote}")

echo " $quote"
