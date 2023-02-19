import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // the image should be in android/src/main/res/drawable folder
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_stat_create');
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _notifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notificationResponse) async {});
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel descreiption',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );
}
