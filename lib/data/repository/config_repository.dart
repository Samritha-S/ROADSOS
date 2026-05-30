// lib/data/repository/config_repository.dart
// ROADSoS - Config Repository

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/models/country_config_model.dart';
import '../local/database_helper.dart';
import '../remote/config_service.dart';

class ConfigRepository {
  ConfigRepository();

  static final Map<String, CountryConfigModel> _webConfigs = {
    for (final config in CountryConfigModel.defaults) config.countryCode: config
  };

  static Future<CountryConfigModel> getConfigForCountry(String countryCode) async {
    if (kIsWeb) {
      final cached = _webConfigs[countryCode];
      if (cached != null) return cached;
      return CountryConfigModel.defaults.firstWhere(
        (c) => c.countryCode == countryCode,
        orElse: () => CountryConfigModel.defaults.first,
      );
    }

    try {
      final db = await DatabaseHelper.instance.database;
      
      // 1. Try local database
      final result = await db.query(
        'country_configs',
        where: 'country_code = ?',
        whereArgs: [countryCode],
      );

      if (result.isNotEmpty) {
        return CountryConfigModel.fromMap(result.first);
      }

      // 2. Try remote API (ConfigService handles its own fallback to defaults)
      final remoteConfigs = await ConfigService.fetchCountryConfigs();
      final targetConfig = remoteConfigs.firstWhere(
        (c) => c.countryCode == countryCode,
        orElse: () => CountryConfigModel.defaults.firstWhere(
          (c) => c.countryCode == countryCode,
          orElse: () => CountryConfigModel.defaults.first,
        ),
      );

      // Save it locally for next time
      await saveConfig(targetConfig);
      
      return targetConfig;
    } catch (e) {
      // Never throw — return fallback default safely
      return CountryConfigModel.defaults.firstWhere(
        (c) => c.countryCode == countryCode,
        orElse: () => CountryConfigModel.defaults.first,
      );
    }
  }

  static Future<void> saveConfig(CountryConfigModel config) async {
    if (kIsWeb) {
      _webConfigs[config.countryCode] = config;
      return;
    }

    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert(
        'country_configs',
        config.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Never throw from config saves
    }
  }

  static Future<List<CountryConfigModel>> getAllConfigs() async {
    if (kIsWeb) {
      return _webConfigs.values.toList();
    }

    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query('country_configs');

      if (result.isEmpty) {
        return CountryConfigModel.defaults;
      }

      return result.map((map) => CountryConfigModel.fromMap(map)).toList();
    } catch (e) {
      return CountryConfigModel.defaults;
    }
  }
}
