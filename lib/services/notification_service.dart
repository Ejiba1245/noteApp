import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notifications.initialize(initSettings);
  }

  Future<void> showNotification(int id, String title, String body) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails('ai_notes_channel', 'AI Notes', importance: Importance.max),
      iOS: DarwinNotificationDetails(),
    );
    await _notifications.show(id, title, body, details);
  }
}
