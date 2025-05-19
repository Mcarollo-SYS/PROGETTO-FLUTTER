<?php
header("Content-Type: application/json");
require 'db.php';

$user_id = intval($_GET['user_id'] ?? 0);
if ($user_id <= 0) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'ID utente non valido']);
    exit;
}

$stmt = $conn->prepare("SELECT id, nome, email, telefono FROM utenti WHERE id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    http_response_code(404);
    echo json_encode(['success' => false, 'message' => 'Utente non trovato']);
    exit;
}

$user = $result->fetch_assoc();
echo json_encode(['success' => true, 'user' => $user]);
?>