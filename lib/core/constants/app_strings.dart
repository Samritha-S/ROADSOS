// lib/core/constants/app_strings.dart
// ROADSoS - App Strings

class AppStrings {
  AppStrings._();

  static const String appName = 'ROADSoS';
  static const String tagline = 'Emergency Coordination System';
  static const String sosButtonLabel = 'HOLD FOR SOS';
  static const String orientingSentence = 'Help is being organized. Answer these questions.';
  static const String triageQ1 = 'Is anyone injured or unconscious?';
  static const String triageQ2 = 'Is there bleeding, difficulty breathing, or loss of consciousness?';
  static const String triageQ3 = 'Is there fire, smoke, or is the vehicle in water?';
  static const String answerYes = 'YES';
  static const String answerNo = 'NO';
  static const String answerNotSure = 'NOT SURE';
  static const String callingLabel = 'Call';
  static const String noAnswerPrompt = 'No answer. Try the next available service.';
  static const String familyAlertSent = 'Family alert sent via SMS';
  static const String offlineBannerText = 'Offline Mode — using cached emergency data';
  static const String incidentResolvedLabel = 'Mark as Resolved';
  static const String bystanderJoinLabel = 'Add Bystander';
  static const String verifiedToday = 'Verified today';
  static const String highConfidence = 'High confidence';
  static const String lowConfidence = 'Unverified — use with caution';

  static const String nonEmergencyPrompt = 'For non-emergency road services';
  static const String roadServicesTitle = 'Road Services';
  static const String towingLabel = 'Towing';
  static const String punctureShopLabel = 'Puncture Shop';
  static const String showroomLabel = 'Showroom';
  static const String noFacilitiesMessage = 'No facility found nearby';
  static const String didSomeoneAnswer = 'Did someone answer?';
  static const String timeSinceIncident = 'Time since incident:';
  static const String timeElapsed = 'Time elapsed:';
  static const String helpIsComing = 'Help is Coming';
  static const String helpContacted = 'Help has been contacted';
  static const String servicesContactedSuffix = 'services contacted';
  static const String helpersPresentSuffix = 'helpers present';
  static const String viewFullTimeline = 'View full timeline';
  static const String viewTimeline = 'View Timeline';
  static const String emergencyServicesHeader = 'Emergency Services';
  static const String alertFamilyHeader = 'Alert your family';
  static const String sendEmergencyAlertBtn = 'Send Emergency Alert';
  static const String incidentActiveHeader = 'Incident Active';
  static const String backToServicesBtn = 'Back to Services';
  static const String markResolvedBtn = 'Mark Resolved';
  static const String shareCodePrompt = 'Share this code with someone nearby';
  static const String gaveCodeBtn = 'I gave the code';
  static const String sosLabelText = 'SOS';
  static const String locatingText = 'Locating you...';
  static const String incidentPrefix = 'Incident #';
  static const String clickHereLabel = 'Click Here';

  // Resolution Screen
  static const String incidentResolvedTitle = 'Incident Resolved';
  static const String youAreSafe = 'You are safe';
  static const String incidentDocumented = 'The incident has been documented';
  static const String saveIncidentReportBtn = 'Save Incident Report';
  static const String incidentReportSavedMsg = 'Incident report saved';
  static const String returnToHomeBtn = 'Return to Home';
  static const String labelIncidentId = 'Incident ID:';
  static const String labelTime = 'Time:';
  static const String labelDuration = 'Duration:';
  static const String labelServices = 'Services:';
  static const String labelFamilyAlert = 'Family Alert:';
  static const String labelBystander = 'Bystanders:';
  static const String valueYes = 'Yes';
  static const String valueNo = 'No';

  // Bystander Entry Screen
  static const String howCanWeHelp = 'How can we help you?';
  static const String optionVictim = 'I was in an accident';
  static const String optionHelper = 'I am helping someone';
  static const String orEnterCode = 'or enter an incident code';
  static const String enterCodeHint = 'Enter 6-character code';
  static const String joinIncidentBtn = 'Join Incident';
  static const String invalidCodeMsg = 'Please enter a valid 6-character code';

  // Bystander Task Screen
  static const String bystanderHeader = 'Help Coordination';
  static const String bystanderActiveMsg = 'You are helping at an active incident';
  static const String selectYourRole = 'Select your role:';
  static const String confirmRoleBtn = 'Confirm My Role';
  static const String roleConfirmedPrefix = 'Role confirmed:';

  // Settings Screen
  static const String settingsTitle = 'Settings';
  static const String emergencyRegionHeader = 'Emergency Region';
  static const String emergencyRegionDesc = 'Set your country for correct emergency numbers';
  static const String changeCountryBtn = 'Change Country';
  static const String familyAlertContactsHeader = 'Family Alert Contacts';
  static const String familyAlertContactsDesc = 'These numbers receive SMS when SOS is triggered';
  static const String noContactsAdded = 'No contacts added';
  static const String addFamilyContactBtn = 'Add Family Contact';
  static const String addBtn = 'Add';
  static const String cancelBtn = 'Cancel';
  static const String enterPhoneHint = 'Enter phone number';
  static const String labelVersion = 'Version';
  static const String labelDatabase = 'Database';
  static const String labelHighway = 'Highway Corridor';
  static const String labelDataSources = 'Data Sources';
  static const String valueVersion = '1.0.0';
  static const String valueHighway = 'NH-544';
  static const String valueDataSources = 'OSM + Government';
  static const String labelContactsSuffix = 'contacts';

  // Country Config Screen
  static const String selectCountryTitle = 'Select Country';
  static const String regionChangedPrefix = 'Region changed to';

  // Settings Screen Additional
  static const String labelEmergency = 'Emergency:';
  static const String labelAmbulance = 'Ambulance:';
  static const String labelPolice = 'Police:';
  static const String systemInfoTitle = 'System Information';
  static const String systemInfoDesc = 'App build metadata';

  // Resolution Dialog
  static const String markResolvedDialogTitle = 'Mark Incident Resolved?';
  static const String markResolvedDialogContent = 'This will close the incident and save the report.';
  static const String resolveBtn = 'Resolve';
  static const String today = 'Today';
}
