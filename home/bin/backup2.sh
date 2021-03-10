#!/bin/bash
#
# Script de Backup do MySQL e arquivos usando o rsync e mysqldump.
#
# Desenvolvido por Lucas Saliés Brum <lucas@archlinux.com.br>
#
# Com base no trabalho de vivek em:
# http://www.cyberciti.biz/nixcraft/vivek/blogger/2005/01/mysql-backup-script.html
#
# Criado em: 15/06/2014
# Última Atualização: 03/12/2014
#
USUARIO="root"
SENHA="SENHA"
ORIGEM="/var/www"
DESTINO="/var/backup"
EXCLUIR="arquivos/ *.mp3 *.mp4 *.avi *.m4v *.mkv *.wav *.ogg *.oga"

RSYNC="$(which rsync)"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
CHOWN="$(which chown)"
CHMOD="$(which chmod)"
GZIP="$(which gzip)"

ANO="$(date +"%Y")"
MES="$(date +"%m")"
DIA="$(date +"%d")"

DESTINO_RSYNC="$DESTINO/site/$ANO/$MES/$DIA"
DESTINO_MYSQL="$DESTINO/banco/$ANO/$MES/$DIA"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

if [ -d $DESTINO_RSYNC ]; then
	DESTINO_FINAL=${DESTINO_RSYNC}.${TIMESTAMP}
else
	DESTINO_FINAL=${DESTINO_RSYNC}
fi

FILE=""
DBS=""

if [ "$EXCLUIR" != "" ];
then
	for exc in $EXCLUIR
	do
    	EXCL=${EXCL}"--exclude=${exc} "
	done
fi

[ ! -d $DESTINO ] && mkdir -p $DESTINO || :
[ ! -d $DESTINO_MYSQL ] && mkdir -p $DESTINO_MYSQL || :
#[ ! -d $DESTINO_RSYNC ] && mkdir -p $DESTINO_RSYNC || :
[ ! -d $DESTINO_FINAL ] && mkdir -p $DESTINO_FINAL || :

#$CHOWN 0.0 -R $DEST_MYSQL
#$CHMOD 0600 $DEST_MYSQL

IGGY="test mysql information_schema"
DBS="$($MYSQL -u$USUARIO -p$SENHA -Bse 'show databases')"

for db in $DBS
do
	skipdb=-1
	if [ "$IGGY" != "" ];
	then
		for i in $IGGY
		do
			[ "$db" == "$i" ] && skipdb=1 || :
		done
	fi

	if [ "$skipdb" == "-1" ] ; then
		FILE="$DESTINO_MYSQL/$db.sql"
		if [ -f $FILE ]; then
			$MYSQLDUMP -u$USUARIO -p$SENHA $db | $GZIP -9 > ${FILE}.${TIMESTAMP}
		else
			$MYSQLDUMP -u$USUARIO -p$SENHA $db | $GZIP -9 > $FILE
		fi
	fi
done

$RSYNC -avq ${ORIGEM}/ ${DESTINO_FINAL}/ $EXCL

echo "Backup efetuado em: $(date)" >> /var/log/backup.log
echo "-------------------------------------------------------" >> /var/log/backup.log
