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
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Connessione fallita: " . $conn->connect_error]);
    exit;
}

// Recupero dati POST
$utente_id = $_POST['utente_id'] ?? null;
$descrizione = $_POST['descrizione'] ?? null;
$importo = $_POST['importo'] ?? null;
$tipo = $_POST['tipo'] ?? null;

// Controllo dati obbligatori
if (!$utente_id || !$descrizione || !$importo || !$tipo) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Dati mancanti: tutti i campi sono obbligatori"]);
    exit;
}

// Validazioni base
if (!is_numeric($utente_id) || !is_numeric($importo) || !in_array($tipo, ['entrata', 'uscita'])) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Dati non validi"]);
    exit;
}

$stmt = $conn->prepare("INSERT INTO transazioni (utente_id, descrizione, importo, tipo, data) VALUES (?, ?, ?, ?, NOW())");
if (!$stmt) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nella preparazione della query: " . $conn->error]);
    exit;
}

$stmt->bind_param("isds", $utente_id, $descrizione, $importo, $tipo);

if ($stmt->execute()) {
    http_response_code(201); // Created
    echo json_encode(["success" => true, "message" => "Transazione inserita con successo"]);
} else {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nell'inserimento: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>