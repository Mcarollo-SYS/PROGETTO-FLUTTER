<div align="center">

# 📱 NoteSpese

### Personal Finance & Expense Tracker

**Flutter · PHP · MySQL · REST API · MVC**

<br>

<img src="https://img.shields.io/badge/Flutter-Dart-0d1117?style=for-the-badge&logo=flutter&logoColor=54C5F8" />
<img src="https://img.shields.io/badge/Backend-PHP-0d1117?style=for-the-badge&logo=php&logoColor=777BB4" />
<img src="https://img.shields.io/badge/Database-MySQL-0d1117?style=for-the-badge&logo=mysql&logoColor=4479A1" />
<img src="https://img.shields.io/badge/API-REST-0d1117?style=for-the-badge&logo=fastapi&logoColor=CFFF3E" />

<br><br>

> **Track it. Understand it. Control it.**

</div>

---

## 🧭 Project Overview

**NoteSpese** is a full-stack mobile application designed to manage personal finances through a structured combination of:

```text
┌─────────────────────────────────────────────────────────┐
│                    📱 FLUTTER APP                       │
│                                                         │
│  Authentication · Dashboard · Transactions · Filters    │
└─────────────────────────┬───────────────────────────────┘
                          │
                          │ HTTP / REST
                          ▼
┌─────────────────────────────────────────────────────────┐
│                     🌐 PHP API                          │
│                                                         │
│              MVC · Validation · Business Logic          │
└─────────────────────────┬───────────────────────────────┘
                          │
                          │ SQL
                          ▼
┌─────────────────────────────────────────────────────────┐
│                    🗄️ MySQL                            │
│                                                         │
│          Users · Transactions · Categories              │
└─────────────────────────────────────────────────────────┘
```

The application separates the **mobile interface**, **API layer** and **relational data layer**, creating a clear full-stack architecture.

---

# ✨ Core Features

<table>
<tr>
<td width="50%">

### 🔐 Authentication

User registration and login with password hashing and input validation.

</td>

<td width="50%">

### 📊 Financial Dashboard

Monthly overview of income, expenses and overall balance.

</td>
</tr>

<tr>
<td>

### 💸 Transactions

Create, edit and delete income and expense transactions.

</td>

<td>

### 🔎 Advanced Filters

Filter transactions by:

- Date range
- Category
- Transaction type

</td>
</tr>

<tr>
<td>

### 📈 Interactive Charts

Financial data represented through interactive charts using `fl_chart`.

</td>

<td>

### ☁️ Cloud Synchronization

Client-server communication allows persistent storage and multi-user data management.

</td>
</tr>
</table>

---

# 🏗️ Architecture

<details open>
<summary><b>📱 Frontend — Flutter</b></summary>

<br>

The mobile application is developed in **Flutter/Dart**.

State management is handled through:

```text
Provider
   │
   ├── Application State
   ├── User Session
   └── Financial Data
```

The frontend is responsible for:

- UI rendering
- User interaction
- Form validation
- State management
- API communication
- Data visualization

</details>

<details>
<summary><b>🌐 Backend — PHP REST API</b></summary>

<br>

The backend exposes RESTful endpoints used by the Flutter application.

```text
Request
   │
   ▼
Controller
   │
   ▼
Business Logic
   │
   ▼
Model
   │
   ▼
MySQL
   │
   ▼
JSON Response
```

The backend follows an **MVC-oriented architecture** to separate responsibilities between routing, business logic and persistence.

</details>

<details>
<summary><b>🗄️ Database — MySQL</b></summary>

<br>

MySQL provides relational persistence for application data.

Conceptually:

```text
USER
 │
 ├───────────────┐
 │               │
 ▼               ▼
ACCOUNT      TRANSACTIONS
                 │
          ┌──────┴──────┐
          ▼             ▼
      CATEGORY         TYPE
```

This structure allows financial records to remain associated with the correct user and category.

</details>

---

# 🔄 Data Flow

The application follows a client → API → database workflow.

```text
       USER ACTION
            │
            ▼
    ┌───────────────┐
    │ Flutter / UI  │
    └───────┬───────┘
            │
            │ HTTP
            ▼
    ┌───────────────┐
    │   REST API    │
    │      PHP      │
    └───────┬───────┘
            │
            │ Validate
            ▼
    ┌───────────────┐
    │ Business Logic│
    └───────┬───────┘
            │
            │ SQL
            ▼
    ┌───────────────┐
    │     MySQL     │
    └───────┬───────┘
            │
            │ Result
            ▼
    ┌───────────────┐
    │  JSON Response│
    └───────┬───────┘
            │
            ▼
    ┌───────────────┐
    │ Flutter State │
    └───────┬───────┘
            │
            ▼
       📊 UI UPDATE
```

---

# 📊 Financial Visualization

The dashboard transforms raw transaction data into useful financial information.

```text
TRANSACTIONS
     │
     ├── Income
     │
     └── Expenses
             │
             ▼
       Categorization
             │
             ▼
      Monthly Analysis
             │
       ┌─────┴─────┐
       ▼           ▼
   📈 Balance   🥧 Categories
```

Charts are rendered using **`fl_chart`**, allowing the application to visualize the distribution and evolution of financial data.

---

# 🔐 Security Layer

Security is considered across multiple layers of the application.

<details>
<summary><b>🔑 Authentication</b></summary>

<br>

Passwords are not stored as plaintext.

The backend uses **password hashing** before credentials are persisted.

</details>

<details>
<summary><b>🛡️ Input Validation</b></summary>

<br>

User-provided data is validated before being processed by the backend.

This helps reduce malformed requests and invalid data entering the application.

</details>

<details>
<summary><b>🌐 API Communication</b></summary>

<br>

The Flutter application communicates with the backend through HTTP requests to dedicated REST endpoints.

</details>

---

# 🧩 Technology Map

```text
                 NoteSpese
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
     Frontend      Backend      Database
        │            │            │
     Flutter         PHP         MySQL
        │            │
     Provider        MVC
        │            │
    fl_chart      REST API
        │            │
        └──────┬─────┘
               ▼
          HTTP Client
```

---

# 🛠️ Development

<details>
<summary><b>Prerequisites</b></summary>

<br>

Required technologies:

```text
Flutter SDK
Dart SDK
PHP
MySQL
Web Server
Git
```

</details>

<details>
<summary><b>Frontend</b></summary>

<br>

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

</details>

<details>
<summary><b>Backend</b></summary>

<br>

Configure the PHP API and database connection according to the local environment.

The backend must be reachable by the Flutter application through the configured API endpoint.

</details>

---

# 🧪 Application Workflow

```text
        ┌─────────────┐
        │    LOGIN    │
        └──────┬──────┘
               │
               ▼
        ┌─────────────┐
        │  DASHBOARD  │
        └──────┬──────┘
               │
        ┌──────┼──────┐
        ▼      ▼      ▼
     INCOME  EXPENSE  REPORTS
        │      │        │
        └──────┼────────┘
               ▼
        TRANSACTION LIST
               │
               ▼
          FILTER / EDIT
               │
               ▼
          DATABASE SYNC
```

---

# 📂 Project Components

```text
NoteSpese/
│
├── 📱 Flutter Application
│   ├── UI
│   ├── Provider
│   ├── HTTP Client
│   └── fl_chart
│
├── 🌐 PHP Backend
│   ├── Controllers
│   ├── Models
│   ├── REST Endpoints
│   └── Validation
│
└── 🗄️ MySQL
    ├── Users
    ├── Transactions
    └── Categories
```

---

# 🎯 Project Goals

NoteSpese was developed to explore the complete lifecycle of a modern mobile application:

```text
UI
 ↓
State Management
 ↓
HTTP Communication
 ↓
REST API
 ↓
Business Logic
 ↓
Database
 ↓
Data Visualization
```

The project therefore combines **mobile development**, **backend development**, **database design**, **API architecture** and **basic application security** in a single system.

---

# 📌 Project Status

<div align="center">

<img src="https://img.shields.io/badge/Architecture-Full--Stack-CFFF3E?style=for-the-badge&labelColor=0d1117">
<img src="https://img.shields.io/badge/Frontend-Flutter-CFFF3E?style=for-the-badge&labelColor=0d1117">
<img src="https://img.shields.io/badge/API-REST-CFFF3E?style=for-the-badge&labelColor=0d1117">
<img src="https://img.shields.io/badge/Database-MySQL-CFFF3E?style=for-the-badge&labelColor=0d1117">

</div>

---

<details>
<summary><b>📚 What this project demonstrates</b></summary>

<br>

- Mobile application development with Flutter
- State management using Provider
- REST API integration
- MVC-oriented backend architecture
- Relational database persistence
- CRUD operations
- Data filtering
- Financial data visualization
- Authentication
- Password hashing
- Input validation
- Client-server communication

</details>

---

<div align="center">

### 💻 Built to manage money through data.

`Flutter` · `Dart` · `PHP` · `MySQL` · `REST API` · `MVC`

</div>
