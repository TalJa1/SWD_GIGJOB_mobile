// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/view/confirmation_code.dart';
import 'package:gigjob_mobile/view/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (BuildContext context) => SignUp(),
      '/confirm': (BuildContext context) => ConfirmationCode()
    });
  }
}
