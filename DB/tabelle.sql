-- 1. UTENTI
CREATE TABLE utenti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- 2. CATEGORIE
CREATE TABLE categorie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utente_id INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    icona VARCHAR(50), -- opzionale
    FOREIGN KEY (utente_id) REFERENCES utenti(id) ON DELETE CASCADE
);

-- 3. TRANSAZIONI
CREATE TABLE transazioni (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utente_id INT NOT NULL,
    categoria_id INT NOT NULL,
    importo DECIMAL(10,2) NOT NULL,
    tipo ENUM('entrata', 'uscita') NOT NULL,
    descrizione TEXT,
    data DATE NOT NULL,
    FOREIGN KEY (utente_id) REFERENCES utenti(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorie(id)
);

-- 4. BILANCI MENSILI
CREATE TABLE bilanci (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utente_id INT NOT NULL,
    mese INT NOT NULL, -- 1-12
    anno INT NOT NULL,
    tot_entrate DECIMAL(10,2) NOT NULL DEFAULT 0,
    tot_uscite DECIMAL(10,2) NOT NULL DEFAULT 0,
    saldo DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (utente_id) REFERENCES utenti(id) ON DELETE CASCADE,
    UNIQUE(utente_id, mese, anno) -- Un bilancio per mese per utente
);