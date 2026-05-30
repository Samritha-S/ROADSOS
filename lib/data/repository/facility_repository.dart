// lib/data/repository/facility_repository.dart
// ROADSoS - Facility Repository

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/enums/service_type.dart';
import '../../core/models/facility_model.dart';
import '../local/database_helper.dart';
import '../local/seed_data.dart';

class FacilityRepository {
  FacilityRepository();

  static List<FacilityModel>? _webFacilities;

  static List<FacilityModel> _getWebFacilities() {
    _webFacilities ??= List<FacilityModel>.from(SeedData.getSeedFacilities());
    return _webFacilities!;
  }

  static Future<List<FacilityModel>> getFacilitiesNearLocation({
    required double latitude,
    required double longitude,
    required String countryCode,
    double radiusKm = 50.0,
  }) async {
    if (kIsWeb) {
      final latMin = latitude - 0.5;
      final latMax = latitude + 0.5;
      final lonMin = longitude - 0.5;
      final lonMax = longitude + 0.5;

      return _getWebFacilities()
          .where((f) =>
              f.isActive &&
              f.countryCode == countryCode &&
              f.latitude >= latMin &&
              f.latitude <= latMax &&
              f.longitude >= lonMin &&
              f.longitude <= lonMax)
          .toList();
    }

    try {
      final db = await DatabaseHelper.instance.database;
      
      final latMin = latitude - 0.5;
      final latMax = latitude + 0.5;
      final lonMin = longitude - 0.5;
      final lonMax = longitude + 0.5;

      final result = await db.query(
        'facilities',
        where: 'is_active = 1 AND country_code = ? AND latitude BETWEEN ? AND ? AND longitude BETWEEN ? AND ?',
        whereArgs: [countryCode, latMin, latMax, lonMin, lonMax],
      );

      return result.map((map) => FacilityModel.fromMap(map)).toList();
    } catch (e) {
      throw 'Failed to fetch facilities near location: $e';
    }
  }

  static Future<List<FacilityModel>> getFacilitiesByServiceType({
    required ServiceType serviceType,
    required String countryCode,
  }) async {
    if (kIsWeb) {
      return _getWebFacilities()
          .where((f) =>
              f.isActive &&
              f.serviceType == serviceType &&
              f.countryCode == countryCode)
          .toList();
    }

    try {
      final db = await DatabaseHelper.instance.database;

      final result = await db.query(
        'facilities',
        where: 'is_active = 1 AND service_type = ? AND country_code = ?',
        whereArgs: [serviceType.name, countryCode],
      );

      return result.map((map) => FacilityModel.fromMap(map)).toList();
    } catch (e) {
      throw 'Failed to fetch facilities by service type: $e';
    }
  }

  static Future<void> insertFacility(FacilityModel facility) async {
    if (kIsWeb) {
      final list = _getWebFacilities();
      list.removeWhere((f) => f.id == facility.id);
      list.add(facility);
      return;
    }

    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert(
        'facilities',
        facility.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw 'Failed to insert facility: $e';
    }
  }

  static Future<void> insertFacilities(List<FacilityModel> facilities) async {
    if (kIsWeb) {
      final list = _getWebFacilities();
      for (final facility in facilities) {
        list.removeWhere((f) => f.id == facility.id);
        list.add(facility);
      }
      return;
    }

    try {
      final db = await DatabaseHelper.instance.database;
      final batch = db.batch();
      
      for (final facility in facilities) {
        batch.insert(
          'facilities',
          facility.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      
      await batch.commit(noResult: true);
    } catch (e) {
      throw 'Failed to batch insert facilities: $e';
    }
  }

  static Future<void> updateConfidenceScore(String facilityId, double newScore) async {
    if (kIsWeb) {
      final list = _getWebFacilities();
      final idx = list.indexWhere((f) => f.id == facilityId);
      if (idx != -1) {
        list[idx] = list[idx].copyWith(confidenceScore: newScore);
      }
      return;
    }

    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'facilities',
        {'confidence_score': newScore},
        where: 'id = ?',
        whereArgs: [facilityId],
      );
    } catch (e) {
      throw 'Failed to update confidence score for facility $facilityId: $e';
    }
  }

  static Future<int> getFacilityCount() async {
    if (kIsWeb) {
      return _getWebFacilities().length;
    }
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM facilities');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
