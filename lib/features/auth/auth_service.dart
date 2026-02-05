import 'dart:async';

/// MOCK User model to replace Firebase User
class MockUser {
  final String uid;
  final String? email;
  final String? displayName;
  final bool emailVerified;
  final String? photoURL;

  MockUser({
    required this.uid,
    this.email,
    this.displayName,
    this.emailVerified = true,
    this.photoURL,
  });
}

/// MOCK Auth Service
/// Replaces Firebase Auth with local state management for the showcase.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Mock current user
  MockUser? _currentUser;

  final StreamController<MockUser?> _authStateController =
      StreamController<MockUser?>.broadcast();

  // Stream of auth changes
  Stream<MockUser?> get authStateChanges => _authStateController.stream;

  // Current user accessor
  MockUser? get currentUser => _currentUser;

  // Simulate Sign in with Google
  Future<dynamic> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _setUser(MockUser(
      uid: 'mock_user_123',
      email: 'demo@facera.ai',
      displayName: 'Demo User',
      photoURL: null,
    ));
    return true;
  }

  // Simulate Sign up with Email/Password
  Future<void> signUpWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _setUser(MockUser(
      uid: 'mock_user_123',
      email: email,
      displayName: 'New User',
    ));
  }

  // Simulate Sign in with Email/Password
  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _setUser(MockUser(
      uid: 'mock_user_123',
      email: email,
      displayName: 'Returning User',
    ));
  }

  // Password Reset (Mock)
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // No-op
  }

  // Send Email Verification (Mock)
  Future<void> sendEmailVerification() async {
    // No-op
  }

  // Update Display Name (Mock)
  Future<void> updateDisplayName(String name) async {
    if (_currentUser != null) {
      _setUser(MockUser(
        uid: _currentUser!.uid,
        email: _currentUser!.email,
        displayName: name,
        emailVerified: _currentUser!.emailVerified,
        photoURL: _currentUser!.photoURL,
      ));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _authStateController.add(null);
  }

  void _setUser(MockUser user) {
    _currentUser = user;
    _authStateController.add(user);
  }
}
