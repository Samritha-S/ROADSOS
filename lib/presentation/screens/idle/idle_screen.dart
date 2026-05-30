// lib/presentation/screens/idle/idle_screen.dart
// ROADSoS - Idle Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../app/routes.dart';
import '../../controllers/incident_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/service_controller.dart';

class IdleScreen extends StatefulWidget {
  const IdleScreen({super.key});

  @override
  State<IdleScreen> createState() => _IdleScreenState();
}

class _IdleScreenState extends State<IdleScreen> {
  final _settingsController = Get.find<SettingsController>();
  final _serviceController = Get.find<ServiceController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<IncidentController>().loadNearbyFacilities();
    });
  }

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

  Widget _buildServiceTile({
    required String icon,
    required String serviceName,
    required String facilityName,
    required String? phone,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28.0)),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serviceName, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 4.0),
                Text(
                  facilityName,
                  style: AppTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (phone != null && phone.isNotEmpty)
            SizedBox(
              height: 80.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                onPressed: () => _makeCall(phone),
                child: Text(AppStrings.callingLabel, style: AppTextStyles.buttonLabel),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              height: 80.0,
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    final country = _settingsController.selectedCountry.value;
                    final flag = country != null ? _getCountryFlag(country.countryCode) : '🇮🇳';
                    final name = country?.countryName ?? 'India';
                    return Row(
                      children: [
                        Text(flag, style: const TextStyle(fontSize: 24.0)),
                        const SizedBox(width: 8.0),
                        Text(name, style: AppTextStyles.bodyLarge),
                      ],
                    );
                  }),
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.subheadline.copyWith(color: AppColors.textPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, size: 28.0),
                    color: AppColors.textPrimary,
                    onPressed: () => Get.toNamed(Routes.settings),
                  ),
                ],
              ),
            ),
            // Middle - SOS button
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'Emergency SOS button, press and hold to activate',
                      child: const SosButton(),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      AppStrings.sosButtonLabel,
                      style: AppTextStyles.sosLabel.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom - services card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Road Services',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildRoadServiceTile(
                    icon: Icons.car_repair,
                    label: AppStrings.towingLabel,
                    phone: _serviceController.towingFacilities.firstOrNull?.phone ?? '',
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  _buildRoadServiceTile(
                    icon: Icons.tire_repair,
                    label: AppStrings.punctureShopLabel,
                    phone: _serviceController.punctureFacilities.firstOrNull?.phone ?? '',
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  _buildRoadServiceTile(
                    icon: Icons.directions_car,
                    label: AppStrings.showroomLabel,
                    phone: _serviceController.showroomFacilities.firstOrNull?.phone ?? '',
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.roadServicesTitle,
                      style: AppTextStyles.subheadline.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 24.0),
                    Obx(() {
                      final towing = _serviceController.towingFacilities.firstOrNull;
                      final puncture = _serviceController.punctureFacilities.firstOrNull;
                      final showroom = _serviceController.showroomFacilities.firstOrNull;
                      return Column(
                        children: [
                          _buildServiceTile(
                            icon: '🚗',
                            serviceName: AppStrings.towingLabel,
                            facilityName: towing?.name ?? AppStrings.noFacilitiesMessage,
                            phone: towing?.phone,
                          ),
                          const SizedBox(height: 16.0),
                          _buildServiceTile(
                            icon: '🔧',
                            serviceName: AppStrings.punctureShopLabel,
                            facilityName: puncture?.name ?? AppStrings.noFacilitiesMessage,
                            phone: puncture?.phone,
                          ),
                          const SizedBox(height: 16.0),
                          _buildServiceTile(
                            icon: '🏪',
                            serviceName: AppStrings.showroomLabel,
                            facilityName: showroom?.name ?? AppStrings.noFacilitiesMessage,
                            phone: showroom?.phone,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Helper to build road service tile
  Widget _buildRoadServiceTile({
    required IconData icon,
    required String label,
    required String phone,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        phone.isEmpty ? 'Not available' : phone,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      trailing: phone.isEmpty
          ? null
          : GestureDetector(
              onTap: () async {
                final uri = Uri(scheme: 'tel', path: phone);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.confirmedGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Call',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
    );
  }
}


class SosButton extends StatefulWidget {
  const SosButton({super.key});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.2).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _triggerSOS();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerSOS() {
    if (_isPressing) {
      setState(() => _isPressing = false);
      Get.find<IncidentController>().triggerSOS();
      Get.toNamed(Routes.discovery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) { setState(() => _isPressing = true); _animationController.forward(from: 0.0); },
      onLongPressEnd: (_) { if (_animationController.status != AnimationStatus.completed) { setState(() => _isPressing = false); _animationController.reverse(); } },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 200.0,
          height: 200.0,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.criticalRed, width: 4.0),
            boxShadow: [BoxShadow(color: AppColors.sosGlow, blurRadius: 30.0, spreadRadius: 5.0)],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) => Container(
                  width: 200 * _scaleAnimation.value,
                  height: 200 * _scaleAnimation.value,
                  decoration: const BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
                ),
              ),
              const Text(AppStrings.sosLabelText, style: TextStyle(color: Colors.white, fontSize: 48.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
