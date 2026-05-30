// lib/core/enums/source_tier.dart
// ROADSoS - Source Tier Enum

// ignore_for_file: constant_identifier_names

enum SourceTier {
  GOVERNMENT,
  MANUAL,
  OSM,
  COMMUNITY
}

extension SourceTierExtension on SourceTier {
  double get baseConfidence {
    switch (this) {
      case SourceTier.GOVERNMENT:
        return 0.9;
      case SourceTier.MANUAL:
        return 0.8;
      case SourceTier.OSM:
        return 0.7;
      case SourceTier.COMMUNITY:
        return 0.5;
    }
  }

  String get displayName {
    switch (this) {
      case SourceTier.GOVERNMENT:
        return 'Government Verified';
      case SourceTier.MANUAL:
        return 'Manually Added';
      case SourceTier.OSM:
        return 'OpenStreetMap';
      case SourceTier.COMMUNITY:
        return 'Community Sourced';
    }
  }
}
