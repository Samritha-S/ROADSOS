// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ROADSoS';

  @override
  String get tagline => 'Road Accident Emergency Operating System';

  @override
  String get sosButton => 'SOS';

  @override
  String get discoverPrompt =>
      'Toque SOS para iniciar la asistencia de emergencia.';

  @override
  String get triageTitle => 'Evaluación Rápida';

  @override
  String get triageQ1 => '¿Alguien está herido?';

  @override
  String get triageQ2 =>
      '¿Hay síntomas graves (inconsciente, sangrado, dificultad para respirar)?';

  @override
  String get triageQ3 =>
      '¿Hay un peligro inmediato (fuego, fuga de combustible, tráfico en movimiento)?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get notSure => 'No estoy seguro';

  @override
  String get dispatchTitle => 'Servicios de Emergencia';

  @override
  String get callNow => 'Llamar ahora';

  @override
  String get sendSms => 'Enviar SMS';

  @override
  String get alertFamily => 'Alertar a la familia';

  @override
  String get waitingTitle => 'La ayuda está en camino';

  @override
  String get elapsed => 'Transcurrido';

  @override
  String get stayCalm =>
      'Mantenga la calma. Los servicios de emergencia han sido contactados.';

  @override
  String get resolutionTitle => 'Informe del Incidente';

  @override
  String get saveReport => 'Guardar Informe del Incidente';

  @override
  String get shareReport => 'Compartir Informe';

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
  String get thankYou => 'Gracias por usar ROADSoS';
}
