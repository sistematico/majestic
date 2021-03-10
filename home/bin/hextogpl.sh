#!/bin/sh
#
# hextogpl.sh
# Um script para criar paletas do Agave usando cores hexadecimais.
#
# Exemplo de uso: hextogpl.sh #000000
# Créditos: https://stackoverflow.com/a/7253786
#
# Dica de paleta
# https://github.com/chriskempson/tomorrow-theme

timestamp=$(date +%s)

if [[ $EUID -eq 0 ]]; then
	paleta="/usr/share/agave/palettes/Custom-${timestamp}.gpl"
else
	paleta="/tmp/Custom-${timestamp}.gpl"
fi

nome="Custom ${timestamp}"

function cor() {
	cor="$1"

    if [[ ${cor:0:1} == "#" ]]; then
        hexinput=$(echo "$cor" | cut -c 2- | tr "[:lower:]" "[:upper:]")
    else
        hexinput=$(echo "$cor" | tr "[:lower:]" "[:upper:]")  # uppercase-ing
    fi

    a=`echo $hexinput | cut -c-2`
    b=`echo $hexinput | cut -c3-4`
    c=`echo $hexinput | cut -c5-6`

    r=`echo "ibase=16; $a" | bc`
    g=`echo "ibase=16; $b" | bc`
    b=`echo "ibase=16; $c" | bc`

	((num++))

    rgba="${r}\t${g}\t${b}\tCustom${num}"

    echo -e "$rgba" >> $paleta
}


cat > $paleta <<EOL
GIMP Pallete
Name: ${nome}
Columns: 0
#
EOL

if [ ! $1 ]; then
	while :
	do
		read -p "Digite o hexadecimal da cor (ENTER para sair): " cor desc
		if [[ "$cor" == "" ]]; then
			break
		fi

		cor $cor
	done
else
	for i in "$@"
	do
		cor $i
	done
fi

echo "Arquivo de paletas salvo em $paleta"

exit 0
