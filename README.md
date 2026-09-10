# 📱 NoteSpese — Personal Finance & Expense Tracker

NoteSpese è un'applicazione mobile full-stack per la gestione e l'analisi della finanza personale. Permette agli utenti di tracciare entrate e uscite, categorizzare le transazioni e visualizzare report finanziari mensili tramite grafici interattivi[cite: 3].

---

## 🛠️ Tech Stack & Architettura

* **Frontend:** Flutter (Dart) con gestione dello stato tramite `Provider`[cite: 3]
* **Data Visualization:** `fl_chart` per la resa grafica del bilancio mensile[cite: 3]
* **Backend:** PHP (API RESTful) basato su architettura **MVC**[cite: 3]
* **Database:** MySQL per la persistenza dei dati relazionali[cite: 3]
* **Network & Security:** HTTP Client, password hashing e validazione degli input[cite: 3]

---

## 🚀 Funzionalità Principali

* 🔐 **Autenticazione Sicura:** Login e registrazione con memorizzazione protetta delle credenziali (password hashing)[cite: 3].
* 📊 **Dashboard & Grafici:** Visualizzazione sintetica del bilancio mensile e ripartizione delle spese per categoria[cite: 3].
* ➕ **Gestione Transazioni:** Aggiunta, modifica e rimozione di entrate e uscite[cite: 3].
* 🔍 **Filtri Avanzati:** Filtraggio dinamico per intervallo di date, categoria e tipo di transazione[cite: 3].
* 🔄 **Sincronizzazione Cloud:** Comunicazione client-server per la persistenza e il supporto multiutenza[cite: 3].

---

## 🏗️ Struttura del Progetto

```text
PROGETTO-FLUTTER/
├── lib/
│   ├── models/        # Modelli dati (User, Transaction, Category)
│   ├── providers/     # Logica di stato e gestione API (Provider)
│   ├── screens/       # Interfacce utente (Dashboard, Login, Charts)
│   └── widgets/       # Componenti UI riutilizzabili
├── backend_php/       # Endpoint API RESTful e script SQL per MySQL
└── pubspec.yaml       # Dipendenze del progetto
