



import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gigjob_mobile/DAO/AccountDAO.dart';
import 'package:gigjob_mobile/DTO/AccountDTO.dart';
import 'package:gigjob_mobile/services/push_notification_service.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends BaseModel {
   AccountDAO dao = AccountDAO();

   AccountDTO? user;

  Future<void> signinWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      // print("access token ${googleAuth?.accessToken}");
      // print("id token ${googleAuth?.idToken}");

      UserCredential userCre =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCre.credential?.token ?? "");

      String? token = googleAuth?.idToken;
      String? fcmToken = await PushNotificationService.getInstance()?.getFcmToken();

      dao.postFcmToken(fcmToken);
      final accountDTO = dao.postToken(token);
      if (accountDTO != null) {
        Route route = MaterialPageRoute(builder: (context) => RootScreen());
        Navigator.push(context as BuildContext, route);
      }
    } catch (e) {
      print(e);
    }
  }
}