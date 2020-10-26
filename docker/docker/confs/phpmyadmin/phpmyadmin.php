<?php
$i = 0;
$i++;
$cfg['Servers'][$i]['DefaultConnectionCollation'] = 'utf8_general_ci';
$cfg['Servers'][$i]['hide_db'] = '^(information_schema|performance_schema|mysql|sys)$';
//$cfg['Servers'][$i]['ssl'] = true;
//$cfg['Servers'][$i]['ssl_cert'] = '/etc/ssl/nginx/localhost.pem';
//$cfg['Servers'][$i]['ssl_key'] = '/etc/ssl/nginx/localhost-key.pem';
?>