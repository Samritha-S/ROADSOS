import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'seed_data.dart';

class FauxDatabase implements Database {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (kIsWeb) {
      return FauxDatabase();
    }
    if (_database != null) return _database!;
    _database = await _initDB('roadsos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // TABLE: facilities
    await db.execute('''
      CREATE TABLE facilities (
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
    ''');

    // TABLE: incidents
    await db.execute('''
      CREATE TABLE incidents (
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
    ''');

    // TABLE: country_configs
    await db.execute('''
      CREATE TABLE country_configs (
        country_code TEXT PRIMARY KEY,
        country_name TEXT NOT NULL,
        emergency_number TEXT NOT NULL,
        ambulance_number TEXT NOT NULL,
        police_number TEXT NOT NULL,
        fire_number TEXT NOT NULL,
        primary_language_code TEXT NOT NULL,
        currency_code TEXT NOT NULL
      )
    ''');

    await _seedDefaultData(db);
  }

  Future<void> _seedDefaultData(Database db) async {
    await SeedData.insertAll(db);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
    _database = null;
  }
}
