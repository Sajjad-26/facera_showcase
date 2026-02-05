import 'package:facera_showcase/core/services/notification_service.dart';
import 'package:facera_showcase/core/services/subscription_service.dart';
import 'package:facera_showcase/core/theme/app_theme.dart';
import 'package:facera_showcase/features/auth/auth_service.dart';
import 'package:facera_showcase/features/home/main_navigation_screen.dart';
import 'package:facera_showcase/features/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Mock Services
  await NotificationService().init();
  await SubscriptionService().init();

  runApp(const FaceraApp());
}

class FaceraApp extends StatelessWidget {
  const FaceraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facera AI Showcase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      scrollBehavior: NoGlowScrollBehavior(),
      // Show Welcome Screen initially
      home: const WelcomeScreen(),
    );
  }
}
