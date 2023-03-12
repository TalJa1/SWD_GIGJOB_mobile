import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DAO/AccountDAO.dart';
import 'package:gigjob_mobile/DTO/AccountDTO.dart';
import 'package:gigjob_mobile/accesories/dialog.dart';
import 'package:gigjob_mobile/services/push_notification_service.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends BaseModel {
  AccountDAO dao = AccountDAO();

  AccountDTO? user;
  bool _isSigningIn = false;

  Future<void> signinWithGoogle(BuildContext context) async {

    if (_isSigningIn) {
    return;
  }
  _isSigningIn = true;
    try {
      
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = await GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCre =
          await FirebaseAuth.instance.signInWithCredential(credential);

      String? token = await googleAuth?.idToken;
      String? fcmToken =
          await PushNotificationService.getInstance()?.getFcmToken();

      // AccountDTO? accountDTO = await dao.postToken(token);
      await dao.postToken(token);
      await dao.postFcmToken(fcmToken);

      Get.to(RootScreen());
    } catch (e) {
      await showMyDialog(context, "Error", "Login fail");
    }finally {
    _isSigningIn = false;
  }
  }
}
