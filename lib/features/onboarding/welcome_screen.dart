import 'package:facera_showcase/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset('assets/images/model.png', fit: BoxFit.cover),

          // 2. Dark Gradient Overlay for Readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black,
                ],
                stops: const [0.0, 0.4, 0.8, 1.0],
              ),
            ),
          ),

          // 3. Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Main Brand Title
                  Text(
                    "Facera AI",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 64, // Increased size
                      fontWeight: FontWeight.w900, // Maximized weight
                      color: Colors.white,
                      letterSpacing: -2,
                      height: 1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 800.ms).scale(
                        begin: const Offset(0.9, 0.9),
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    "Get the desired model face",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 24, // Increased size
                      fontWeight: FontWeight.w600, // Stronger weight
                      color: Colors.white.withValues(
                        alpha: 0.9,
                      ), // Higher opacity
                      letterSpacing: 0.5,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 400.ms)
                      .slideY(begin: 0.5),

                  const Spacer(),

                  // Button instead of Swipe
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const LoginScreen(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeOutCubic;

                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(
                                tween,
                              );

                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                ),
                              );
                            },
                            transitionDuration: const Duration(
                              milliseconds: 800,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "GET STARTED",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .slideY(begin: 0.5, curve: Curves.easeOut),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
