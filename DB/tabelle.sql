CREATE DATABASE IF NOT EXISTS note_spese;
USE note_spese;

-- Tabella UTENTI
CREATE TABLE utenti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(20)
);

-- Tabella TRANSAZIONI
CREATE TABLE transazioni (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utente_id INT NOT NULL,
    descrizione VARCHAR(255) NOT NULL,
    importo DECIMAL(10,2) NOT NULL,
    tipo ENUM('entrata', 'uscita') NOT NULL,
    categoria VARCHAR(100), -- NUOVO CAMPO CATEGORIA (rendilo NOT NULL se obbligatorio)
    data DATE NOT NULL DEFAULT CURRENT_DATE, -- Campo data già presente

    FOREIGN KEY (utente_id) REFERENCES utenti(id) ON DELETE CASCADE
);