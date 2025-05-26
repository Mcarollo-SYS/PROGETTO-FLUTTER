<?php
// Header CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");


// Dati connessione
$host = "localhost";
$user = "matteo";
$password = "";
$db = "note_spese";

$conn = new mysqli($host, $user, $password, $db);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connessione fallita"]);
    exit;
}

$utente_id = $_POST['utente_id'] ?? null;
$descrizione = $_POST['descrizione'] ?? null;
$importo = $_POST['importo'] ?? null;
$tipo = $_POST['tipo'] ?? null;

if (!$utente_id || !$descrizione || !$importo || !$tipo) {
    echo json_encode(["success" => false, "message" => "Dati mancanti"]);
    exit;
}

$stmt = $conn->prepare("INSERT INTO transazioni (utente_id, descrizione, importo, tipo, data) VALUES (?, ?, ?, ?, NOW())");
$stmt->bind_param("isds", $utente_id, $descrizione, $importo, $tipo);

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "message" => "Errore: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>