// lib/presentation/screens/settings/country_config_screen.dart
// ROADSoS - Country Config Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/settings_controller.dart';

class CountryConfigScreen extends StatelessWidget {
  const CountryConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.background,
        title: Text(
          AppStrings.selectCountryTitle,
          style: AppTextStyles.subheadline.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final countries = settingsController.availableCountries;
          final selectedCountry = settingsController.selectedCountry.value;

          if (countries.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.confirmedGreen,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final config = countries[index];
              final isSelected = selectedCountry?.countryCode == config.countryCode;

              return InkWell(
                onTap: () {
                  settingsController.selectCountry(config);
                  Get.snackbar(
                    AppStrings.appName,
                    '${AppStrings.regionChangedPrefix} ${config.countryName}',
                    backgroundColor: AppColors.surface,
                    colorText: AppColors.textPrimary,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  Get.back();
                },
                child: Container(
                  height: 72.0,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryRed.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      // Country name
                      Expanded(
                        child: Text(
                          config.countryName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // Emergency badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(
                            color: AppColors.textSecondary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          '🆘 ${config.emergencyNumber}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 16.0),
                        const Icon(
                          Icons.check,
                          color: AppColors.confirmedGreen,
                          size: 24.0,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
