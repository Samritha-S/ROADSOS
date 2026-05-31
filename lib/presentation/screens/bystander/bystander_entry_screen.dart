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
          final _ = _bystanderController.hasJoinedIncident.value;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24.0),
                // 1. Title & Subtitle
                Text(
                  'Join an Incident',
                  style: AppTextStyles.headline.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                const Text(
                  "Enter the 6-character code shown on the victim's phone",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40.0),

                // 2. Large text field for code entry
                TextField(
                  controller: _codeController,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32.0,
                    letterSpacing: 8.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: 'CODE',
                    hintStyle: TextStyle(
                      color: AppColors.cardBorder,
                      fontSize: 32.0,
                      letterSpacing: 8.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.confirmedGreen, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.confirmedGreen, width: 2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // 3. JOIN button (full width, green)
                SizedBox(
                  height: 64.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
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
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),

                // 4. Divider with 'or'
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.cardBorder, thickness: 1.0)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.cardBorder, thickness: 1.0)),
                  ],
                ),
                const SizedBox(height: 40.0),

                // 5. 'I found an accident with no code'
                SizedBox(
                  height: 64.0,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () => Get.offAllNamed(Routes.idle),
                    icon: const Icon(Icons.warning_amber_rounded, color: AppColors.primaryRed),
                    label: const Text(
                      'I found an accident with no code',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
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
