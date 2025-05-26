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

// Codice originale di login
include "db.php";

if ($conn->connect_error) {
  echo json_encode(["success" => false, "message" => "Connessione fallita: " . $conn->connect_error]);
  exit;
}

$data = json_decode(file_get_contents("php://input"));

$email = $data->email ?? null;
$password = $data->password ?? null;

if (!$email || !$password) {
    echo json_encode(["success" => false, "message" => "Email o password mancante"]);
    exit;
}

$sql = "SELECT * FROM utenti WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if (!$stmt) {
  echo json_encode(["success" => false, "message" => "Errore preparazione query: " . $conn->error]);
  exit;
}

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode(["success" => true, "message" => "Login ok", "user_id" => $user['id']]);
} else {
    echo json_encode(["success" => false, "message" => "Credenziali errate"]);
}

$conn->close();
?>