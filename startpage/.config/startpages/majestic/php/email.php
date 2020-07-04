<?php

foreach($_POST as $key => $value) {
	if (empty($value)) {
		echo "ERRO: O campo <strong>" . $key . "</strong> não pode estar vazio";
		exit;
	}	
}

extract($_POST);

$to = 'contato@lucasbrum.net';
$from = 'noreply@lucasbrum.net';

$headers = 'MIME-Version: 1.0' . "\r\n";
$headers .= "From: \"Site\" <" . $from . ">\r\n" . "Reply-To: " . $from . "\r\n";
$headers .= "X-Mailer: PHP/" . phpversion();

$body = "Nome: " . $nome . "\n";
$body .= "E-mail: " . $email . "\n";
$body .= "Seção: " . $secao . "\n";
$body .= "Assunto: " . $assunto . "\n";
$body .= "Mensagem: \n\n" . $mensagem;

if (@mail($to, 'Contato do site: ' . $secao, $body, $headers, '-f' . $from)) {
	echo 'E-mail enviado com sucesso';
} else {
	echo 'Erro ao enviar e-mail';
}