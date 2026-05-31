// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'ROADSoS';

  @override
  String get tagline => 'Road Accident Emergency Operating System';

  @override
  String get sosButton => 'SOS';

  @override
  String get discoverPrompt => 'SOS દબાવીને આપાતકાલીન સહાય પ્રારંભ કરો.';

  @override
  String get triageTitle => 'Quick Assessment';

  @override
  String get triageQ1 => 'Is anyone injured?';

  @override
  String get triageQ2 =>
      'Are there serious symptoms (unconscious, bleeding, breathing difficulty)?';

  @override
  String get triageQ3 =>
      'Is there an immediate hazard (fire, fuel leak, oncoming traffic)?';

  @override
  String get yes => 'હાં';

  @override
  String get no => 'ના';

  @override
  String get notSure => 'ખાતરી નથી';

  @override
  String get dispatchTitle => 'આપાતકાલીન સેવાઓ';

  @override
  String get callNow => 'હમણાં કૉલ કરો';

  @override
  String get sendSms => 'SMS મોકલો';

  @override
  String get alertFamily => 'કુટુંબને સૂચિત કરો';

  @override
  String get waitingTitle => 'મદદ માર્ગમાં છે';

  @override
  String get elapsed => 'Elapsed';

  @override
  String get stayCalm => 'શાંત રહો. આપાતકાલીન સેવાઓ સંપર્ક કરવામાં આવી છે.';

  @override
  String get resolutionTitle => 'ઘટનાઓની રિપોર્ટ';

  @override
  String get saveReport => 'રિપોર્ટ સાચવો';

  @override
  String get shareReport => 'રિપોર્ટ શેર કરો';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get familyContacts => 'Family Contacts';

  @override
  String get addContact => 'Add Contact';

  @override
  String get offline => 'Offline';

  @override
  String get distanceLessThan100m => 'Less than 100m';

  @override
  String get critical => 'CRITICAL';

  @override
  String get urgent => 'URGENT';

  @override
  String get nonEmergency => 'NON-EMERGENCY';

  @override
  String get hospital => 'Hospital';

  @override
  String get ambulance => 'Ambulance';

  @override
  String get police => 'Police';

  @override
  String get towing => 'Towing Service';

  @override
  String get puncture => 'Puncture Shop';

  @override
  String get showroom => 'Showroom';

  @override
  String get verifiedToday => 'Verified today';

  @override
  String get bystanderMode => 'Bystander Mode';

  @override
  String get coordinationTitle => 'Coordination';

  @override
  String get thankYou => 'ROADSoS ઉપયોગ કરવા બદલ આભાર';
}
