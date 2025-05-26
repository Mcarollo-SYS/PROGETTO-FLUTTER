<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); // solo per test, in produzione metti il dominio consentito

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

// Mese e anno corrente
$mese = date('n');
$anno = date('Y');

$stmt = $mysqli->prepare("
    SELECT id, utente_id, mese, anno, tot_entrate, tot_uscite, saldo
    FROM bilanci
    WHERE utente_id = ? AND mese = ? AND anno = ?
");
$stmt->bind_param('iii', $utente_id, $mese, $anno);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    // Se non esiste, restituisco dati vuoti (tutti a zero)
    echo json_encode([
        "id" => 0,
        "utente_id" => $utente_id,
        "mese" => $mese,
        "anno" => $anno,
        "tot_entrate" => 0,
        "tot_uscite" => 0,
        "saldo" => 0
    ]);
    exit();
}

$bilancio = $result->fetch_assoc();
echo json_encode($bilancio);

$stmt->close();
$mysqli->close();
?>