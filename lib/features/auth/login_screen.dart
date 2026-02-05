import 'package:facera_showcase/core/theme/app_theme.dart';
import 'package:facera_showcase/features/auth/auth_service.dart';
import 'package:facera_showcase/features/home/main_navigation_screen.dart';
import 'package:facera_showcase/features/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isLogin = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _handleGoogleSignIn() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);
    try {
      // Calls Mock Auth Service
      final cred = await AuthService().signInWithGoogle();
      if (cred != null && mounted) {
        Navigator.pushReplacement(
          context,
          // Directly to Main Navigation for Showcase
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    }
  }

  void _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await AuthService().signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await AuthService().signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (_firstNameController.text.isNotEmpty) {
          await AuthService().updateDisplayName(
            _firstNameController.text.trim(),
          );
        }
      }

      if (mounted) {
        // Directly to Main Navigation for Showcase
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    }
  }

  void _showError(String message) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.outfit(color: Colors.white)),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8), // Soft grey background
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            HapticFeedback.mediumImpact();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const WelcomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                          position: offsetAnimation, child: child));
                },
                transitionDuration: const Duration(milliseconds: 800),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // 1. Colorful Abstract Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE89370),
                      Color(0xFFD66D50),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Abstract Shapes
                    Positioned(
                      top: -50,
                      left: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4B96F).withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, -0.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin ? "Welcome\nBack" : "Create an\naccount",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ).animate().fadeIn().slideY(begin: -0.2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. White Card Content
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.72,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Google Sign In
                        OutlinedButton(
                          onPressed: _handleGoogleSignIn,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/google_logo.svg',
                                height: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Sign in with Google",
                                style: GoogleFonts.outfit(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            "or",
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (!_isLogin) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                    "First Name", _firstNameController),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                    "Last Name", _lastNameController),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],

                        _buildTextField("Email", _emailController,
                            type: TextInputType.emailAddress),
                        const SizedBox(height: 16),
                        _buildTextField("Password", _passwordController,
                            type: TextInputType.visiblePassword,
                            isPassword: true),

                        const SizedBox(height: 32),

                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleEmailAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    _isLogin ? "Log in" : "Create account",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin
                                  ? "Don't have an account? "
                                  : "Have an account? ",
                              style: GoogleFonts.outfit(color: Colors.black87),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _isLogin = !_isLogin),
                              child: Text(
                                _isLogin ? "Sign up here" : "Log in here",
                                style: GoogleFonts.outfit(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ).animate().slideY(
                  begin: 0.1,
                  duration: 600.ms,
                  curve: Curves.easeOutQuad,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword && _obscurePassword,
      style: GoogleFonts.outfit(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        hintText: hint,
        hintStyle: GoogleFonts.outfit(color: Colors.grey[500]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black12, width: 1)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                    size: 20),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "$hint required";
        if (hint == "Email" && !value.contains("@")) return "Invalid email";
        if (hint == "Password" && value.length < 6) return "Min 6 chars";
        return null;
      },
    );
  }
}
