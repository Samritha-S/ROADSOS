// lib/presentation/controllers/settings_controller.dart
// ROADSoS - Settings Controller

import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/country_config_model.dart';
import '../../data/repository/config_repository.dart';
import '../../data/repository/facility_repository.dart';
import 'incident_controller.dart';

class SettingsController extends GetxController {
  static const String _familyContactsKey = 'roadsos_family_contacts';
  static const String _selectedCountryKey = 'roadsos_selected_country';

  // Observable state
  final RxList<CountryConfigModel> availableCountries = RxList<CountryConfigModel>([]);
  final Rx<CountryConfigModel?> selectedCountry = Rx<CountryConfigModel?>(null);
  final RxList<String> familyContactNumbers = RxList<String>([]);
  final RxInt databaseFacilityCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    // 0. Load database facility count
    databaseFacilityCount.value = await FacilityRepository.getFacilityCount();

    // 1. Load available countries
    availableCountries.value = await ConfigRepository.getAllConfigs();

    // 2. Load saved country pref
    final prefs = await SharedPreferences.getInstance();
    final savedCountryCode = prefs.getString(_selectedCountryKey);
    
    if (savedCountryCode != null) {
      selectedCountry.value = availableCountries.firstWhere(
        (c) => c.countryCode == savedCountryCode,
        orElse: () => availableCountries.first,
      );
    } else {
      selectedCountry.value = availableCountries.firstWhere(
        (c) => c.countryCode == 'IN',
        orElse: () => availableCountries.first,
      );
    }

    // 3. Load family contacts
    await _loadFamilyContacts();
  }

  Future<void> selectCountry(CountryConfigModel config) async {
    selectedCountry.value = config;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedCountryKey, config.countryCode);
    
    if (Get.isRegistered<IncidentController>()) {
      await Get.find<IncidentController>().switchCountry(config.countryCode);
    }
  }

  Future<void> addFamilyContact(String phoneNumber) async {
    if (phoneNumber.trim().isEmpty) return;
    
    familyContactNumbers.add(phoneNumber.trim());
    await _saveFamilyContacts();
  }

  Future<void> removeFamilyContact(int index) async {
    if (index >= 0 && index < familyContactNumbers.length) {
      familyContactNumbers.removeAt(index);
      await _saveFamilyContacts();
    }
  }

  Future<void> _saveFamilyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(familyContactNumbers.toList());
    await prefs.setString(_familyContactsKey, jsonString);
  }

  Future<void> _loadFamilyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_familyContactsKey);
    
    if (jsonString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        familyContactNumbers.value = decodedList.map((e) => e.toString()).toList();
      } catch (e) {
        familyContactNumbers.value = [];
      }
    }
  }
}
