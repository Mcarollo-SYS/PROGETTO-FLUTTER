<?php
// Header CORS per consentire richieste da qualsiasi origine,
// specificare gli header accettati e i metodi consentiti,
// e impostare il tipo di contenuto della risposta su JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");

// Inclusione del file di connessione al database
require 'db.php';

// Recupera l'ID utente dalla query string (GET), lo converte in intero
// Se non presente o <= 0, restituisce un errore 400 Bad Request
$user_id = intval($_GET['user_id'] ?? 0);
if ($user_id <= 0) {
    http_response_code(400); // Bad Request
    echo json_encode(['success' => false, 'message' => 'ID utente non valido']);
    exit; // Interrompe l'esecuzione del codice
}

// Prepara una query SQL per selezionare alcune colonne dell'utente con l'ID specificato
$stmt = $conn->prepare("SELECT id, nome, email, telefono FROM utenti WHERE id = ?");
$stmt->bind_param("i", $user_id); // Associa il parametro user_id alla query
$stmt->execute(); // Esegue la query
$result = $stmt->get_result(); // Ottiene il risultato della query

// Se non viene trovato alcun utente, risponde con errore 404 Not Found
if ($result->num_rows === 0) {
    http_response_code(404);
    echo json_encode(['success' => false, 'message' => 'Utente non trovato']);
    exit;
}

// Recupera i dati dell'utente come array associativo
$user = $result->fetch_assoc();

// Restituisce la risposta JSON con successo true e i dati utente
echo json_encode(['success' => true, 'user' => $user]);
?>