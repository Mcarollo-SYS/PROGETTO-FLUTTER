<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);


header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

header('Content-Type: application/json');

$conn = new mysqli("localhost", "root","", "progetto");
if ($conn->connect_error) {
    die(json_encode(["error" => "Connessione al DB fallita: " . $conn->connect_error]));
}
if ($_SERVER['REQUEST_METHOD'] == "GET") {
    if (isset($_GET["tipo"])) {
        // Somma importi per tipo specificato
        $tipo = $conn->real_escape_string($_GET["tipo"]); // sicurezza SQL injection
        $sql = "SELECT SUM(importo) AS totale FROM transazioni WHERE tipo = '$tipo'";
        $res = $conn->query($sql);

        if ($res && $res->num_rows > 0) {
            $row = $res->fetch_assoc();
            $totale = $row['totale'] ?? 0;
            echo json_encode(["tipo" => $tipo, "totale" => (float)$totale], JSON_NUMERIC_CHECK);
        } else {
            echo json_encode(["tipo" => $tipo, "totale" => 0], JSON_NUMERIC_CHECK);
        }

        $res->free();

    } else {
        // Ritorna tutte le transazioni
        $sql = "SELECT id, importo, tipo, descrizione, data FROM transazioni";
        $res = $conn->query($sql);

        $transazioni = [];

        if ($res) {
            while ($record = $res->fetch_assoc()) {
                $transazioni[] = $record;
            }
            $res->free();
        }

        echo json_encode($transazioni, JSON_NUMERIC_CHECK);
    }
}
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Prendi i dati JSON dal body della richiesta
    $data = json_decode(file_get_contents('php://input'), true);

    $importo = $conn->real_escape_string($data['importo'] ?? '');
    $tipo = $conn->real_escape_string($data['tipo'] ?? '');
    $descrizione = $conn->real_escape_string($data['descrizione'] ?? '');
    $data_transazione = date('Y-m-d'); // usa la data attuale, o modifica come vuoi

    if ($importo !== '' && ($tipo === 'entrata' || $tipo === 'uscita')) {
        $sql = "INSERT INTO transazioni (importo, tipo, descrizione, data) VALUES ('$importo', '$tipo', '$descrizione', '$data_transazione')";
        if ($conn->query($sql)) {
            echo json_encode(['success' => true, 'id' => $conn->insert_id]);
        } else {
            http_response_code(500);
            echo json_encode(['error' => 'Errore durante l\'inserimento']);
        }
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Dati mancanti o invalidi']);
    }
    exit;  // Esci subito dopo aver gestito POST
}

$conn->close();

?>
