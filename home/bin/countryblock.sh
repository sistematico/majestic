#!/bin/bash
# Purpose: Block all traffic from AFGHANISTAN (af) and CHINA (CN). Use ISO code. #
# See url for more info - http://www.cyberciti.biz/faq/?p=3402
# Author: nixCraft <www.cyberciti.biz> under GPL v.2.0+
# -------------------------------------------------------------------------------
ISO="af za cn" 
 
### Set PATH ###
IPT=/sbin/iptables
WGET=/usr/bin/wget
EGREP=/bin/egrep
 
### No editing below ###
SPAMLIST="countrydrop"
ZONEROOT="/root/iptables"
DLROOT="http://www.ipdeny.com/ipblocks/data/countries"
 
cleanOldRules(){
$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X
$IPT -P INPUT ACCEPT
$IPT -P OUTPUT ACCEPT
$IPT -P FORWARD ACCEPT
}
 
# create a dir
[ ! -d $ZONEROOT ] && /bin/mkdir -p $ZONEROOT
 
# clean old rules
cleanOldRules
 
# create a new iptables list
$IPT -N $SPAMLIST
 
for c in $ISO
do 
	# local zone file
	tDB=$ZONEROOT/$c.zone
 
	# get fresh zone file
	$WGET -O $tDB $DLROOT/$c.zone
 
	# country specific log message
	SPAMDROPMSG="$c Country Drop"
 
	# get 
	BADIPS=$(egrep -v "^#|^$" $tDB)
	for ipblock in $BADIPS
	do
	   $IPT -A $SPAMLIST -s $ipblock -j LOG --log-prefix "$SPAMDROPMSG"
	   $IPT -A $SPAMLIST -s $ipblock -j DROP
	done
done
 
# Drop everything 
$IPT -I INPUT -j $SPAMLIST
$IPT -I OUTPUT -j $SPAMLIST
$IPT -I FORWARD -j $SPAMLIST
 
# call your other iptable script
# /path/to/other/iptables.sh
 
exit 0