<?php

$arquivo = 'curtidas.json';

if (!$json = file_get_contents($arquivo)) {
    $json = json_encode([
        ['id'=>1, 'curtidas'=>10],
        ['id'=>2,'curtidas'=>20],
        ['id'=>3,'curtidas'=>30]
    ]);

    $fp = fopen($arquivo, 'w');
    fwrite($fp, $json);
    fclose($fp);
}

$json = json_decode($json);

if (isset($_GET['like'])) {
    $id = (int) $_GET['like'];
    if (isset($json[$id]->curtidas)) {
        $json[$id]->curtidas++;
        file_put_contents($arquivo, json_encode($json));
    }
}

echo "<br /><br /><br />";

foreach ($json as $key => $value) {
    echo "POST #" . $key . " <a href='https://lucasbrum.net/php/curtidas?like=" . $key . "'>CURTIR (". $json[$key]->curtidas . ")</a> ";
}
