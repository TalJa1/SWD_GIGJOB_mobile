// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/view/confirmation_code.dart';
import 'package:gigjob_mobile/view/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (BuildContext context) => LoginHome(),
      '/confirm': (BuildContext context) => ConfirmationCode(),
      '/signup': (BuildContext context) => SignUp()
    });
  }
}
