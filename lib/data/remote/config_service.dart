// lib/data/remote/config_service.dart
// ROADSoS - Config Service

import '../../core/models/country_config_model.dart';
import 'api_client.dart';

class ConfigService {
  ConfigService();

  static Future<List<CountryConfigModel>> fetchCountryConfigs() async {
    try {
      final response = await ApiClient.instance.get('/config/countries');
      
      if (response.data != null && response.data is List) {
        return (response.data as List)
            .map((json) => CountryConfigModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return CountryConfigModel.defaults;
    } catch (e) {
      // Graceful degradation: always has a fallback
      return CountryConfigModel.defaults;
    }
  }
}
