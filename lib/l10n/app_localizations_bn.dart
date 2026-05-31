// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ROADSoS';

  @override
  String get tagline => 'Road Accident Emergency Operating System';

  @override
  String get sosButton => 'SOS';

  @override
  String get discoverPrompt => 'ইমারজেন্সি সাহায্য শুরু করতে SOS ট্যাপ করুন।';

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
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get notSure => 'নিশ্চিত নয়';

  @override
  String get dispatchTitle => 'ইমারজেন্সি সেবা';

  @override
  String get callNow => 'এখন কল করুন';

  @override
  String get sendSms => 'SMS পাঠান';

  @override
  String get alertFamily => 'পরিবারকে সতর্ক করুন';

  @override
  String get waitingTitle => 'সাহায্য পথে';

  @override
  String get elapsed => 'অতিক্রান্ত';

  @override
  String get stayCalm =>
      'শান্ত থাকুন। ইমারজেন্সি সেবার সঙ্গে যোগাযোগ করা হয়েছে।';

  @override
  String get resolutionTitle => 'ইনসিডেন্ট রিপোর্ট';

  @override
  String get saveReport => 'ইনসিডেন্ট রিপোর্ট সংরক্ষণ করুন';

  @override
  String get shareReport => 'রিপোর্ট শেয়ার করুন';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get selectCountry => 'দেশ নির্বাচন করুন';

  @override
  String get familyContacts => 'পরিবারের যোগাযোগ';

  @override
  String get addContact => 'যোগাযোগ যোগ করুন';

  @override
  String get offline => 'অফলাইন';

  @override
  String get distanceLessThan100m => '১০০মি এর কম';

  @override
  String get critical => 'গুরুতর';

  @override
  String get urgent => 'জরুরি';

  @override
  String get nonEmergency => 'নন-ইমারজেন্সি';

  @override
  String get hospital => 'হাসপাতাল';

  @override
  String get ambulance => 'অ্যাম্বুলেন্স';

  @override
  String get police => 'পুলিশ';

  @override
  String get towing => 'টোয়িং সার্ভিস';

  @override
  String get puncture => 'পাঙ্কচার শপ';

  @override
  String get showroom => 'শোরুম';

  @override
  String get verifiedToday => 'আজই যাচাই করা হয়েছে';

  @override
  String get bystanderMode => 'বাইস্ট্যান্ডার মোড';

  @override
  String get coordinationTitle => 'সমন্বয়';

  @override
  String get thankYou => 'ROADSoS ব্যবহার করার জন্য ধন্যবাদ';
}
