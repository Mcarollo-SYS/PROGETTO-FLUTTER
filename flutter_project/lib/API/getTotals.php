<?php
$host = 'localhost';
$db = 'nome_db';
$user = 'root';
$pass = '';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(['error' => 'Connessione fallita']));
}

$utente_id = intval($_GET['utente_id']); // esempio: /get_totals.php?utente_id=1

$response = [];

// Totale Entrate
$sql_entrate = "SELECT SUM(importo) AS totale_entrate FROM transazioni WHERE tipo = 'Entrata' AND utente_id = $utente_id";
$result_entrate = $conn->query($sql_entrate);
$response['entrate'] = $result_entrate->fetch_assoc()['totale_entrate'] ?? 0.00;

// Totale Uscite
$sql_uscite = "SELECT SUM(importo) AS totale_uscite FROM transazioni WHERE tipo = 'Uscita' AND utente_id = $utente_id";
$result_uscite = $conn->query($sql_uscite);
$response['uscite'] = $result_uscite->fetch_assoc()['totale_uscite'] ?? 0.00;

header('Content-Type: application/json');
echo json_encode($response);

$conn->close();
?>
