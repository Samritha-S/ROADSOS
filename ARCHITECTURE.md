# ARCHITECTURE.md — ROADSoS Architecture Documentation

**ROADSoS** is an offline-first emergency coordination system designed to guide road accident victims through the 6 phases of incident management.

## Project Positioning Statement
> "An offline-first, highly-reliable emergency coordination system designed for the IIT Madras CoERS National Road Safety Hackathon 2026, delivering rapid discovery, triage, dispatch, and waiting management to save lives on major highway corridors like NH-544."

---

## Technical Stack
- **Frontend**: Flutter (Dart)
- **Backend**: FastAPI (Python)
- **Database**: SQLite (via `sqflite` package in Flutter) & sqlite3 (Python Standard Library in Backend)
- **Maps**: `flutter_map` + OpenStreetMap (No Google Maps dependencies)
- **State Management**: GetX
- **HTTP Client**: Dio
- **SMS**: `flutter_sms` (for family alert initiation)
- **URL Launcher**: `url_launcher` (for emergency call triggers)
- **Text to Speech**: `flutter_tts` (for voice-read triage prompts)
- **Local Storage**: `sqflite` + `path_provider`
- **Permissions**: `permission_handler`
- **Connectivity**: `connectivity_plus`
- **UUID Generation**: `uuid`
- **Backend Server**: FastAPI + Uvicorn + sqlite3
- **Deployment Platform**: Railway

---

## Naming Conventions
- **Flutter files**: `snake_case` (e.g., `incident_state_machine.dart`)
- **Flutter classes**: `PascalCase` (e.g., `IncidentStateMachine`)
- **Flutter variables & methods**: `camelCase` (e.g., `currentIncidentState`)
- **Enums**: `PascalCase` for enum name, `SCREAMING_SNAKE_CASE` for values (e.g., `enum IncidentState { DISCOVERY, TRIAGE }`)
- **Models**: Always end in `_model.dart` / `Model` class suffix
- **Controllers**: Always end in `_controller.dart` / `Controller` class suffix
- **Screens**: Always end in `_screen.dart` / `Screen` class suffix
- **Widgets**: Always end in `_widget.dart` / `Widget` class suffix
- **Backend files**: `snake_case`
- **Backend classes**: `PascalCase`
- **Backend routes**: `/api/v1/[resource]`

---

## Color System (app_colors.dart)
All color design tokens inside ROADSoS strictly come from the centralized system:
- **background**: `#0A0A0A` (Near black — emergency mode background)
- **surface**: `#1A1A1A`
- **primary_red**: `#D32F2F` (SOS trigger only)
- **confirmed_green**: `#2E7D32`
- **warning_amber**: `#F57F17`
- **text_primary**: `#FFFFFF`
- **text_secondary**: `#B0B0B0`
- **card_background**: `#1E1E1E`
- **critical_red**: `#B71C1C`
- **urgent_orange**: `#E65100`
- **non_emergency_blue**: `#1565C0`

---

## 6 Incident States (In Order)
1. **Discovery** (Accident detection and bystander alert)
2. **Triage** (Fast assessment of victim severity)
3. **Dispatch** (Automatic recommendation and routing of closest emergency services)
4. **Coordination** (First responder, bystander, and family communication)
5. **Waiting** (Calm reassurance, real-time ETA monitoring, and countdown)
6. **Resolution** (Incident closure, logging, and feedback)

---

## Strict Architecture Rules

> [!IMPORTANT]
> **RULE 1**: Presentation layer (screens + widgets) **NEVER** contains business logic.
> 
> **RULE 2**: Screens only call controller methods. They **never** call repositories directly.
> 
> **RULE 3**: Controllers **never** call the database directly. They call repositories.
> 
> **RULE 4**: Repositories are the **only** layer that touches the database or API client.
> 
> **RULE 5**: The `incident_state_machine.dart` is the **single source of truth** for incident state.
> 
> **RULE 6**: No screen imports another screen directly. All navigation goes through `routes.dart`.
> 
> **RULE 7**: All colors come from `app_colors.dart`. No hardcoded color values anywhere in code.
> 
> **RULE 8**: All strings in the emergency flow come from `app_strings.dart`. No hardcoded strings.
