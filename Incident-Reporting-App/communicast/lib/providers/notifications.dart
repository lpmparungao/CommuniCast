import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "channel id",
        "channel name",
        channelDescription: "To send local notification",
        importance: Importance.max,
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    final initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await _notifications.initialize(initializationSettings);
  }

  static Future showNotifications(
          QueryDocumentSnapshot<Map<String, dynamic>> event) async =>
      _notifications.show(0, event.get('title'), event.get('description'),
          await _notificationDetails());
}
