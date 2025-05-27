<?php
// Header CORS (Access-Control-Allow-Origin: *, etc.)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: GET, OPTIONS"); // Solo GET e OPTIONS sono necessari
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Includi la connessione al DB centralizzata (raccomandato)
// require 'db.php'; 
// Se non usi db.php, definisci la connessione qui:
$conn = new mysqli("localhost", "root", "", "note_spese"); // Usa le tue credenziali

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore di connessione al database: " . $conn->connect_error]);
    exit;
}

// Recupera user_id dalla richiesta GET
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;

if ($user_id <= 0) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "ID utente non valido o mancante."]);
    exit;
}

// Query per calcolare le statistiche SULLE SOLE USCITE per l'utente specifico
// "totale" e "media" si riferiranno alle uscite. "numero" sarà il conteggio delle uscite.
$sql = "SELECT 
            SUM(importo) as totale_uscite, 
            AVG(importo) as media_uscite, 
            COUNT(*) as numero_uscite 
        FROM transazioni 
        WHERE utente_id = ? AND tipo = 'uscita'";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore preparazione query: " . $conn->error]);
    exit;
}

$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result && $row = $result->fetch_assoc()) {
    http_response_code(200);
    // I nomi dei campi ('total', 'average', 'transactions') devono corrispondere
    // a quelli che StatsScreen.dart si aspetta di ricevere.
    echo json_encode([
        "success" => true,
        "total" => number_format($row["totale_uscite"] ?? 0, 2, ',', '.'), // Spesa totale (uscite)
        "average" => number_format($row["media_uscite"] ?? 0, 2, ',', '.'), // Media delle uscite
        "transactions" => (int)($row["numero_uscite"] ?? 0) // Numero di transazioni di uscita
    ]);
} else {
    //  In caso di errore o se l'utente non ha uscite, restituisci valori a zero o un messaggio appropriato
    http_response_code(200); //  Potrebbe essere OK anche se non ci sono dati
    echo json_encode([
        "success" => true, //  O false se si considera un errore
        "total" => "0,00",
        "average" => "0,00",
        "transactions" => 0,
        // "message" => "Nessuna spesa trovata per l'utente." // Opzionale
    ]);
}

$stmt->close();
$conn->close();
?>