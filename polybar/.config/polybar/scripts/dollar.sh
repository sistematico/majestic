#!/bin/bash

if [ -f $HOME/.config/api-keys.sh ]; then
	source $HOME/.config/api-keys.sh
else
	echo "Arquivo de APIs não encontrado."
	exit
fi

#api=$(curl -s -H "X-CMC_PRO_API_KEY: ${coinmarketcap}" -H "Accept: application/json" -d "id=1" -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest)
#api=$(curl -H "X-CMC_PRO_API_KEY: ${coinmarketcap}" -H "Accept: application/json" -d "convert=BRL" -G https://pro-api.coinmarketcap.com/v1/global-metrics/quotes/latest)

# BTC 1, USD 2781, BRL 2783

# BTC -> BRL
#api=$(curl -s -H "X-CMC_PRO_API_KEY: ${coinmarketcap}" -H "Accept: application/json" -d "id=1&amount=1&convert=BRL" -G https://pro-api.coinmarketcap.com/v1/tools/price-conversion)
#quote=$(echo $api | jq -r ".data.quote.BRL.price")

# USD -> BRL
api=$(curl -s -H "X-CMC_PRO_API_KEY: ${coinmarketcap}" -H "Accept: application/json" -d "id=2781&amount=1&convert=BRL" -G https://pro-api.coinmarketcap.com/v1/tools/price-conversion)
quote=$(echo $api | jq -r ".data.quote.BRL.price")
quote=$(LANG=C printf "%'.2f" "${quote}")

#quote=$(LANG=pt_BR.UTF-8 printf "%'.2f" "${quote}")


echo "USD $quote"
