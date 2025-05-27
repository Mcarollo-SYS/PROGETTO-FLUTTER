<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "progetto");
if ($conn->connect_error) {
    die(json_encode(["error" => "Connessione al DB fallita: " . $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Statistiche avanzate
        if (isset($_GET["stat"])) {
            $stat = $_GET["stat"];

            if ($stat === "mediaMensile") {
                $sql = "SELECT YEAR(data) as anno, MONTH(data) as mese, SUM(importo) as totale
                        FROM transazioni
                        WHERE tipo = 'uscita'
                        GROUP BY YEAR(data), MONTH(data)";
                $res = $conn->query($sql);

                $totale = 0;
                $mesi = 0;

                if ($res) {
                    while ($row = $res->fetch_assoc()) {
                        $totale += (float)$row['totale'];
                        $mesi++;
                    }
                    $media = $mesi > 0 ? $totale / $mesi : 0;
                    echo json_encode(["media_mensile" => round($media, 2)], JSON_NUMERIC_CHECK);
                } else {
                    echo json_encode(["media_mensile" => 0]);
                }
            } elseif ($stat === "numeroTransazioni") {
                $sql = "SELECT COUNT(*) as totale FROM transazioni WHERE tipo='uscita'";
                $res = $conn->query($sql);
                if ($res && $res->num_rows > 0) {
                    $row = $res->fetch_assoc();
                    echo json_encode(["numero_transazioni" => (int)$row['totale']], JSON_NUMERIC_CHECK);
                } else {
                    echo json_encode(["numero_transazioni" => 0], JSON_NUMERIC_CHECK);
                }
            } else {
                echo json_encode(["error" => "Statistica non riconosciuta"]);
            }
            break;
        }

        // Statistica totale per tipo (es: tipo=uscita)
        if (isset($_GET["tipo"])) {
            $tipo = $conn->real_escape_string($_GET["tipo"]);
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
            // Recupera tutte le transazioni
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
        break;

    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);

        $importo = $conn->real_escape_string($data['importo'] ?? '');
        $tipo = $conn->real_escape_string($data['tipo'] ?? '');
        $descrizione = $conn->real_escape_string($data['descrizione'] ?? '');
        $data_transazione = $conn->real_escape_string($data['data'] ?? '');


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
        break;

    case 'PUT':
        parse_str(file_get_contents("php://input"), $put_vars);
        $id = $conn->real_escape_string($put_vars['id'] ?? '');
        $importo = $conn->real_escape_string($put_vars['importo'] ?? '');
        $tipo = $conn->real_escape_string($put_vars['tipo'] ?? '');
        $descrizione = $conn->real_escape_string($put_vars['descrizione'] ?? '');
        $data_transazione = $conn->real_escape_string($put_vars['data'] ?? '');

        if ($id && $importo && $tipo && $data_transazione) {
            $sql = "UPDATE transazioni SET importo='$importo', tipo='$tipo', descrizione='$descrizione', data='$data_transazione' WHERE id='$id'";
            if ($conn->query($sql)) {
                echo json_encode(['success' => true]);
            } else {
                http_response_code(500);
                echo json_encode(['error' => 'Errore durante l\'aggiornamento']);
            }
        } else {
            http_response_code(400);
            echo json_encode(['error' => 'Dati mancanti o invalidi']);
        }
        break;

    case 'DELETE':
        parse_str(file_get_contents("php://input"), $delete_vars);
        $id = $conn->real_escape_string($delete_vars['id'] ?? '');

        if ($id) {
            $sql = "DELETE FROM transazioni WHERE id = '$id'";
            if ($conn->query($sql)) {
                echo json_encode(['success' => true]);
            } else {
                http_response_code(500);
                echo json_encode(['error' => 'Errore durante l\'eliminazione']);
            }
        } else {
            http_response_code(400);
            echo json_encode(['error' => 'ID mancante']);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(['error' => 'Metodo non supportato']);
}

$conn->close();
?>
