import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static PushNotificationService? _instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static PushNotificationService? getInstance() {
    if (_instance == null) {
      _instance = PushNotificationService();
    }
    return _instance;
  }

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future init() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message: ${message.notification!.title}");
      print("Received a message: ${message.notification!.body}");

      // _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Received background message: ${message.notification!.body}");
    });
  }

  Future<String?> getFcmToken() async {
    if (!isSmartPhoneDevice()) return null;
    String? token = await _fcm.getToken();
    return token;
  }

  Future<void> _showNotification(RemoteMessage message) async {
    
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: message.data['data'],
    );

    // const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   'high_importance_channel', // id
    //   'High Importance Notifications', // title// description
    //   importance: Importance.max,
    // );

    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();

    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

    //     flutterLocalNotificationsPlugin.show(
    //     message.notification.hashCode,
    //     message.notification?.title,
    //     message.notification?.body,
    //     NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         channel.id,
    //         channel.name,
    //         icon: message.notification?.android?.smallIcon,
    //         // other properties...
    //       ),
    //     ));
  }

  bool isSmartPhoneDevice() {
    return (defaultTargetPlatform == TargetPlatform.iOS) ||
        (defaultTargetPlatform == TargetPlatform.android);
  }
}
