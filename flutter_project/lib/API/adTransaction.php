<?php
// Header CORS: permette richieste da qualsiasi origine e definisce i metodi e headers consentiti
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");  // Specifica che la risposta sarà in formato JSON

// Dati di connessione al database
$host = "localhost";
$user = "matteo";
$password = "";
$db = "note_spese";

// Creazione della connessione al database MySQL
$conn = new mysqli($host, $user, $password, $db);

// Controllo se la connessione ha avuto errori
if ($conn->connect_error) {
    // Se la connessione fallisce, rispondo con codice 500 e messaggio di errore in JSON
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Connessione fallita: " . $conn->connect_error]);
    exit;  // Termino lo script
}

// Recupero i dati inviati tramite POST, o null se non presenti
$utente_id = $_POST['utente_id'] ?? null;
$descrizione = $_POST['descrizione'] ?? null;
$importo = $_POST['importo'] ?? null;
$tipo = $_POST['tipo'] ?? null;

// Verifico che tutti i campi obbligatori siano stati forniti
if (!$utente_id || !$descrizione || !$importo || !$tipo) {
    // Se manca qualche dato, rispondo con codice 400 (bad request) e messaggio di errore
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Dati mancanti: tutti i campi sono obbligatori"]);
    exit;
}

// Validazioni di base sui dati: controllo che utente_id e importo siano numerici e tipo sia uno tra 'entrata' o 'uscita'
if (!is_numeric($utente_id) || !is_numeric($importo) || !in_array($tipo, ['entrata', 'uscita'])) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Dati non validi"]);
    exit;
}

// Preparo la query SQL per inserire la nuova transazione, con data impostata all'ora attuale (NOW())
$stmt = $conn->prepare("INSERT INTO transazioni (utente_id, descrizione, importo, tipo, data) VALUES (?, ?, ?, ?, NOW())");

// Controllo se la preparazione della query ha avuto successo
if (!$stmt) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nella preparazione della query: " . $conn->error]);
    exit;
}

// Associo i parametri alla query, specificando i tipi:
// i -> integer (utente_id), s -> stringa (descrizione), d -> double (importo), s -> stringa (tipo)
$stmt->bind_param("isds", $utente_id, $descrizione, $importo, $tipo);

// Eseguo la query
if ($stmt->execute()) {
    // Se l'inserimento ha successo, rispondo con codice 201 (created) e messaggio positivo
    http_response_code(201);
    echo json_encode(["success" => true, "message" => "Transazione inserita con successo"]);
} else {
    // Se l'inserimento fallisce, rispondo con codice 500 e messaggio di errore
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nell'inserimento: " . $stmt->error]);
}

// Chiudo lo statement e la connessione al database
$stmt->close();
$conn->close();
?>