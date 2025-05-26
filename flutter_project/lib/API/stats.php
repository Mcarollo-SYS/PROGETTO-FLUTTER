<?php
// Header CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");



// Connessione al DB
$conn = new mysqli("localhost", "root", "", "note_spese");

if ($conn->connect_error) {
    http_response_code(500); // Errore interno server
    echo json_encode(["success" => false, "message" => "Errore di connessione al database"]);
    exit;
}

// Query dati di esempio
$sql = "SELECT SUM(importo) as totale, AVG(importo) as media, COUNT(*) as numero FROM spese";
$result = $conn->query($sql);

if ($result && $row = $result->fetch_assoc()) {
    http_response_code(200); // OK
    echo json_encode([
        "success" => true,
        "total" => number_format($row["totale"], 2, ',', '.'),
        "average" => number_format($row["media"], 2, ',', '.'),
        "transactions" => (int)$row["numero"]
    ]);
} else {
    http_response_code(500); // Errore interno server
    echo json_encode(["success" => false, "message" => "Errore nell'esecuzione della query"]);
}

$conn->close();
?>