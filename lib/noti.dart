import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    // var iOSInitialize = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      // iOS: iOSInitialize
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fn}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channelName',
      playSound: true,
          sound: RawResourceAndroidNotificationSound('notification'),
          importance: Importance.max,
          priority: Priority.high,
    );
    var not =NotificationDetails(android: androidPlatformChannelSpecifics,
    // iOS: IOSNotificationDetails()
    );
    await fn.show(0, title, body, not);
  }
}
