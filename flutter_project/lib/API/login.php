<?php
$host = 'localhost';
$db = 'nome_db';      
$user = 'root';       
$pass = '';           

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Errore di connessione']));
}

// Ottieni parametri da GET
$email = $_GET['email'] ?? '';
$password = $_GET['password'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode(['success' => false, 'message' => 'Email o password mancanti']);
    exit;
}

// Query per trovare l’utente
$stmt = $conn->prepare("SELECT id FROM utenti WHERE email = ? AND password = ?");
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode([
        'success' => true,
        'utente_id' => $row['id']
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Credenziali non valide'
    ]);
}

$stmt->close();
$conn->close();
?>
