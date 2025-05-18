<?php
$host = 'localhost';
$db = 'nome_db'; // Sostituisci con il tuo DB
$user = 'root';
$pass = '';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Errore di connessione']));
}

// Imposta il content-type per JSON
header('Content-Type: application/json');

// Ricevi dati POST
$input = json_decode(file_get_contents("php://input"), true);

$nome = $input['nome'] ?? '';
$email = $input['email'] ?? '';
$telefono = $input['telefono'] ?? '';
$password = $input['password'] ?? '';
$confermaPassword = $input['conferma_password'] ?? '';

// Controllo campi obbligatori
if (empty($nome) || empty($email) || empty($telefono) || empty($password) || empty($confermaPassword)) {
    echo json_encode(['success' => false, 'message' => 'Tutti i campi sono obbligatori']);
    exit;
}

// Verifica corrispondenza password
if ($password !== $confermaPassword) {
    echo json_encode(['success' => false, 'message' => 'Le password non corrispondono']);
    exit;
}

// Verifica se l'email esiste già
$stmt_check = $conn->prepare("SELECT id FROM utenti WHERE email = ?");
$stmt_check->bind_param("s", $email);
$stmt_check->execute();
$stmt_check->store_result();

if ($stmt_check->num_rows > 0) {
    echo json_encode(['success' => false, 'message' => 'Email già registrata']);
    exit;
}
$stmt_check->close();

// Inserisci nuovo utente
$stmt_insert = $conn->prepare("INSERT INTO utenti (nome, email, telefono, password) VALUES (?, ?, ?, ?)");
$stmt_insert->bind_param("ssss", $nome, $email, $telefono, $password); // ⚠️ Usa hashing in produzione

if ($stmt_insert->execute()) {
    echo json_encode(['success' => true, 'message' => 'Registrazione completata con successo']);
} else {
    echo json_encode(['success' => false, 'message' => 'Errore durante la registrazione']);
}

$stmt_insert->close();
$conn->close();
?>
