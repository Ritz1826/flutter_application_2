import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifService {
  // 1. Create a static private instance
  static final NotifService _instance = NotifService._internal();

  // 2. Private named constructor
  NotifService._internal();

  // 3. Factory constructor returns same instance
  factory NotifService() {
    return _instance;
  }

  final FlutterLocalNotificationsPlugin _notifPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifPlugin() async {
    final AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,

          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
        );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _notifPlugin.initialize(settings: initSettings);
  }

  Future<void> checkPerm() async {
    await _notifPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notifPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showNotif() async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          "channelId",
          "channelName",
          channelDescription: 'This is the default notification channel',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    final DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notifPlugin.show(
      id: 0,
      notificationDetails: notificationDetails,
      title: "titlee",
      body: "hfhfhgfhfg",
    );
  }
}
