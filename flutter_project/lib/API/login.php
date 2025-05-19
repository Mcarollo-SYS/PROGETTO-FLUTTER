<?php
header("Content-Type: application/json");
include "db.php"; // file con connessione al database

$data = json_decode(file_get_contents("php://input"));

$email = $data->email;
$password = $data->password;

$sql = "SELECT * FROM utenti WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
  echo json_encode(["success" => true, "message" => "Login ok"]);
} else {
  echo json_encode(["success" => false, "message" => "Credenziali errate"]);
}

$conn->close();
?>