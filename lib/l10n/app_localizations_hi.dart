// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'ROADSoS';

  @override
  String get tagline => 'Road Accident Emergency Operating System';

  @override
  String get sosButton => 'SOS';

  @override
  String get discoverPrompt =>
      'आपातकालीन सहायता शुरू करने के लिए SOS टैप करें।';

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
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get notSure => 'Not Sure';

  @override
  String get dispatchTitle => 'डिस्पैच सेवाएँ';

  @override
  String get callNow => 'Call Now';

  @override
  String get sendSms => 'Send SMS';

  @override
  String get alertFamily => 'Alert Family';

  @override
  String get waitingTitle => 'प्रतिक्रियाकर्ताओं की प्रतीक्षा';

  @override
  String get elapsed => 'Elapsed';

  @override
  String get stayCalm => 'Stay calm. Emergency services have been contacted.';

  @override
  String get resolutionTitle => 'घटना रिपोर्ट';

  @override
  String get saveReport => 'घटना रिपोर्ट सहेजें';

  @override
  String get shareReport => 'रिपोर्ट साझा करें';

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
  String get thankYou => 'ROADSoS का उपयोग करने के लिए धन्यवाद!';
}
