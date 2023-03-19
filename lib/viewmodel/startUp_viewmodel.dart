import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DAO/AccountDAO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:gigjob_mobile/view/register_Worker.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';

class StartUpViewModel extends BaseModel {
  late BuildContext context;
  bool loadingWelcome = true;

  StartUpViewModel() {
    handleStartUpLogic();
  }

  Future handleStartUpLogic() async {
    AccountDAO _accountDAO = AccountDAO();

    bool hasLoggedInUser = await _accountDAO.isUserLoggedIn();

    await Future.delayed(Duration(seconds: 1), () {
      loadingWelcome = false;
    });

    if (hasLoggedInUser) {
      Get.offAll(RegisterWorkerPage());
    } else {
      Get.offAll(RootScreen());
    }
  }

  Widget _buildWelcomePage() {
    return Container(
      color: Colors.black,
      child: Text("Welcome"),
    );
  }
}
