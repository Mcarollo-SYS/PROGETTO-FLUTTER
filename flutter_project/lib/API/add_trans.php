<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$host = 'localhost';
$db   = 'nome_database';  // Cambia con il tuo DB
$user = 'nome_utente';    // Cambia con il tuo utente
$pass = 'password';       // Cambia con la tua password

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errore connessione DB']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Dati non validi']);
    exit;
}

$descrizione = $conn->real_escape_string($input['descrizione'] ?? '');
$importo = floatval($input['importo'] ?? 0);
$tipo = $conn->real_escape_string($input['tipo'] ?? '');
$data = $conn->real_escape_string($input['data'] ?? '');

if (empty($descrizione) || $importo <= 0 || !in_array($tipo, ['Entrata', 'Uscita']) || empty($data)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Parametri mancanti o non validi']);
    exit;
}

$sql = "INSERT INTO transazioni (descrizione, importo, tipo, data) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
if (!$stmt) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errore preparazione query']);
    exit;
}
$stmt->bind_param("sdss", $descrizione, $importo, $tipo, $data);

if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Transazione salvata']);
} else {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errore esecuzione query']);
}

$stmt->close();
$conn->close();
?>