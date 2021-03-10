#!/bin/bash
#
# backup.sh: Um script simples para backup de banco de dados e arquivos de um(ou vários sites).
#
# Uso: ./backup.sh [clear|sites|mysql|both]
# * Não se esqueça de alterar as variáveis $USUARIO_MYSQL, $SENHA_MYSQL e $DIR_WEBSERVER!!!
# 
# Para backups automáticos digite: crontab -e
#
# Crontab sugerido(uma vez por semana e a cada reboot, limpa uma vez por mês):
#
# @weekly sh -c "/usr/local/scripts/backup.sh both" > /dev/null 2>&1
# @reboot sh -c "/usr/local/scripts/backup.sh both" > /dev/null 2>&1
# @monthly sh -c "/usr/local/scripts/backup.sh clear" > /dev/null 2>&1
#
# ou (meia-noite faz backup e meia-noite e 15 minutos limpa backups antigos.)
#
# 0 0 * * * sh -c "/usr/local/scripts/backup.sh both" > /dev/null 2>&1
# 15 0 * * * sh -c "/usr/local/scripts/backup.sh clear" > /dev/null 2>&1
#
# Script criado por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em:           06-03-2016 21:15:28
# Última alteração em: 16-01-2019 12:20:55

DIR_WEBSERVER="/var/www"
USUARIO_MYSQL="root"
SENHA_MYSQL="alanjackson1983"
DIAS=15 # Dias para manter o backup
DIR="/var/backup"

BLACKLIST_DB=('mysql' 'performance_schema' 'phpmyadmin' 'information_schema' 'grblog' 'grforum')
BLACKLIST_SITES=('old')

DIR_DB="$DIR/dbs/$(date +'%Y')/$(date +'%m')/$(date +'%d')"
DIR_SITES="$DIR/site/$(date +'%Y')/$(date +'%m')/$(date +'%d')"

backupMysql() {
	if [ ! -d $DIR_DB ]; then
		mkdir -p $DIR_DB
	else
		rm -f "$DIR_DB/*gz" > /dev/null 2>&1
	fi

	databases=$(mysql -u $USUARIO_MYSQL -p$SENHA_MYSQL -e "SHOW DATABASES;" | tr -d "| " | egrep -v "Database")

	for db in $databases; do
		if ! echo ${BLACKLIST_DB[@]} | grep -q -w "$db"; then
			banco="$(date +%Y%m%d).$db.sql"
        	mysqldump -u $USUARIO_MYSQL -p$SENHA_MYSQL --databases $db > $DIR_DB/$banco
      		gzip --force $DIR_DB/$banco
    	fi
	done
}

backupSites() {
	SITES=$(ls -1 $DIR_WEBSERVER)

	if [ ! -d $DIR_SITES ]; then
        mkdir -p $DIR_SITES
	else
		rm -f "$DIR_SITES/*gz" > /dev/null 2>&1
    fi

    OLDPATH=$(pwd)
    cd $DIR_SITES

	for site in $SITES; do
		if ! echo ${BLACKLIST_SITES[@]} | grep -q -w "$site"; then
			if [[ "$site" != "storage" ]] && [[ "$site" != "test" ]]; then
				/usr/bin/rsync -a $DIR_WEBSERVER/$site $DIR_SITES/ --delete >/dev/null 2>&1
				tar -zcf $site.tar.gz $site
				rm -rf $site
			fi
		fi
	done

	cd $OLDPATH
}

if [ "$1" == "mysql" ]; then
	echo -e "[\e[34m*\e[0m] Backup do \e[34mMySQL\e[0m"
	backupMysql
elif [ "$1" == "sites" ]; then
	echo -e "[*] Backup dos \e[34mArquivos\e[0m"
	backupSites
elif [ "$1" == "both" ]; then
	echo -e "[\e[34m*\e[0m] Backup do \e[34mMySQL\e[0m"
	backupMysql
	echo -e "[\e[34m*\e[0m] Backup dos \e[34mArquivos\e[0m"
	backupSites
elif [ "$1" == "clear" ]; then
	echo -e "[\e[31m*\e[0m] Limpando backups mais antigos que $DIAS dias"
	if [ -d $DIR ]; then
		arquivos=$(find $DIR -mtime +$DIAS)
	else
		echo -e "[\e[31m*\e[0m] Diretório \e[31m$DIR\e[0m inexistente."
		exit 1
	fi
	echo "Os arquivos:"
	echo
	echo -e "\e[33m $arquivos \e[0m"
	echo "Serão apagados."
	echo
	read -p "Você tem certeza? [s/N]: " resposta
	if [[ "$resposta" = *[sS]* ]]; then
		echo "A resposta foi sim."
		echo "Apagando em 10 segundos, CTRL+c para cancelar..."
		sleep 10
		find $DIR -mtime +$DIAS | xargs rm -rf
	else
		echo "A resposta foi não.."
	fi
fi
