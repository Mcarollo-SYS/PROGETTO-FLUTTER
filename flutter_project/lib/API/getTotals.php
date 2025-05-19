<?php
header('Content-Type: application/json');

// Connessione al database
$host = "localhost";
$user = "tuo_utente";
$password = "tua_password";
$db = "nome_database";

$conn = new mysqli($host, $user, $password, $db);

// Controlla la connessione
if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connessione fallita: " . $conn->connect_error]);
    exit;
}

// Verifica se l'ID utente è stato fornito
if (!isset($_GET['utente_id'])) {
    echo json_encode(["success" => false, "message" => "Parametro 'utente_id' mancante"]);
    exit;
}

$utente_id = intval($_GET['utente_id']);

// Query per le entrate
$sqlEntrate = "SELECT SUM(importo) as totale_entrate FROM transazioni WHERE utente_id = $utente_id AND tipo = 'entrata'";
$resultEntrate = $conn->query($sqlEntrate);
$entrate = 0.0;
if ($resultEntrate && $row = $resultEntrate->fetch_assoc()) {
    $entrate = floatval($row['totale_entrate']);
}

// Query per le uscite
$sqlUscite = "SELECT SUM(importo) as totale_uscite FROM transazioni WHERE utente_id = $utente_id AND tipo = 'uscita'";
$resultUscite = $conn->query($sqlUscite);
$uscite = 0.0;
if ($resultUscite && $row = $resultUscite->fetch_assoc()) {
    $uscite = floatval($row['totale_uscite']);
}

// Risposta JSON
echo json_encode([
    "success" => true,
    "entrate" => $entrate,
    "uscite" => $uscite
]);

$conn->close();
?>