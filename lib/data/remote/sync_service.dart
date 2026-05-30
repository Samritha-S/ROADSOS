// lib/data/remote/sync_service.dart
// ROADSoS - Sync Service

import '../../core/models/incident_model.dart';
import 'api_client.dart';

class SyncService {
  SyncService();

  static Future<bool> syncIncident(IncidentModel incident) async {
    try {
      final response = await ApiClient.instance.post(
        '/sync/incident',
        data: incident.toJson(),
      );
      
      // If the response is successful (e.g., 200/201), return true
      return response.statusCode != null && 
             response.statusCode! >= 200 && 
             response.statusCode! < 300;
    } catch (e) {
      // Never throws — always returns bool
      return false;
    }
  }
}
