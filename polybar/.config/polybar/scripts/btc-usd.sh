#!/bin/bash

if [ -f $HOME/.config/api-keys.sh ]; then
	source $HOME/.config/api-keys.sh
else
	echo "Arquivo de APIs não encontrado."
	exit
fi

apibtc=$(curl -s -H "X-CMC_PRO_API_KEY: ${coinmarketcap}" -H "Accept: application/json" -d "id=1&amount=1&convert=BRL" -G https://pro-api.coinmarketcap.com/v1/tools/price-conversion)
btc=$(echo $apibtc | jq -r ".data.quote.BRL.price")
btc=$(LANG=C printf "%'.2f" "${btc}")

apiusd=$(curl -s -H "X-CMC_PRO_API_KEY: ${coinmarketcap}" -H "Accept: application/json" -d "id=2781&amount=1&convert=BRL" -G https://pro-api.coinmarketcap.com/v1/tools/price-conversion)
usd=$(echo $apiusd | jq -r ".data.quote.BRL.price")
usd=$(LANG=C printf "%'.2f" "${usd}")

echo "$btc / $usd"
