# RoadSOS: Technical Documentation & Hackathon Submission

## 1. Overview and Problem Addressed
**RoadSOS** is an offline-first, location-based platform designed to address the critical delays in emergency response that occur during the "golden hour" of a road accident. By integrating various emergency and vehicle rescue services into a single, easy-to-use interface, the platform enables faster coordination of emergency response and supports bystanders in taking immediate, life-saving action.

This tool bypasses the need for internet connectivity—a common point of failure on remote highways—by utilizing a localized database and raw hardware intents.

## 2. Key Aspects Included (Evaluation Mapping)

### 2.1. Nearest Police Station, Hospitals, Ambulance Services
The core routing algorithm of RoadSOS automatically calculates the Haversine distance between the user's raw GPS coordinates and our facility nodes. The system categorizes these services under the `CRITICAL` emergency tier (see `ServiceType` enum). 

### 2.2. Towing Services, Nearest Puncture Shops, and Showrooms
Not every emergency is life-threatening. If the user indicates through our interactive triage flow that the issue is vehicle-related (e.g., breakdown, flat tire), the application dynamically shifts routing to the `ROAD_SERVICE` tier. This specifically fetches nearby **Towing Services, Puncture Shops, and Showrooms**, seamlessly addressing all levels of highway incidents.

### 2.3. Global Applicability Across Countries
RoadSOS achieves high global scalability through its data pipeline:
*   **OpenStreetMap (Overpass API) Integration:** The underlying python pipeline fetches `amenity` nodes directly from OpenStreetMap, which provides global coverage. 
*   **Country Config Routing:** The application utilizes a `CountryConfigModel` which dynamically maps national emergency numbers (e.g., 112 for India, 911 for USA) based on the user's region, making the offline database applicable across any country border.

### 2.4. Offline Functionality and Robustness in Low-Network Conditions
This is the application's primary USP. Standard SOS apps fail when there is no 4G/5G data coverage.
*   **SQLite Database:** A hyper-compressed 5MB SQLite database is bundled directly into the application compile.
*   **Hardware Bypassing:** We use `url_launcher` and `permission_handler` to forcibly trigger the native cellular telecom layer. If a user has even a single bar of 2G Edge signal, RoadSOS will successfully dispatch SMS alerts and initiate voice calls without requiring an HTTP handshake to a cloud server.

## 3. Evaluation Criteria Met

### 3.1. Reliability and Data Accuracy
We engineered a `confidenceScore` and `sourceTier` metric for every node in the database. Facilities categorized as `SourceTier.GOVERNMENT` receive a higher confidence ranking than `SourceTier.COMMUNITY` nodes, ensuring that the routing algorithm prioritizes verified, high-accuracy contacts first.

### 3.2. Number of Contacts Fetched
By leveraging OpenStreetMap and a local SQLite database, the app can store and query over 100,000+ nodes instantly. There are no API rate limits during an emergency because the database is 100% local.

### 3.3. Innovation & Additional Features
*   **Gemini AI Interactive Triage:** An AI-powered triage system asks the bystander rapid YES/NO questions (e.g., "Is there heavy bleeding?") to dynamically evaluate the scene priority.
*   **Multilingual Support:** The app automatically reads the device's native language settings, immediately breaking down language barriers for bystanders in rural areas.
*   **Bystander Coordination:** An active incident timeline manages the scene to prevent the "bystander effect", allowing multiple responders to assign roles like 'Traffic Control' and 'First Aid'.

## 4. Technical Architecture
1.  **Frontend:** Flutter & Dart (Cross-platform iOS/Android).
2.  **State Management:** GetX (handles the strict state machine flow from `Idle` -> `Discovery` -> `Triage` -> `Dispatch`).
3.  **Local Storage:** SQLite (`sqflite` plugin for offline data).
4.  **Hardware Access:** `geolocator` for raw hardware GPS coordinates; `url_launcher` for native GSM dialing and SMS.

## 5. Build Instructions
```bash
# Ensure you are in the project root directory
flutter clean
flutter pub get
flutter build apk    # Generates the release Android Package
```
