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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // PushNotificationService? ps = PushNotificationService.getInstance();
  // await ps?.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

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
    PushNotificationService ps = PushNotificationService();

    ps.init();
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
