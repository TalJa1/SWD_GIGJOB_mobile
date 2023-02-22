// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gigjob_mobile/firebase_options.dart';
import 'package:gigjob_mobile/services/push_notification_service.dart';
import 'package:gigjob_mobile/view/edit_profile.dart';
// import 'package:gigjob_mobile/view/edit_profile.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/view/confirmation_code.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:gigjob_mobile/view/post_list.dart';
import 'package:gigjob_mobile/view/post_list_detail.dart';
import 'package:gigjob_mobile/view/sign_up.dart';
import 'package:gigjob_mobile/view/wallet.dart';
import 'package:gigjob_mobile/view/user_profile.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A Background message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// Firebase local notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

//Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // final AndroidNotificationChannel channel = AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title// description
  //   importance: Importance.max,
  // );

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();

    // Request permission to receive notifications and get the device token
    messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listen to incoming messages

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message: ${message.notification!.title}");
      print("Received a message: ${message.notification!.body}");

      flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  importance: Importance.high,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher')));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new messageopen app event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("${notification.title}"),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("${notification.body}")],
                  ),
                ),
              );
            });
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/home', routes: {
      '/': (BuildContext context) => LoginHome(),
      '/confirm': (BuildContext context) => ConfirmationCode(),
      '/signup': (BuildContext context) => SignUp(),
      '/wallet': (BuildContext context) => WalletPage(),
      '/profile': (BuildContext context) => UserProfile(),
      '/home': (BuildContext context) => RootScreen(),
      'useredit': (BuildContext context) => EditProfilePage(),
    });
  }
}
