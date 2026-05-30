// lib/presentation/screens/discovery/discovery_screen.dart
// ROADSoS - Discovery Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/enums/incident_state.dart';
import '../../../app/routes.dart';
import '../../controllers/incident_controller.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final _incidentController = Get.find<IncidentController>();
  bool _hasNavigated = false;
  late Worker _stateWorker;

  @override
  void initState() {
    super.initState();

    // Listen for state transition to TRIAGE
    _stateWorker = ever(_incidentController.currentIncident, (incident) {
      if (incident != null && incident.currentState == IncidentState.TRIAGE) {
        _navigate();
      }
    });

    // Timeout fallback after 8 seconds
    Future.delayed(const Duration(seconds: 8), () {
      _navigate();
    });
  }

  void _navigate() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    _stateWorker.dispose();
    Get.toNamed(Routes.triage);
  }

  @override
  void dispose() {
    _stateWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final incident = _incidentController.currentIncident.value;
          final incidentId = incident?.id ?? '';
          final shortId = incidentId.length >= 8 ? incidentId.substring(0, 8) : '';

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40.0),
              // GPS pulsing concentric rings
              const SizedBox(
                height: 150.0,
                child: Center(
                  child: PulseRingsWidget(),
                ),
              ),
              const SizedBox(height: 32.0),
              // Orienting sentence
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  AppStrings.orientingSentence,
                  style: AppTextStyles.headline,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24.0),
              // Locating... text
              Text(
                AppStrings.locatingText,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              // Incident ID display
              if (shortId.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    '${AppStrings.incidentPrefix}$shortId',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class PulseRingsWidget extends StatefulWidget {
  const PulseRingsWidget({super.key});

  @override
  State<PulseRingsWidget> createState() => _PulseRingsWidgetState();
}

class _PulseRingsWidgetState extends State<PulseRingsWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.33;
            double progress = _controller.value - delay;
            if (progress < 0) progress += 1.0;

            final opacity = (1.0 - progress).clamp(0.0, 1.0);
            final scale = 1.0 + progress * 2.0;

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryRed,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
