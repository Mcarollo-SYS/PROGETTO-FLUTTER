<?php
// Header CORS per permettere richieste da qualsiasi origine,
// specificare gli header accettati e i metodi consentiti,
// e impostare il tipo di contenuto della risposta su JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");

// Connessione al database MySQL con i parametri di connessione
$conn = new mysqli("localhost", "root", "", "note_spese");

// Controllo della connessione
if ($conn->connect_error) {
    http_response_code(500); // Codice 500 Internal Server Error
    // Risposta JSON di errore in caso di connessione fallita
    echo json_encode(["success" => false, "message" => "Errore di connessione al database"]);
    exit; // Termina l'esecuzione dello script
}

// Query SQL per calcolare:
// SUM(importo) = somma totale degli importi (totale spese)
// AVG(importo) = media degli importi (spesa media)
// COUNT(*) = numero totale di record nella tabella "spese"
$sql = "SELECT SUM(importo) as totale, AVG(importo) as media, COUNT(*) as numero FROM spese";
$result = $conn->query($sql);

// Se la query va a buon fine e otteniamo almeno una riga di risultati
if ($result && $row = $result->fetch_assoc()) {
    http_response_code(200); // Codice 200 OK
    // Restituisce un JSON con i dati formattati:
    // - total e average formattati con 2 decimali, separatore decimale ',' e migliaia '.'
    // - transactions come numero intero
    echo json_encode([
        "success" => true,
        "total" => number_format($row["totale"], 2, ',', '.'),
        "average" => number_format($row["media"], 2, ',', '.'),
        "transactions" => (int)$row["numero"]
    ]);
} else {
    http_response_code(500); // Errore interno server in caso di fallimento query
    echo json_encode(["success" => false, "message" => "Errore nell'esecuzione della query"]);
}

// Chiusura della connessione al database
$conn->close();
?>