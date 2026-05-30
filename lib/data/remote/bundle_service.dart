// lib/data/remote/bundle_service.dart
// ROADSoS - Bundle Service

import '../../core/models/facility_model.dart';
import 'api_client.dart';

class BundleService {
  BundleService();

  static Future<List<FacilityModel>> fetchFacilitiesForDistrict(String district) async {
    try {
      final response = await ApiClient.instance.get('/bundles/$district');
      
      if (response.data != null && response.data is List) {
        return (response.data as List)
            .map((json) => FacilityModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      // Graceful degradation on error: return empty list
      return [];
    }
  }
}
