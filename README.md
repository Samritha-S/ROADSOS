<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" />
  <img src="https://img.shields.io/badge/Gemini-8E75B2?style=for-the-badge&logo=google&logoColor=white" />
  <h1>🚨 RoadSOS 🚨</h1>
  <p><strong>When every second counts, SOS finds help.</strong></p>
  <p>An offline-first, AI-enhanced road emergency platform built for the "golden hour".</p>
</div>

---

## 📖 Overview

**RoadSOS** is an offline-first, location-based platform designed to address critical delays in emergency responses during a road accident. Standard SOS apps fail on remote highways due to poor network coverage. RoadSOS bypasses the cloud entirely by utilizing a highly-compressed local SQLite database and native hardware intents to dispatch SMS and voice calls.

## ✨ Key Features

*   🌍 **Offline-First Global Applicability:** Works completely offline using a local database mapped with OpenStreetMap data. Automatically adapts emergency numbers based on your country.
*   🚑 **Comprehensive Services:** Not just Police and Hospitals! Routes you to Towing, Puncture Shops, and Showrooms based on the emergency type.
*   🤖 **Gemini AI Triage:** An AI-powered interactive virtual paramedic that asks rapid Yes/No questions to evaluate scene priority and surfaces first-aid steps.
*   🗣️ **Native Multilingual Support:** Automatically adapts to your device's native language out-of-the-box, breaking down language barriers in a panic.
*   🤝 **Bystander Coordination:** Synchronize multiple bystanders to assign crucial roles like 'Traffic Control' and 'First Aid'.

## 🛠️ Architecture

RoadSOS uses a robust, scalable architecture to ensure reliability even with minimal connectivity.

1.  **Frontend:** Flutter & Dart (Cross-platform iOS/Android)
2.  **State Management:** GetX State Machine (`Idle` -> `Discovery` -> `Triage` -> `Dispatch`)
3.  **Local Storage:** SQLite (`sqflite`) containing over 100,000+ zero-latency nodes.
4.  **Hardware Access:** `geolocator` for precise GPS locking; `url_launcher` for native GSM dialing and SMS.

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK (stable)
*   Dart
*   Android Studio / VS Code

### Build Instructions

```bash
# 1. Clone the repository
git clone https://github.com/Samritha-S/ROADSOS.git
cd ROADSOS

# 2. Fetch dependencies
flutter clean
flutter pub get

# 3. Build & Run
flutter run          # Runs on connected device or emulator
flutter build apk    # Generates release Android Package
```

## 👥 Team Crash Free
Developed with ❤️ by **Team Crash Free** for the Hackathon.

*   **Samritha S** (Leader)
*   **Sandeep Annamalai**
*   **Hasvathi Magesh**
*   **Koushik Gnantej Battula**
*   **Ganapathy Lakshmanan**

---
<div align="center">
  <i>"Empowering bystanders to save lives, one tap at a time."</i>
</div>
