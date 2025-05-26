<?php
// Header CORS per permettere richieste da qualunque origine e definire i metodi e headers accettati
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json"); // Risposta in JSON

// Gestione della richiesta preflight OPTIONS (richiesta di verifica CORS da parte del browser)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit; // Interrompe l'esecuzione per le richieste OPTIONS
}

include "db.php";  // Inclusione del file di connessione al database

// Controllo della connessione al database
if ($conn->connect_error) {
    http_response_code(500); // Errore server
    echo json_encode(["success" => false, "message" => "Connessione fallita: " . $conn->connect_error]);
    exit;
}

// Recupero i dati JSON inviati nel body della richiesta POST
$data = json_decode(file_get_contents("php://input"));

// Recupero email e password, oppure null se mancanti
$email = $data->email ?? null;
$password = $data->password ?? null;

// Controllo se email o password sono vuoti o null
if (!$email || !$password) {
    http_response_code(400); // Bad request
    echo json_encode(["success" => false, "message" => "Email o password mancante"]);
    exit;
}

// Preparo la query SQL per cercare l'utente con email e password corrispondenti
$sql = "SELECT * FROM utenti WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sql);

// Controllo che la preparazione della query sia andata a buon fine
if (!$stmt) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore preparazione query: " . $conn->error]);
    exit;
}

// Associo i parametri email e password alla query (protezione da SQL injection)
$stmt->bind_param("ss", $email, $password);

// Eseguo la query
$stmt->execute();

// Ottengo il risultato
$result = $stmt->get_result();

// Se viene trovato almeno un record (utente valido)
if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    http_response_code(200); // OK
    echo json_encode(["success" => true, "message" => "Login ok", "user_id" => $user['id']]);
} else {
    // Se nessun utente corrisponde a email e password, rispondo con 401 Unauthorized
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Credenziali errate"]);
}

// Chiudo lo statement e la connessione al database
$stmt->close();
$conn->close();
?>