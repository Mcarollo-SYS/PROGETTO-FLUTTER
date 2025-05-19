<?php
$host = 'localhost';
$dbname = 'NOME_DATABASE';
$user = 'USERNAME';
$pass = 'PASSWORD';

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errore connessione DB']);
    exit;
}
$conn->set_charset('utf8');
?>