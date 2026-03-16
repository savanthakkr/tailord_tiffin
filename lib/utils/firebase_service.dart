import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseServices {
  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseMessaging get firebaseMessaging => FirebaseServices._firebaseMessaging ?? FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initializeFirebase() async {
    FirebaseServices._firebaseMessaging = FirebaseMessaging.instance;
    await FirebaseServices.initializeLocalNotifications();
    await FirebaseServices.onMessage();
    await FirebaseServices.onBackgroundMsg();
  }

  Future<String?> getDeviceToken() async => await FirebaseMessaging.instance.getToken();



  static Future<void> initializeLocalNotifications() async {
    final InitializationSettings _initSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/launcher_icon"),
        iOS: DarwinInitializationSettings()
    );
    /// on did receive notification response = for when app is opened via notification while in foreground on android
    await FirebaseServices._localNotificationsPlugin.initialize(_initSettings);
    /// need this for ios foregournd notification
    await FirebaseServices.firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  static NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails(
      "high_importance_channel", "High Importance Notifications", priority: Priority.max, importance: Importance.max,
    ),
  );

  static Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (Platform.isAndroid) {
        // if this is available when Platform.isIOS, you'll receive the notification twice

        String? title = message.notification!.title;
        String? msg = message.notification!.body;

        await FirebaseServices._localNotificationsPlugin.show(
          0, title, msg, FirebaseServices.platformChannelSpecifics,
          payload: message.data.toString(),
        );
        // await FirebaseService._localNotificationsPlugin.show(
        //   0, message.notification!.title, message.notification!.body, FirebaseService.platformChannelSpecifics,
        //   payload: message.data.toString(),
        // );
      }
    });
  }

  static Future<void> onBackgroundMsg() async {
    Stream<RemoteMessage> _stream = FirebaseMessaging.onMessageOpenedApp;
    _stream.listen((RemoteMessage event) async {
      if (event.data != null) {
        if (Platform.isAndroid) {
          // if this is available when Platform.isIOS, you'll receive the notification twice
          print("Message ${event.notification!.title}");
          // String title = event.data['title'];
          // String msg = event.data['body'];
          String? title = event.notification!.title;
          String? msg = event.notification!.body;

          await FirebaseServices._localNotificationsPlugin.show(
            0, title, msg, FirebaseServices.platformChannelSpecifics,
            payload: event.data.toString(),
          );
          // await FirebaseService._localNotificationsPlugin.show(
          //   0, message.notification!.title, message.notification!.body, FirebaseService.platformChannelSpecifics,
          //   payload: message.data.toString(),
          // );
        }
      }
    });
  }
}