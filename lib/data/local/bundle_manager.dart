// lib/data/local/bundle_manager.dart
// ROADSoS - Bundle Manager

import 'dart:math';

import 'database_helper.dart';

class BundleManager {
  BundleManager._();

  static const List<String> nh544Districts = [
    'Ranipet',
    'Vellore',
    'Salem',
    'Namakkal',
    'Erode',
    'Coimbatore',
  ];

  static Future<bool> isBundleAvailable(String districtName) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM facilities WHERE district = ? AND is_active = 1',
        [districtName],
      );
      
      if (result.isNotEmpty) {
        final count = Sqflite.firstIntValue(result) ?? 0;
        return count >= 3;
      }
      return false;
    } catch (e) {
      throw 'Failed to check bundle availability: $e';
    }
  }

  static Future<String> getCurrentDistrict(double latitude, double longitude) async {
    try {
      final db = await DatabaseHelper.instance.database;
      
      // Simple proximity approach: find nearest facility and return its district
      final result = await db.query(
        'facilities',
        columns: ['latitude', 'longitude', 'district'],
        where: 'is_active = 1',
      );
      
      if (result.isEmpty) {
        return 'Unknown';
      }

      String nearestDistrict = 'Unknown';
      double minDistance = double.infinity;

      for (final row in result) {
        final lat = row['latitude'] as double;
        final lon = row['longitude'] as double;
        
        final distance = _calculateDistance(latitude, longitude, lat, lon);
        if (distance < minDistance) {
          minDistance = distance;
          nearestDistrict = row['district'] as String;
        }
      }

      return nearestDistrict;
    } catch (e) {
      throw 'Failed to get current district: $e';
    }
  }

  static Future<List<String>> getAvailableDistricts() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery('SELECT DISTINCT district FROM facilities WHERE is_active = 1');
      
      return result.map((row) => row['district'] as String).toList();
    } catch (e) {
      throw 'Failed to fetch available districts: $e';
    }
  }

  // Simplified Euclidean distance approximation for nearest-neighbor 
  // since this is just identifying the closest facility district.
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;
    return sqrt((dLat * dLat) + (dLon * dLon));
  }
}

// Simple wrapper class to parse sqflite count results efficiently
class Sqflite {
  static int? firstIntValue(List<Map<String, dynamic>> list) {
    if (list.isNotEmpty && list.first.isNotEmpty) {
      final value = list.first.values.first;
      if (value is int) {
        return value;
      }
    }
    return null;
  }
}
