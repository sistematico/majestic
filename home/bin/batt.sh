#!/bin/bash 

completa="$HOME/.local/share/icons/batt/battery-100.png"
oitenta="$HOME/.local/share/icons/batt/battery-080.png"
sessenta="$HOME/.local/share/icons/batt/battery-060.png"
quarenta="$HOME/.local/share/icons/batt/battery-040.png"
vinte="$HOME/.local/share/icons/batt/battery-020.png"
zero="$HOME/.local/share/icons/batt/battery-000.png"

battery_level=$(acpi -b | awk -F ', ' '{print $2}' | sed 's/%//g') 
ac_power=$(acpi -b|grep -c "Charging")

if [[ $battery_level -eq 100 ]]; then
	icone="$completa" 
elif [[ $battery_level -gt 80 ]]; then
	icone="$oitenta"
elif [[ $battery_level -gt 60 ]]; then
	icone="$sessenta"
elif [[ $battery_level -gt 40 ]]; then
	icone="$quarenta"
else
	icone="$vinte"
fi

if [[ $ac_power -eq 1 && $battery_level -eq 100 ]]; then
	notify-send -i $icone "Bateria cheia" "Nível: ${battery_level}%"   
	#espeak-ng -v 'pt-BR' -s 150 "Bateria cheia, Por favor, remova o carregador" -s 130 
fi
  
if [[ $ac_power -eq 0 && $battery_level -lt 20 ]]; then
	notify-send -i $icone "Bateria baixa" "Nível: ${battery_level}%" 
	espeak-ng -v 'pt-BR' -s 150 "Conecte o carregador, nível da bateria em ${battery_level}%"
else 
	notify-send -i $icone "Bateria" "Nível: ${battery_level}%" 
fi
