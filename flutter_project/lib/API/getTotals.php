<?php
// Header CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");

// Connessione al database
$host = "localhost";
$user = "root";
$password = "";
$db = "note_spese";

$conn = new mysqli($host, $user, $password, $db);

// Controlla la connessione
if ($conn->connect_error) {
    http_response_code(500); // Internal Server Error
    echo json_encode(["success" => false, "message" => "Connessione fallita: " . $conn->connect_error]);
    exit;
}

// Verifica se l'ID utente è stato fornito
if (!isset($_GET['utente_id'])) {
    http_response_code(400); // Bad Request
    echo json_encode(["success" => false, "message" => "Parametro 'utente_id' mancante"]);
    exit;
}

$utente_id = intval($_GET['utente_id']);

// Query per le entrate
$sqlEntrate = "SELECT SUM(importo) as totale_entrate FROM transazioni WHERE utente_id = ? AND tipo = 'entrata'";
$stmtEntrate = $conn->prepare($sqlEntrate);
if (!$stmtEntrate) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nella preparazione della query entrate: " . $conn->error]);
    exit;
}
$stmtEntrate->bind_param("i", $utente_id);
$stmtEntrate->execute();
$resultEntrate = $stmtEntrate->get_result();
$entrate = 0.0;
if ($resultEntrate && $row = $resultEntrate->fetch_assoc()) {
    $entrate = floatval($row['totale_entrate']);
}
$stmtEntrate->close();

// Query per le uscite
$sqlUscite = "SELECT SUM(importo) as totale_uscite FROM transazioni WHERE utente_id = ? AND tipo = 'uscita'";
$stmtUscite = $conn->prepare($sqlUscite);
if (!$stmtUscite) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nella preparazione della query uscite: " . $conn->error]);
    exit;
}
$stmtUscite->bind_param("i", $utente_id);
$stmtUscite->execute();
$resultUscite = $stmtUscite->get_result();
$uscite = 0.0;
if ($resultUscite && $row = $resultUscite->fetch_assoc()) {
    $uscite = floatval($row['totale_uscite']);
}
$stmtUscite->close();

// Risposta JSON
http_response_code(200); // OK
echo json_encode([
    "success" => true,
    "entrate" => $entrate,
    "uscite" => $uscite
]);

$conn->close();
?>