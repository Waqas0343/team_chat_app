import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(
          message.notification!.title ?? '',
          message.notification!.body ?? '',
        );
      }
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }
}