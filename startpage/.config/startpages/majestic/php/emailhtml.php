<?php

foreach($_POST as $key => $value) {
	if (empty($value)) {
		echo "O campo <strong>" . $key . "</strong> não pode estar vazio";
		exit;
	}	
}

extract($_POST);

$to = 'contato@lucasbrum.net';
$from = 'no-reply@lucasbrum.net';

$headers = 'MIME-Version: 1.0' . "\r\n";
$headers .= 'Content-type: text/html; charset=utf-8' . "\r\n";
$headers .= "From: \"Site\" <" . $from . ">\r\n" . 'Reply-To: ' . $from . "\r\n" . 'X-Mailer: PHP/' . phpversion();

$body = "Nome: " . $nome . "<br /><br />";
$body .= "E-mail: " . $email . "<br /><br />";
$body .= "País: " . $pais . "<br /><br />";
$body .= "Assunto: " . $assunto . "<br /><br />";
$body .= "Mensagem: <br />" . $mensagem;

if (@mail($to, 'Contato do site', $body, $headers, '-f' . $from)) {
	echo 'E-mail enviado com sucesso';
} else {
	echo 'Erro ao enviar e-mail';
}

?>