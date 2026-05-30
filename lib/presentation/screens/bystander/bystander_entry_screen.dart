// lib/presentation/screens/bystander/bystander_entry_screen.dart
// ROADSoS - Bystander Entry Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../app/routes.dart';
import '../../controllers/bystander_controller.dart';

class BystanderEntryScreen extends StatefulWidget {
  const BystanderEntryScreen({super.key});

  @override
  State<BystanderEntryScreen> createState() => _BystanderEntryScreenState();
}

class _BystanderEntryScreenState extends State<BystanderEntryScreen> {
  final _bystanderController = Get.find<BystanderController>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
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
          AppStrings.appName,
          style: AppTextStyles.subheadline.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // Rule 6: Every screen uses Obx() to reactively observe state.
          final _ = _bystanderController.hasJoinedIncident.value;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    AppStrings.howCanWeHelp,
                    style: AppTextStyles.headline,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48.0),

                // Option 1 Button: Victim
                SizedBox(
                  height: 100.0, // Touch target > 80px
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () => Get.offAllNamed(Routes.idle),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.personal_injury, color: AppColors.textPrimary, size: 28.0),
                        const SizedBox(height: 4.0),
                        Text(
                          AppStrings.optionVictim,
                          style: AppTextStyles.buttonLabel,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Option 2 Button: Helper
                SizedBox(
                  height: 100.0, // Touch target > 80px
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      side: const BorderSide(
                        color: AppColors.confirmedGreen,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () => Get.toNamed(Routes.bystanderTask),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people, color: AppColors.confirmedGreen, size: 28.0),
                        const SizedBox(height: 4.0),
                        Text(
                          AppStrings.optionHelper,
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: AppColors.confirmedGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48.0),

                // Divider with text
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.textSecondary, thickness: 1.0)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        AppStrings.orEnterCode,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.textSecondary, thickness: 1.0)),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Text Field
                TextField(
                  controller: _codeController,
                  maxLength: 6,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24.0,
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: AppStrings.enterCodeHint,
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 20.0,
                      letterSpacing: 1.0,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textSecondary, width: 1.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.confirmedGreen, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Join Button
                SizedBox(
                  height: 80.0, // Touch target height: 80px
                  width: double.infinity,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 64.0),
                        backgroundColor: AppColors.confirmedGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        final code = _codeController.text.trim();
                        if (code.length == 6) {
                          _bystanderController.joinWithCode(code);
                          Get.toNamed(Routes.bystanderTask);
                        } else {
                          Get.snackbar(
                            AppStrings.appName,
                            AppStrings.invalidCodeMsg,
                            backgroundColor: AppColors.surface,
                            colorText: AppColors.textPrimary,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Text(
                        AppStrings.joinIncidentBtn,
                        style: AppTextStyles.buttonLabel,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
