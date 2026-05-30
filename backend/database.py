import sqlite3
import os

DB_PATH = "roadsos_backend.db"

def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS facilities (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            phone TEXT NOT NULL,
            secondary_phone TEXT,
            service_type TEXT NOT NULL,
            emergency_tier TEXT NOT NULL,
            country_code TEXT NOT NULL,
            district TEXT NOT NULL,
            source_tier TEXT NOT NULL,
            confidence_score REAL NOT NULL,
            last_verified TEXT NOT NULL,
            is_active INTEGER NOT NULL DEFAULT 1
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS country_configs (
            country_code TEXT PRIMARY KEY,
            country_name TEXT NOT NULL,
            emergency_number TEXT NOT NULL,
            ambulance_number TEXT NOT NULL,
            police_number TEXT NOT NULL,
            fire_number TEXT NOT NULL,
            primary_language_code TEXT NOT NULL,
            currency_code TEXT NOT NULL
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS incidents (
            id TEXT PRIMARY KEY,
            created_at TEXT NOT NULL,
            latitude REAL,
            longitude REAL,
            triage_result TEXT,
            timeline TEXT NOT NULL DEFAULT '[]',
            services_contacted_ids TEXT NOT NULL DEFAULT '[]',
            family_alerted INTEGER NOT NULL DEFAULT 0,
            family_alerted_at TEXT,
            bystander_count INTEGER NOT NULL DEFAULT 0,
            current_state TEXT NOT NULL,
            resolved_at TEXT,
            country_code TEXT NOT NULL DEFAULT 'IN'
        )
    """)

    # Seed country configs if empty
    existing = cursor.execute(
        "SELECT COUNT(*) FROM country_configs"
    ).fetchone()[0]

    if existing == 0:
        configs = [
            ('IN', 'India', '112', '108', '100',
             '101', 'en_IN', 'INR'),
            ('US', 'United States', '911', '911',
             '911', '911', 'en_US', 'USD'),
            ('GB', 'United Kingdom', '999', '999',
             '999', '999', 'en_GB', 'GBP'),
        ]
        cursor.executemany("""
            INSERT OR REPLACE INTO country_configs
            VALUES (?,?,?,?,?,?,?,?)
        """, configs)

    # Seed sample NH-544 facilities if empty
    fac_count = cursor.execute(
        "SELECT COUNT(*) FROM facilities"
    ).fetchone()[0]

    if fac_count == 0:
        from data.seed_facilities import get_seed_facilities
        facilities = get_seed_facilities()
        cursor.executemany("""
            INSERT OR REPLACE INTO facilities
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        """, facilities)

    conn.commit()
    conn.close()
