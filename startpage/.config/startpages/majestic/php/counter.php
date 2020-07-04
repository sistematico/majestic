<?php

// ini_set('display_errors', 'On');
// error_reporting(E_ALL);

$path = 'txt/counter.txt';

if (is_readable($path)) {
    $file  = fopen( $path, 'r' );
    $count = fgets( $file, 1000 );
    fclose( $file );
    $count = abs( intval( $count ) ) + 1;
    echo "{$count} views";
}

$file = fopen($path, 'w');
fwrite($file, $count);
fclose($file);