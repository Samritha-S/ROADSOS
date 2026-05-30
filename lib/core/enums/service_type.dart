// lib/core/enums/service_type.dart
// ROADSoS - Service Type Enum

// ignore_for_file: constant_identifier_names

import 'emergency_tier.dart';

enum ServiceType {
  HOSPITAL,
  AMBULANCE,
  POLICE,
  TOWING,
  PUNCTURE,
  SHOWROOM
}

extension ServiceTypeExtension on ServiceType {
  String get displayName {
    switch (this) {
      case ServiceType.HOSPITAL:
        return 'Hospital';
      case ServiceType.AMBULANCE:
        return 'Ambulance';
      case ServiceType.POLICE:
        return 'Police';
      case ServiceType.TOWING:
        return 'Towing Service';
      case ServiceType.PUNCTURE:
        return 'Puncture Shop';
      case ServiceType.SHOWROOM:
        return 'Showroom';
    }
  }

  String get iconAsset {
    switch (this) {
      case ServiceType.HOSPITAL:
        return 'assets/icons/hospital.png';
      case ServiceType.AMBULANCE:
        return 'assets/icons/ambulance.png';
      case ServiceType.POLICE:
        return 'assets/icons/police.png';
      case ServiceType.TOWING:
        return 'assets/icons/towing.png';
      case ServiceType.PUNCTURE:
        return 'assets/icons/puncture.png';
      case ServiceType.SHOWROOM:
        return 'assets/icons/showroom.png';
    }
  }

  EmergencyTier get tier {
    switch (this) {
      case ServiceType.HOSPITAL:
      case ServiceType.AMBULANCE:
      case ServiceType.POLICE:
        return EmergencyTier.CRITICAL;
      case ServiceType.TOWING:
      case ServiceType.PUNCTURE:
      case ServiceType.SHOWROOM:
        return EmergencyTier.ROAD_SERVICE;
    }
  }
}
