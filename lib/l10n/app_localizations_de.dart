// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ROADSoS';

  @override
  String get tagline => 'Road Accident Emergency Operating System';

  @override
  String get sosButton => 'SOS';

  @override
  String get discoverPrompt =>
      'Tippen Sie auf SOS, um den Notfall‑Assistenten zu starten.';

  @override
  String get triageTitle => 'Schnelle Einschätzung';

  @override
  String get triageQ1 => 'Ist jemand verletzt?';

  @override
  String get triageQ2 =>
      'Gibt es schwere Symptome (Bewusstlosigkeit, Blutung, Atemnot)?';

  @override
  String get triageQ3 =>
      'Gibt es eine unmittelbare Gefahr (Brand, Kraftstoffleck, herannahender Verkehr)?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get notSure => 'Unsicher';

  @override
  String get dispatchTitle => 'Notfalldienste';

  @override
  String get callNow => 'Jetzt anrufen';

  @override
  String get sendSms => 'SMS senden';

  @override
  String get alertFamily => 'Familie benachrichtigen';

  @override
  String get waitingTitle => 'Hilfe unterwegs';

  @override
  String get elapsed => 'Verstrichen';

  @override
  String get stayCalm =>
      'Bleiben Sie ruhig. Die Notfalldienste wurden kontaktiert.';

  @override
  String get resolutionTitle => 'Vorfallsbericht';

  @override
  String get saveReport => 'Vorfallsbericht speichern';

  @override
  String get shareReport => 'Bericht teilen';

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
  String get thankYou => 'Danke für die Nutzung von ROADSoS';
}
