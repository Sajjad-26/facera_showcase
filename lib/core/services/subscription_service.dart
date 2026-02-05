import 'dart:async';

/// Mock Model for subscription details to replace RevenueCat dependencies
class SubscriptionDetails {
  final String planId; // 'free', 'pro_lite', 'pro_plus'
  final String? productIdentifier;
  final DateTime? expirationDate;
  final bool willRenew;
  final Map<String, DateTime> allPurchaseDates;

  SubscriptionDetails({
    required this.planId,
    this.productIdentifier,
    this.expirationDate,
    required this.willRenew,
    required this.allPurchaseDates,
  });

  bool get isActive => planId != 'free';
}

/// MOCK Subscription Service
/// Disconnected from RevenueCat for the public showcase.
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();

  factory SubscriptionService() => _instance;

  SubscriptionService._internal();

  // Mock checking 'Pro Plus' status logic
  static const String entitlementProPlus = 'pro_plus';
  static const String entitlementProLite = 'pro_lite';

  bool _isInitialized = false;

  // Stream controller for real-time subscription updates
  final StreamController<String> _planStreamController =
      StreamController<String>.broadcast();

  /// Stream of plan changes ('free', 'pro_lite', 'pro_plus')
  Stream<String> get planStream => _planStreamController.stream;

  Future<void> init() async {
    if (_isInitialized) return;

    // Simulate init delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Default to a premium plan for showcase purposes
    _planStreamController.add('pro_plus');
    _isInitialized = true;
  }

  /// Force refresh subscription status (Mocked)
  Future<String> forceRefresh() async {
    return 'pro_plus';
  }

  /// Fetch current offerings (Mocked to return null)
  Future<dynamic> getOfferings() async {
    return null;
  }

  /// Purchase a specific package (Mocked)
  Future<bool> purchasePackage(dynamic package) async {
    // Simulate successful purchase
    await Future.delayed(const Duration(seconds: 1));
    _planStreamController.add('pro_plus');
    return true;
  }

  /// Restore previous purchases (Mocked)
  Future<bool> restorePurchases() async {
    await Future.delayed(const Duration(seconds: 1));
    _planStreamController.add('pro_plus');
    return true;
  }

  /// Check current entitlement status (Mocked)
  Future<String> getCurrentPlan() async {
    return 'pro_plus';
  }

  Future<SubscriptionDetails> getSubscriptionDetails() async {
    // MOCK Subscription Details for Showcase
    return SubscriptionDetails(
      planId: 'pro_plus',
      productIdentifier: 'showcase_lifetime_access',
      expirationDate:
          DateTime.now().add(const Duration(days: 3650)), // 10 Years
      willRenew: true,
      allPurchaseDates: {
        'pro_plus': DateTime.now().subtract(const Duration(days: 1)),
      },
    );
  }

  void dispose() {
    _planStreamController.close();
  }
}
