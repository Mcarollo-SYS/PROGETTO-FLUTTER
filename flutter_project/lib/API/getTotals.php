<?php
// Header CORS: consente richieste da qualsiasi origine e definisce metodi e headers consentiti
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");  // Indica che la risposta sarà in JSON

// Dati di connessione al database
$host = "localhost";
$user = "root";
$password = "";
$db = "note_spese";

// Creo la connessione con il database MySQL
$conn = new mysqli($host, $user, $password, $db);

// Verifico che la connessione sia andata a buon fine
if ($conn->connect_error) {
    // Se la connessione fallisce, invio un codice 500 (errore server) e messaggio JSON
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Connessione fallita: " . $conn->connect_error]);
    exit; // Termino l'esecuzione dello script
}

// Controllo se il parametro GET 'utente_id' è presente
if (!isset($_GET['utente_id'])) {
    // Se manca, invio codice 400 (bad request) e messaggio JSON
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Parametro 'utente_id' mancante"]);
    exit;
}

// Converto l'ID utente in intero per sicurezza
$utente_id = intval($_GET['utente_id']);

// Query per calcolare la somma totale delle entrate per questo utente
$sqlEntrate = "SELECT SUM(importo) as totale_entrate FROM transazioni WHERE utente_id = ? AND tipo = 'entrata'";

// Preparo la query SQL
$stmtEntrate = $conn->prepare($sqlEntrate);
if (!$stmtEntrate) {
    // Se la preparazione fallisce, invio errore 500 e messaggio JSON
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nella preparazione della query entrate: " . $conn->error]);
    exit;
}

// Associo il parametro utente_id e eseguo la query
$stmtEntrate->bind_param("i", $utente_id);
$stmtEntrate->execute();

// Ottengo i risultati della query
$resultEntrate = $stmtEntrate->get_result();

// Inizializzo la variabile entrate a 0.0
$entrate = 0.0;

// Se ho risultati, recupero il valore totale delle entrate
if ($resultEntrate && $row = $resultEntrate->fetch_assoc()) {
    $entrate = floatval($row['totale_entrate']);  // converto in float
}
// Chiudo lo statement per la query entrate
$stmtEntrate->close();


// Query per calcolare la somma totale delle uscite per questo utente
$sqlUscite = "SELECT SUM(importo) as totale_uscite FROM transazioni WHERE utente_id = ? AND tipo = 'uscita'";

// Preparo la query SQL per le uscite
$stmtUscite = $conn->prepare($sqlUscite);
if (!$stmtUscite) {
    // Se la preparazione fallisce, invio errore 500 e messaggio JSON
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore nella preparazione della query uscite: " . $conn->error]);
    exit;
}

// Associo il parametro utente_id e eseguo la query
$stmtUscite->bind_param("i", $utente_id);
$stmtUscite->execute();

// Ottengo i risultati della query uscite
$resultUscite = $stmtUscite->get_result();

// Inizializzo la variabile uscite a 0.0
$uscite = 0.0;

// Se ho risultati, recupero il valore totale delle uscite
if ($resultUscite && $row = $resultUscite->fetch_assoc()) {
    $uscite = floatval($row['totale_uscite']);  // converto in float
}
// Chiudo lo statement per la query uscite
$stmtUscite->close();


// Invio la risposta JSON con codice 200 (OK) e i dati calcolati
http_response_code(200);
echo json_encode([
    "success" => true,
    "entrate" => $entrate,
    "uscite" => $uscite
]);

// Chiudo la connessione al database
$conn->close();
?>