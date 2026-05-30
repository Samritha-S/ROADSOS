// lib/data/repository/incident_repository.dart
// ROADSoS - Incident Repository

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/enums/incident_state.dart';
import '../../core/models/incident_model.dart';
import '../local/database_helper.dart';

class IncidentRepository {
  IncidentRepository();

  static final Map<String, IncidentModel> _webIncidents = {};

  static Future<void> saveIncident(IncidentModel incident) async {
    if (kIsWeb) {
      _webIncidents[incident.id] = incident;
      return;
    }

    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert(
        'incidents',
        incident.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw 'Failed to save incident: $e';
    }
  }

  static Future<IncidentModel?> getActiveIncident() async {
    if (kIsWeb) {
      if (_webIncidents.isEmpty) return null;
      final sorted = _webIncidents.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      for (final incident in sorted) {
        if (incident.currentState != IncidentState.RESOLVED) {
          return incident;
        }
      }
      return null;
    }

    try {
      final db = await DatabaseHelper.instance.database;
      
      final result = await db.query(
        'incidents',
        where: 'current_state != ?',
        whereArgs: [IncidentState.RESOLVED.name],
        orderBy: 'created_at DESC',
        limit: 1,
      );

      if (result.isNotEmpty) {
        return IncidentModel.fromMap(result.first);
      }
      return null;
    } catch (e) {
      throw 'Failed to get active incident: $e';
    }
  }

  static Future<List<IncidentModel>> getAllIncidents() async {
    if (kIsWeb) {
      return _webIncidents.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    try {
      final db = await DatabaseHelper.instance.database;
      
      final result = await db.query(
        'incidents',
        orderBy: 'created_at DESC',
      );

      return result.map((map) => IncidentModel.fromMap(map)).toList();
    } catch (e) {
      throw 'Failed to fetch all incidents: $e';
    }
  }

  static Future<void> markIncidentResolved(String incidentId) async {
    if (kIsWeb) {
      final incident = _webIncidents[incidentId];
      if (incident != null) {
        _webIncidents[incidentId] = incident.copyWith(
          currentState: IncidentState.RESOLVED,
          resolvedAt: DateTime.now(),
        );
      }
      return;
    }

    try {
      final db = await DatabaseHelper.instance.database;
      
      await db.update(
        'incidents',
        {
          'current_state': IncidentState.RESOLVED.name,
          'resolved_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [incidentId],
      );
    } catch (e) {
      throw 'Failed to mark incident as resolved: $e';
    }
  }
}
