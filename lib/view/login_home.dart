// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gigjob_mobile/DTO/AccountDTO.dart';
import 'package:gigjob_mobile/services/push_notification_service.dart';
import 'package:gigjob_mobile/view/sign_up.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:gigjob_mobile/view/confirmation_code.dart';
import 'package:gigjob_mobile/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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
    bool isLogin = false;

    FirebaseAuth auth = FirebaseAuth.instance;
    var phone = '';

    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

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
                keyboardType: TextInputType.phone,
                onChanged: (value) => {
                  if (value.isEmpty || value.length != 10) ...[
                    isLogin = false,
                  ] else ...[
                    phone = value,
                    isLogin = true,
                  ]
                },
                decoration: InputDecoration(
                    hintText: 'Phone number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton(
                  onPressed: () async {
                    // ignore: avoid_print
                    if (isLogin == true) {
                      auth.verifyPhoneNumber(
                        phoneNumber: '+84 ${phone}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          await auth
                              .signInWithCredential(credential)
                              .then((value) {
                            print('successful');
                          });
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          if (e.code == 'invalid-phone-number') {
                            // ignore: avoid_print
                            print('The provided phone number is not valid.');
                          }
                        },
                        codeSent:
                            (String verificationId, int? resendToken) async {
                          String smsCode = 'xxxx';

                          // Create a PhoneAuthCredential with the code
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsCode);

                          // Sign the user in (or link) with the credential
                          await auth.signInWithCredential(credential);
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                      Route route = MaterialPageRoute(
                          builder: (context) => ConfirmationCode());
                      // ignore: use_build_context_synchronously
                      Navigator.push(context, route);
                    } else {
                      // ignore: avoid_print
                      print('wrong');
                    }
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
                        Route route =
                            MaterialPageRoute(builder: (context) => SignUp());
                        Navigator.push(context, route);
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
                        // print('Google');
                        signinWithGoogle();
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
                        FirebaseAuth.instance.signOut();
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

  signinWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      print("access token ${googleAuth?.accessToken}");
      print("id token ${googleAuth?.idToken}");

      UserCredential userCre =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCre.credential?.token ?? "");

      String? token = googleAuth?.idToken;
      String? fcmToken =
          await PushNotificationService.getInstance()?.getFcmToken();

      postFcmToken(fcmToken);
      final accountDTO = postToken(token);
      if (accountDTO != null) {
        Route route = MaterialPageRoute(builder: (context) => RootScreen());
        Navigator.push(context, route);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> postFcmToken(String? fcmToken) async {
    var url = Uri.parse(
        "http://ec2-18-141-146-248.ap-southeast-1.compute.amazonaws.com/api/v1/send-notification");

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "subject": "",
            "content": "",
            "imageUrl": "",
            "data": {
              "additionalProp1": "",
              "additionalProp2": "",
              "additionalProp3": ""
            },
            'registrationTokens': [fcmToken]
          }));

      print(response);

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return true;
      } else {
        throw Exception('Failed to post token');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<AccountDTO?> postToken(String? token) async {
    var url = Uri.parse(
        "http://ec2-18-141-146-248.ap-southeast-1.compute.amazonaws.com/api/v1/account/authenticate-google");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'idTokenString': token ?? ""
        },
      );

      print(response);

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        final user = response.body;
        final userDTO = AccountDTO.fromJson(jsonDecode(user));
        return userDTO;
      } else {
        throw Exception('Failed to post token');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
