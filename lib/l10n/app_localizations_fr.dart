// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ROADSoS';

  @override
  String get tagline => 'Road Accident Emergency Operating System';

  @override
  String get sosButton => 'SOS';

  @override
  String get discoverPrompt =>
      'Appuyez sur SOS pour démarrer l\'assistance d\'urgence.';

  @override
  String get triageTitle => 'Évaluation Rapide';

  @override
  String get triageQ1 => 'Quelqu\'un est-il blessé ?';

  @override
  String get triageQ2 =>
      'Y a-t-il des symptômes graves (inconscience, saignement, difficulté à respirer) ?';

  @override
  String get triageQ3 =>
      'Existe-t-il un danger immédiat (incendie, fuite de carburant, trafic en cours) ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get notSure => 'Pas sûr';

  @override
  String get dispatchTitle => 'Services d\'Urgence';

  @override
  String get callNow => 'Appeler maintenant';

  @override
  String get sendSms => 'Envoyer SMS';

  @override
  String get alertFamily => 'Alerter la famille';

  @override
  String get waitingTitle => 'L\'aide est en route';

  @override
  String get elapsed => 'Écoulé';

  @override
  String get stayCalm =>
      'Restez calme. Les services d\'urgence ont été contactés.';

  @override
  String get resolutionTitle => 'Rapport d\'Incident';

  @override
  String get saveReport => 'Enregistrer le Rapport d\'Incident';

  @override
  String get shareReport => 'Partager le Rapport';

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
  String get thankYou => 'Merci d\'avoir utilisé ROADSoS';
}
