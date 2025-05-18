<?php
$host = 'localhost';
$db = 'nome_database';
$user = 'root';
$pass = '';

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Errore di connessione']));
}

$descrizione = $_POST['descrizione'] ?? '';
$importo = $_POST['importo'] ?? 0;
$utente_id = 1; // usa l'ID dell'utente attivo
$categoria_id = 1; // puoi cambiarlo se hai categorie diverse

$stmt = $conn->prepare("INSERT INTO transazioni (utente_id, categoria_id, importo, tipo, descrizione, data) VALUES (?, ?, ?, 'Uscita', ?, CURDATE())");
$stmt->bind_param("iids", $utente_id, $categoria_id, $importo, $descrizione);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'message' => 'Errore nel salvataggio']);
}

$stmt->close();
$conn->close();
?>
