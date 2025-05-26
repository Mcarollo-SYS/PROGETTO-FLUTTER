<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); // solo per test

$mysqli = new mysqli("localhost", "tuo_utente", "tua_password", "tuo_database");

if ($mysqli->connect_errno) {
    http_response_code(500);
    echo json_encode(["error" => "Connessione al database fallita"]);
    exit();
}

$utente_id = isset($_GET['utente_id']) ? intval($_GET['utente_id']) : 0;
if ($utente_id <= 0) {
    http_response_code(400);
    echo json_encode(["error" => "Parametro utente_id mancante o non valido"]);
    exit();
}

$stmt = $mysqli->prepare("
    SELECT id, utente_id, importo, tipo, descrizione, data
    FROM transazioni
    WHERE utente_id = ?
    ORDER BY data DESC, id DESC
");
$stmt->bind_param('i', $utente_id);
$stmt->execute();
$result = $stmt->get_result();

$transazioni = [];
while ($row = $result->fetch_assoc()) {
    // Assicuriamoci di convertire i dati correttamente, es: importo in float e data in stringa
    $transazioni[] = [
        "id" => intval($row['id']),
        "utente_id" => intval($row['utente_id']),
        "importo" => floatval($row['importo']),
        "tipo" => $row['tipo'],
        "descrizione" => $row['descrizione'],
        "data" => $row['data'],
    ];
}

echo json_encode($transazioni);

$stmt->close();
$mysqli->close();
?>