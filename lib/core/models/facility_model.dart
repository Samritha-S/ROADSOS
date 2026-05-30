// lib/core/models/facility_model.dart
// ROADSoS - Facility Model

import '../enums/service_type.dart';
import '../enums/emergency_tier.dart';
import '../enums/source_tier.dart';

class FacilityModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String phone;
  final String? secondaryPhone;
  final ServiceType serviceType;
  final EmergencyTier emergencyTier;
  final String countryCode;
  final String district;
  final SourceTier sourceTier;
  final double confidenceScore;
  final DateTime lastVerified;
  final bool isActive;

  const FacilityModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.secondaryPhone,
    required this.serviceType,
    required this.emergencyTier,
    required this.countryCode,
    required this.district,
    required this.sourceTier,
    required this.confidenceScore,
    required this.lastVerified,
    required this.isActive,
  });

  bool get isHighConfidence => confidenceScore >= 0.7;

  String get verificationAge {
    final now = DateTime.now();
    final difference = now.difference(lastVerified);
    final days = difference.inDays;

    if (days <= 0) {
      return 'Verified today';
    } else if (days < 7) {
      return 'Verified $days days ago';
    } else if (days < 30) {
      final weeks = (days / 7).floor();
      return 'Verified $weeks ${weeks == 1 ? "week" : "weeks"} ago';
    } else {
      final months = (days / 30).floor();
      return 'Unverified — $months ${months == 1 ? "month" : "months"} ago';
    }
  }

  FacilityModel copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? phone,
    String? secondaryPhone,
    ServiceType? serviceType,
    EmergencyTier? emergencyTier,
    String? countryCode,
    String? district,
    SourceTier? sourceTier,
    double? confidenceScore,
    DateTime? lastVerified,
    bool? isActive,
  }) {
    return FacilityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      serviceType: serviceType ?? this.serviceType,
      emergencyTier: emergencyTier ?? this.emergencyTier,
      countryCode: countryCode ?? this.countryCode,
      district: district ?? this.district,
      sourceTier: sourceTier ?? this.sourceTier,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      lastVerified: lastVerified ?? this.lastVerified,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'secondary_phone': secondaryPhone,
      'service_type': serviceType.name,
      'emergency_tier': emergencyTier.name,
      'country_code': countryCode,
      'district': district,
      'source_tier': sourceTier.name,
      'confidence_score': confidenceScore,
      'last_verified': lastVerified.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory FacilityModel.fromMap(Map<String, dynamic> map) {
    return FacilityModel(
      id: map['id'] as String,
      name: map['name'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      phone: map['phone'] as String,
      secondaryPhone: map['secondary_phone'] as String?,
      serviceType: ServiceType.values.byName(map['service_type'] as String),
      emergencyTier: EmergencyTier.values.byName(map['emergency_tier'] as String),
      countryCode: map['country_code'] as String,
      district: map['district'] as String,
      sourceTier: SourceTier.values.byName(map['source_tier'] as String),
      confidenceScore: (map['confidence_score'] as num).toDouble(),
      lastVerified: DateTime.parse(map['last_verified'] as String),
      isActive: (map['is_active'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'secondaryPhone': secondaryPhone,
      'serviceType': serviceType.name,
      'emergencyTier': emergencyTier.name,
      'countryCode': countryCode,
      'district': district,
      'sourceTier': sourceTier.name,
      'confidenceScore': confidenceScore,
      'lastVerified': lastVerified.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String,
      secondaryPhone: json['secondaryPhone'] as String?,
      serviceType: ServiceType.values.byName(json['serviceType'] as String),
      emergencyTier: EmergencyTier.values.byName(json['emergencyTier'] as String),
      countryCode: json['countryCode'] as String,
      district: json['district'] as String,
      sourceTier: SourceTier.values.byName(json['sourceTier'] as String),
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      lastVerified: DateTime.parse(json['lastVerified'] as String),
      isActive: json['isActive'] as bool,
    );
  }
}
