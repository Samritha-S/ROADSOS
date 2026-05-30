// lib/app/routes.dart
// ROADSoS - App Routes Configuration

import 'package:get/get.dart';

import '../presentation/screens/idle/idle_screen.dart';
import '../presentation/screens/discovery/discovery_screen.dart';
import '../presentation/screens/triage/triage_screen.dart';
import '../presentation/screens/dispatch/dispatch_screen.dart';
import '../presentation/screens/coordination/coordination_screen.dart';
import '../presentation/screens/waiting/waiting_screen.dart';
import '../presentation/screens/resolution/resolution_screen.dart';
import '../presentation/screens/bystander/bystander_entry_screen.dart';
import '../presentation/screens/bystander/bystander_task_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/settings/country_config_screen.dart';

class Routes {
  Routes._();

  static const String idle = '/idle';
  static const String discovery = '/discovery';
  static const String triage = '/triage';
  static const String dispatch = '/dispatch';
  static const String coordination = '/coordination';
  static const String waiting = '/waiting';
  static const String resolution = '/resolution';
  static const String bystanderEntry = '/bystander-entry';
  static const String bystanderTask = '/bystander-task';
  static const String settings = '/settings';
  static const String countryConfig = '/country-config';

  static List<GetPage> get pages => [
        GetPage(
          name: idle,
          page: () => const IdleScreen(),
        ),
        GetPage(
          name: discovery,
          page: () => const DiscoveryScreen(),
        ),
        GetPage(
          name: triage,
          page: () => const TriageScreen(),
        ),
        GetPage(
          name: dispatch,
          page: () => const DispatchScreen(),
        ),
        GetPage(
          name: coordination,
          page: () => const CoordinationScreen(),
        ),
        GetPage(
          name: waiting,
          page: () => const WaitingScreen(),
        ),
        GetPage(
          name: resolution,
          page: () => const ResolutionScreen(),
        ),
        GetPage(
          name: bystanderEntry,
          page: () => const BystanderEntryScreen(),
        ),
        GetPage(
          name: bystanderTask,
          page: () => const BystanderTaskScreen(),
        ),
        GetPage(
          name: settings,
          page: () => SettingsScreen(),
        ),
        GetPage(
          name: countryConfig,
          page: () => const CountryConfigScreen(),
        ),
      ];
}
