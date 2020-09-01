dir="/home/lucas"
domains="majestic.radiochat.com.br"
echo url="https://www.duckdns.org/update?domains=${domains}&token=a7c4d0ad-114e-40ef-ba1d-d217904a50f2&ip=" | curl -k -o ${dir}/.duck.log -K -
