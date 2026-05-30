// lib/app/app.dart
// ROADSoS - Main Application Container

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'theme.dart';
import 'routes.dart';

class RoadSoSApp extends StatelessWidget {
  const RoadSoSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ROADSoS',
      theme: AppTheme.darkTheme,
      initialRoute: Routes.idle,
      getPages: Routes.pages,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
    );
  }
}
