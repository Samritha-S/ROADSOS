import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('ta'),
    Locale('te')
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'ROADSoS'**
  String get appTitle;

  /// App tagline shown on home screen
  ///
  /// In en, this message translates to:
  /// **'Road Accident Emergency Operating System'**
  String get tagline;

  /// SOS trigger button label
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sosButton;

  /// Idle screen prompt
  ///
  /// In en, this message translates to:
  /// **'Tap SOS to start emergency assistance.'**
  String get discoverPrompt;

  /// Triage screen title
  ///
  /// In en, this message translates to:
  /// **'Quick Assessment'**
  String get triageTitle;

  /// Triage question 1
  ///
  /// In en, this message translates to:
  /// **'Is anyone injured?'**
  String get triageQ1;

  /// Triage question 2
  ///
  /// In en, this message translates to:
  /// **'Are there serious symptoms (unconscious, bleeding, breathing difficulty)?'**
  String get triageQ2;

  /// Triage question 3
  ///
  /// In en, this message translates to:
  /// **'Is there an immediate hazard (fire, fuel leak, oncoming traffic)?'**
  String get triageQ3;

  /// Yes label
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No label
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Not sure label
  ///
  /// In en, this message translates to:
  /// **'Not Sure'**
  String get notSure;

  /// Dispatch screen title
  ///
  /// In en, this message translates to:
  /// **'Emergency Services'**
  String get dispatchTitle;

  /// Call button
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNow;

  /// SMS button
  ///
  /// In en, this message translates to:
  /// **'Send SMS'**
  String get sendSms;

  /// Family alert button
  ///
  /// In en, this message translates to:
  /// **'Alert Family'**
  String get alertFamily;

  /// Waiting screen title
  ///
  /// In en, this message translates to:
  /// **'Help is on the way'**
  String get waitingTitle;

  /// Elapsed time label
  ///
  /// In en, this message translates to:
  /// **'Elapsed'**
  String get elapsed;

  /// Waiting screen reassurance message
  ///
  /// In en, this message translates to:
  /// **'Stay calm. Emergency services have been contacted.'**
  String get stayCalm;

  /// Resolution screen title
  ///
  /// In en, this message translates to:
  /// **'Incident Report'**
  String get resolutionTitle;

  /// Save report button
  ///
  /// In en, this message translates to:
  /// **'Save Incident Report'**
  String get saveReport;

  /// Share report button
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get shareReport;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Country selector label
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// Family contacts section
  ///
  /// In en, this message translates to:
  /// **'Family Contacts'**
  String get familyContacts;

  /// Add contact button
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// Offline banner label
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Distance display for very close facilities
  ///
  /// In en, this message translates to:
  /// **'Less than 100m'**
  String get distanceLessThan100m;

  /// Critical priority label
  ///
  /// In en, this message translates to:
  /// **'CRITICAL'**
  String get critical;

  /// Urgent priority label
  ///
  /// In en, this message translates to:
  /// **'URGENT'**
  String get urgent;

  /// Non-emergency priority label
  ///
  /// In en, this message translates to:
  /// **'NON-EMERGENCY'**
  String get nonEmergency;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get ambulance;

  /// No description provided for @police.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get police;

  /// No description provided for @towing.
  ///
  /// In en, this message translates to:
  /// **'Towing Service'**
  String get towing;

  /// No description provided for @puncture.
  ///
  /// In en, this message translates to:
  /// **'Puncture Shop'**
  String get puncture;

  /// No description provided for @showroom.
  ///
  /// In en, this message translates to:
  /// **'Showroom'**
  String get showroom;

  /// No description provided for @verifiedToday.
  ///
  /// In en, this message translates to:
  /// **'Verified today'**
  String get verifiedToday;

  /// Bystander screen title
  ///
  /// In en, this message translates to:
  /// **'Bystander Mode'**
  String get bystanderMode;

  /// Coordination screen title
  ///
  /// In en, this message translates to:
  /// **'Coordination'**
  String get coordinationTitle;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using ROADSoS'**
  String get thankYou;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'bn',
        'de',
        'en',
        'es',
        'fr',
        'gu',
        'hi',
        'kn',
        'ml',
        'mr',
        'ta',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
