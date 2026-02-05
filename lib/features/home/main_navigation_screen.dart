import 'package:facera_showcase/features/consistency/consistency_screen.dart';
import 'package:facera_showcase/core/services/storage_service.dart';
import 'package:facera_showcase/features/home/home_screen.dart';
import 'package:facera_showcase/features/profile/history_screen.dart';
import 'package:facera_showcase/features/profile/profile_screen.dart';
import 'package:facera_showcase/features/tips/tips_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:facera_showcase/features/subscription/subscription_screen.dart';
import 'package:facera_showcase/core/ui/glass_container.dart';
import 'package:facera_showcase/core/theme/app_theme.dart';
import 'dart:ui';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 2;
  late PageController _pageController;
  int _improveTabKey = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _refreshImproveTab() {
    setState(() {
      _improveTabKey++;
    });
  }

  List<Widget> get _screens => [
        const ConsistencyScreen(),
        const HistoryScreen(),
        const HomeScreen(),
        // Locked Improve Tab Logic
        FutureBuilder<String>(
          key: ValueKey(_improveTabKey),
          future: StorageService().getSubscriptionPlan(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child:
                      CircularProgressIndicator(color: AppColors.accentPurple),
                ),
              );
            }
            final plan = snapshot.data;
            if (plan == 'pro_plus') {
              return const TipsScreen();
            }
            return _ProLockedView(
              title: "Improve Tab Locked",
              feature: "Unlock advanced facial maxxing tips and guides.",
              onPurchaseComplete: _refreshImproveTab,
            );
          },
        ),
        const ProfileScreen(),
      ];

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    HapticFeedback.selectionClick();
  }

  void _onBottomNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const ClampingScrollPhysics(),
            children: _screens,
          ),
          // Bottom Atmosphere Fade
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 220,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.9),
                      Colors.black,
                    ],
                    stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          24,
          0,
          24,
          24,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  labelTextStyle: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold, // Bold
                        color: Colors.white, // White content
                      );
                    }
                    return GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600, // Semi-bold for unselected
                      color: Colors.white70,
                    );
                  }),
                  iconTheme: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const IconThemeData(
                        size: 32, // Larger selected icon
                        color: Colors.white,
                      );
                    }
                    return const IconThemeData(
                      size: 28, // Larger unselected icon
                      color: Colors.white60,
                    );
                  }),
                ),
                child: NavigationBar(
                  height: 64, // Sleeker height for icon-only
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                  backgroundColor: Colors.transparent,
                  indicatorColor:
                      Colors.transparent, // Remove the selection pill highlight
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onBottomNavTapped,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.local_fire_department_outlined),
                      selectedIcon: Icon(Icons.local_fire_department_rounded),
                      label: 'Daily',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.history_outlined),
                      selectedIcon: Icon(Icons.history_rounded),
                      label: 'History',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.tips_and_updates_outlined),
                      selectedIcon: Icon(Icons.tips_and_updates_rounded),
                      label: 'Improve',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProLockedView extends StatelessWidget {
  final String title;
  final String feature;
  final VoidCallback? onPurchaseComplete;

  const _ProLockedView({
    required this.title,
    required this.feature,
    this.onPurchaseComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.appGradient,
              ),
            ),
          ),
          Center(
            child: GlassContainer(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(32),
              opacity: 0.1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: AppColors.accentPurple,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    feature,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SubscriptionScreen(),
                          ),
                        );
                        if (result == 'pro_plus') {
                          onPurchaseComplete?.call();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentPurple,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        "UNLOCK PREMIUM",
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
