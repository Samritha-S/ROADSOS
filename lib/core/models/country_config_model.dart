// lib/core/models/country_config_model.dart
// ROADSoS - Country Config Model

class CountryConfigModel {
  final String countryCode;
  final String countryName;
  final String emergencyNumber;
  final String ambulanceNumber;
  final String policeNumber;
  final String fireNumber;
  final String primaryLanguageCode;
  final String currencyCode;

  const CountryConfigModel({
    required this.countryCode,
    required this.countryName,
    required this.emergencyNumber,
    required this.ambulanceNumber,
    required this.policeNumber,
    required this.fireNumber,
    required this.primaryLanguageCode,
    required this.currencyCode,
  });

  static List<CountryConfigModel> get defaults => const [
        CountryConfigModel(
          countryCode: 'IN',
          countryName: 'India',
          emergencyNumber: '112',
          ambulanceNumber: '108',
          policeNumber: '100',
          fireNumber: '101',
          primaryLanguageCode: 'en_IN',
          currencyCode: 'INR',
        ),
        CountryConfigModel(
          countryCode: 'US',
          countryName: 'United States',
          emergencyNumber: '911',
          ambulanceNumber: '911',
          policeNumber: '911',
          fireNumber: '911',
          primaryLanguageCode: 'en_US',
          currencyCode: 'USD',
        ),
        CountryConfigModel(
          countryCode: 'GB',
          countryName: 'United Kingdom',
          emergencyNumber: '999',
          ambulanceNumber: '999',
          policeNumber: '999',
          fireNumber: '999',
          primaryLanguageCode: 'en_GB',
          currencyCode: 'GBP',
        ),
      ];

  CountryConfigModel copyWith({
    String? countryCode,
    String? countryName,
    String? emergencyNumber,
    String? ambulanceNumber,
    String? policeNumber,
    String? fireNumber,
    String? primaryLanguageCode,
    String? currencyCode,
  }) {
    return CountryConfigModel(
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      emergencyNumber: emergencyNumber ?? this.emergencyNumber,
      ambulanceNumber: ambulanceNumber ?? this.ambulanceNumber,
      policeNumber: policeNumber ?? this.policeNumber,
      fireNumber: fireNumber ?? this.fireNumber,
      primaryLanguageCode: primaryLanguageCode ?? this.primaryLanguageCode,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country_code': countryCode,
      'country_name': countryName,
      'emergency_number': emergencyNumber,
      'ambulance_number': ambulanceNumber,
      'police_number': policeNumber,
      'fire_number': fireNumber,
      'primary_language_code': primaryLanguageCode,
      'currency_code': currencyCode,
    };
  }

  factory CountryConfigModel.fromMap(Map<String, dynamic> map) {
    return CountryConfigModel(
      countryCode: map['country_code'] as String,
      countryName: map['country_name'] as String,
      emergencyNumber: map['emergency_number'] as String,
      ambulanceNumber: map['ambulance_number'] as String,
      policeNumber: map['police_number'] as String,
      fireNumber: map['fire_number'] as String,
      primaryLanguageCode: map['primary_language_code'] as String,
      currencyCode: map['currency_code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'countryName': countryName,
      'emergencyNumber': emergencyNumber,
      'ambulanceNumber': ambulanceNumber,
      'policeNumber': policeNumber,
      'fireNumber': fireNumber,
      'primaryLanguageCode': primaryLanguageCode,
      'currencyCode': currencyCode,
    };
  }

  factory CountryConfigModel.fromJson(Map<String, dynamic> json) {
    return CountryConfigModel(
      countryCode: json['countryCode'] as String,
      countryName: json['countryName'] as String,
      emergencyNumber: json['emergencyNumber'] as String,
      ambulanceNumber: json['ambulanceNumber'] as String,
      policeNumber: json['policeNumber'] as String,
      fireNumber: json['fireNumber'] as String,
      primaryLanguageCode: json['primaryLanguageCode'] as String,
      currencyCode: json['currencyCode'] as String,
    );
  }
}
