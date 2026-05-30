// lib/presentation/screens/settings/settings_screen.dart
// ROADSoS - Settings Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../app/routes.dart';
import '../../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final _settingsController = Get.find<SettingsController>();

  String _getCountryFlag(String code) {
    switch (code.toUpperCase()) {
      case 'IN':
        return '🇮🇳';
      case 'US':
        return '🇺🇸';
      case 'GB':
        return '🇬🇧';
      default:
        return '🏳️';
    }
  }

  void _showAddContactDialog(BuildContext context) {
    final phoneController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          AppStrings.addFamilyContactBtn,
          style: AppTextStyles.subheadline.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: AppStrings.enterPhoneHint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.confirmedGreen),
            ),
          ),
        ),
        actions: [
          // CANCEL button
          SizedBox(
            height: 80.0, // Touch target height: 80px
            child: TextButton(
              onPressed: () => Get.back(),
              child: Text(
                AppStrings.cancelBtn,
                style: AppTextStyles.buttonLabel.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          // ADD button
          SizedBox(
            height: 80.0, // Touch target height: 80px
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.confirmedGreen,
              ),
              onPressed: () {
                final number = phoneController.text.trim();
                if (number.isNotEmpty) {
                  _settingsController.addFamilyContact(number);
                }
                Get.back();
              },
              child: Text(
                AppStrings.addBtn,
                style: AppTextStyles.buttonLabel.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.background,
        title: Text(
          AppStrings.settingsTitle,
          style: AppTextStyles.subheadline.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          children: [
            // SECTION 1: Country Configuration
            _buildSectionHeader(
              title: AppStrings.emergencyRegionHeader,
              subtitle: AppStrings.emergencyRegionDesc,
            ),
            const SizedBox(height: 12.0),
            Obx(() {
              final country = _settingsController.selectedCountry.value;
              if (country == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.confirmedGreen,
                  ),
                );
              }

              final flag = _getCountryFlag(country.countryCode);

              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(flag, style: const TextStyle(fontSize: 32.0)),
                        const SizedBox(width: 12.0),
                        Text(
                          country.countryName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    _buildConfigItem(AppStrings.labelEmergency, country.emergencyNumber),
                    const SizedBox(height: 8.0),
                    _buildConfigItem(AppStrings.labelAmbulance, country.ambulanceNumber),
                    const SizedBox(height: 8.0),
                    _buildConfigItem(AppStrings.labelPolice, country.policeNumber),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 80.0, // Touch target height: 80px
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardBackground,
                          side: const BorderSide(
                            color: AppColors.textSecondary,
                            width: 1.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () => Get.toNamed(Routes.countryConfig),
                        child: Text(
                          AppStrings.changeCountryBtn,
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24.0),
            const Divider(color: AppColors.textSecondary, thickness: 1.0),
            const SizedBox(height: 24.0),

            // SECTION 2: Family Emergency Contacts
            _buildSectionHeader(
              title: AppStrings.familyAlertContactsHeader,
              subtitle: AppStrings.familyAlertContactsDesc,
            ),
            const SizedBox(height: 12.0),
            Obx(() {
              final contacts = _settingsController.familyContactNumbers;
              if (contacts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      AppStrings.noContactsAdded,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: contacts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  final number = contacts[index];

                  return Dismissible(
                    key: Key('$number-$index'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24.0),
                      color: AppColors.criticalRed,
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.textPrimary,
                        size: 28.0,
                      ),
                    ),
                    onDismissed: (_) {
                      _settingsController.removeFamilyContact(index);
                    },
                    child: Container(
                      height: 80.0, // Touch target height: 80px
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          leading: const Icon(
                            Icons.phone,
                            color: AppColors.confirmedGreen,
                            size: 24.0,
                          ),
                          title: Text(
                            number,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () =>
                                _settingsController.removeFamilyContact(index),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 80.0, // Touch target height: 80px
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(
                    color: AppColors.confirmedGreen,
                    width: 1.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () => _showAddContactDialog(context),
                icon: const Icon(
                  Icons.add,
                  color: AppColors.confirmedGreen,
                  size: 24.0,
                ),
                label: Text(
                  AppStrings.addFamilyContactBtn,
                  style: AppTextStyles.buttonLabel.copyWith(
                    color: AppColors.confirmedGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Divider(color: AppColors.textSecondary, thickness: 1.0),
            const SizedBox(height: 24.0),

            // SECTION 3: App Info
            _buildSectionHeader(
              title: AppStrings.systemInfoTitle,
              subtitle: AppStrings.systemInfoDesc,
            ),
            const SizedBox(height: 12.0),
            Obx(() {
              final count = _settingsController.databaseFacilityCount.value;
              return Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      AppStrings.labelVersion,
                      AppStrings.valueVersion,
                    ),
                    _buildInfoTile(
                      AppStrings.labelDatabase,
                      '$count ${AppStrings.labelContactsSuffix}',
                    ),
                    _buildInfoTile(
                      AppStrings.labelHighway,
                      AppStrings.valueHighway,
                    ),
                    _buildInfoTile(
                      AppStrings.labelDataSources,
                      AppStrings.valueDataSources,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.subheadline.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
