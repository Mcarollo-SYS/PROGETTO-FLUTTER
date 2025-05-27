<?php
// Header CORS...
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS"); // Solo POST e OPTIONS sono necessari
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Connessione al DB (centralizzata o definita qui)
$conn = new mysqli("localhost", "matteo", "", "note_spese"); // Usa le tue credenziali

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Connessione fallita: " . $conn->connect_error]);
    exit;
}

// Recupero i dati inviati tramite POST
$utente_id = $_POST['utente_id'] ?? null;
$descrizione = $_POST['descrizione'] ?? null;
$importo = $_POST['importo'] ?? null;
$tipo = $_POST['tipo'] ?? null;
$categoria = $_POST['categoria'] ?? null; // NUOVO: Recupera categoria
$data_transazione = $_POST['data'] ?? null; // NUOVO: Recupera data

// Validazione di base
if (!$utente_id || !$descrizione || !$importo || !$tipo || !$data_transazione) { // Categoria potrebbe essere opzionale
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Dati mancanti. Utente, descrizione, importo, tipo e data sono obbligatori."]);
    exit;
}

if (!is_numeric($utente_id) || !is_numeric($importo) || !in_array($tipo, ['entrata', 'uscita'])) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Dati non validi per utente_id, importo o tipo."]);
    exit;
}

// Validazione formato data (YYYY-MM-DD)
if (!preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/", $data_transazione)) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Formato data non valido. Usare YYYY-MM-DD."]);
    exit;
}


// Inserisci 'categoria' e 'data' nella query
$stmt = $conn->prepare("INSERT INTO transazioni (utente_id, descrizione, importo, tipo, categoria, data) VALUES (?, ?, ?, ?, ?, ?)");

if (!$stmt) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nella preparazione della query: " . $conn->error]);
    exit;
}

// 's' per categoria (stringa), 's' per data (stringa YYYY-MM-DD)
$stmt->bind_param("isdsss", $utente_id, $descrizione, $importo, $tipo, $categoria, $data_transazione);

if ($stmt->execute()) {
    http_response_code(201);
    echo json_encode(["success" => true, "message" => "Transazione inserita con successo"]);
} else {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nell'inserimento: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>