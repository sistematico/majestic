<?php
$i = 0;
$i++;
$cfg['Servers'][$i]['DefaultConnectionCollation'] = 'utf8_general_ci';
$cfg['Servers'][$i]['hide_db'] = '^(information_schema|performance_schema|mysql|sys)$';
?>