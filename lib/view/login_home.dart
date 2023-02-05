// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // ignore: avoid_unnecessary_containers
            Container(
              // padding: EdgeInsets.only(top: 100),
              child: Image.asset(
                'assets/images/GigJob.png',
              ),
            ),
            // ignore: avoid_unnecessary_containers
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                onChanged: (value) => {},
                decoration: InputDecoration(
                    hintText: 'Phone number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) => {},
                decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            Center(
              child: TextButton(
                  child: Text('Forgot password?'),
                  onPressed: () {
                    // ignore: avoid_print
                    print('trigger');
                  }),
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
              thickness: 1,
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    // ignore: avoid_print
                    print('login');
                  },
                  child: Text("Login"),
                ),
              ),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Not a member? ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                    text: 'Register now',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // ignore: avoid_print
                        print('Login Text Clicked');
                      }),
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Or continue with'),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    margin: EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () {
                        // ignore: avoid_print
                        print('Google');
                      }, // Image tapped
                      child: Image.asset(
                        'assets/images/GoogleBtn.png',
                      ),
                    ),
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    margin: EdgeInsets.only(left: 6),
                    child: GestureDetector(
                      onTap: () {
                        // ignore: avoid_print
                        print('Facebook');
                      }, // Image tapped
                      child: Image.asset(
                        'assets/images/FacebookBtn.png',
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
