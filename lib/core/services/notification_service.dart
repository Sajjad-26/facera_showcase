import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  Future<void> init() async {
    // Mock Init
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Mock notification show
    print("Notification mocked: $title - $body");
  }
}
