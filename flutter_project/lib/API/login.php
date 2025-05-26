<?php
// Header CORS (aggiungili all'inizio del file)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");

// Gestione preflight OPTIONS
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

include "db.php";

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Connessione fallita: " . $conn->connect_error]);
    exit;
}

$data = json_decode(file_get_contents("php://input"));

$email = $data->email ?? null;
$password = $data->password ?? null;

if (!$email || !$password) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Email o password mancante"]);
    exit;
}

// Prepara la query
$sql = "SELECT * FROM utenti WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Errore preparazione query: " . $conn->error]);
    exit;
}

$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    http_response_code(200);
    echo json_encode(["success" => true, "message" => "Login ok", "user_id" => $user['id']]);
} else {
    http_response_code(401); // Unauthorized
    echo json_encode(["success" => false, "message" => "Credenziali errate"]);
}

$stmt->close();
$conn->close();
?>