class AppStrings {
  AppStrings._();

  static const String appName = 'ROADSoS';

  // Triage questions
  static const String triageQ1 = 'Is someone injured or unconscious?';
  static const String triageQ2 = 'Is there bleeding, difficulty breathing, or loss of consciousness?';
  static const String triageQ3 = 'Is there fire or smoke, or is the vehicle in water?';

  // Idle screen labels
  static const String sosButtonLabel = '';
  static const String towingLabel = 'Towing';
  static const String punctureShopLabel = 'Puncture Shop';
  static const String showroomLabel = 'Showroom';
  static const String sosLabelText = '';

  // Discovery screen
  static const String orientingSentence = 'Finding the nearest help...';
  static const String locatingText = 'Locating services';
  static const String incidentPrefix = 'INC-';

  // Triage answers
  static const String answerYes = 'Yes';
  static const String answerNo = 'No';
  static const String answerNotSure = 'Not sure';

  // Dispatch screen
  static const String didSomeoneAnswer = 'Did someone answer?';
  static const String offlineBannerText = 'You are currently offline';
  static const String emergencyServicesHeader = 'Emergency Services';
  static const String noFacilitiesMessage = 'No facilities found';
  static const String alertFamilyHeader = 'Alert Family';
  static const String familyAlertSent = 'Family alert sent';
  static const String sendEmergencyAlertBtn = 'Send Emergency Alert';
  static const String viewTimeline = 'View Timeline';
  static const String today = 'Today';
  static const String callingLabel = 'Call';

  // Coordination screen
  static const String shareCodePrompt = 'Enter the incident code';
  static const String gaveCodeBtn = 'Close';
  static const String incidentActiveHeader = 'Active Incident';
  static const String timeSinceIncident = 'Time since incident';
  static const String backToServicesBtn = 'Back to Services';
  static const String markResolvedDialogTitle = 'Mark as Resolved';
  static const String markResolvedDialogContent = 'Are you sure you want to mark this incident resolved?';
  static const String resolveBtn = 'Resolve';
  static const String markResolvedBtn = 'Mark Resolved';

  // Waiting screen
  static const String helpIsComing = 'Help is on the way';
  static const String helpContacted = 'Help has been contacted';
  static const String timeElapsed = 'Time elapsed';
  static const String servicesContactedSuffix = 'services contacted';
  static const String helpersPresentSuffix = 'helpers present';
  static const String viewFullTimeline = 'View Full Timeline';

  // Resolution screen
  static const String incidentResolvedTitle = 'Incident Resolved';
  static const String valueYes = 'Yes';
  static const String valueNo = 'No';
  static const String youAreSafe = 'You are safe now';
  static const String incidentDocumented = 'Incident documented';
  static const String labelIncidentId = 'Incident ID';
  static const String labelTime = 'Time';
  static const String labelDuration = 'Duration';
  static const String labelServices = 'Services';
  static const String labelFamilyAlert = 'Family Alert';
  static const String labelBystander = 'Bystanders';
  static const String incidentReportSavedMsg = 'Report saved successfully';
  static const String saveIncidentReportBtn = 'Save Report';
  static const String returnToHomeBtn = 'Return Home';

  // Bystander screens
  static const String invalidCodeMsg = 'Invalid code – please try again';
  static const String joinIncidentBtn = 'Join Incident';
  static const String bystanderHeader = 'Bystander Mode';
  static const String bystanderActiveMsg = 'Bystander active';
  static const String selectYourRole = 'Select your role';
  static const String roleConfirmedPrefix = 'Role confirmed:';
  static const String confirmRoleBtn = 'Confirm Role';

  // Settings screen
  static const String labelEmergency = 'Emergency Number';
  static const String labelAmbulance = 'Ambulance Number';
  static const String labelPolice = 'Police Number';
  static const String systemInfoTitle = 'System Information';
  static const String systemInfoDesc = 'App version, diagnostics, etc.';

  // Country config screen
  static const String selectCountryTitle = 'Select Country';
  static const String regionChangedPrefix = 'Region changed to';

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
  // New language option strings
  static const String languageLabel = 'App Language';
  static const List<String> languageOptions = [
    'English',
    'Hindi',
    'Tamil',
    'Malayalam',
    'Kannada',
    'Marathi',
    'French',
    'German',
  ];
}
