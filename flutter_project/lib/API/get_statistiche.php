<?php
header('Content-Type: application/json');
require_once 'conn.php';

if (!isset($_GET['utente_id'])) {
    echo json_encode(['success' => false, 'message' => 'Utente ID mancante']);
    exit;
}

$utente_id = intval($_GET['utente_id']);

// Spesa totale (uscite)
$sqlTotale = "SELECT SUM(importo) as spesa_totale FROM transazioni WHERE utente_id = ? AND tipo = 'uscita'";
$stmtTotale = $conn->prepare($sqlTotale);
$stmtTotale->bind_param("i", $utente_id);
$stmtTotale->execute();
$resultTotale = $stmtTotale->get_result()->fetch_assoc();
$spesaTotale = $resultTotale['spesa_totale'] ?? 0.0;

// Media mensile (da bilanci)
$sqlMedia = "SELECT AVG(tot_uscite) as media_mensile FROM bilanci WHERE utente_id = ?";
$stmtMedia = $conn->prepare($sqlMedia);
$stmtMedia->bind_param("i", $utente_id);
$stmtMedia->execute();
$resultMedia = $stmtMedia->get_result()->fetch_assoc();
$mediaMensile = $resultMedia['media_mensile'] ?? 0.0;

// Numero totale transazioni
$sqlNumero = "SELECT COUNT(*) as totale_transazioni FROM transazioni WHERE utente_id = ?";
$stmtNumero = $conn->prepare($sqlNumero);
$stmtNumero->bind_param("i", $utente_id);
$stmtNumero->execute();
$resultNumero = $stmtNumero->get_result()->fetch_assoc();
$totaleTransazioni = $resultNumero['totale_transazioni'] ?? 0;

echo json_encode([
    'success' => true,
    'spesa_totale' => floatval($spesaTotale),
    'media_mensile' => floatval($mediaMensile),
    'numero_transazioni' => intval($totaleTransazioni),
]);
?>