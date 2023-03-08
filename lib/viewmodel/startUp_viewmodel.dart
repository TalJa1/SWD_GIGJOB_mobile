import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DAO/AccountDAO.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';

class StartUpViewModel extends BaseModel {
  late BuildContext context;

  StartUpViewModel({
    required this.context}) {
    handleStartUpLogic(context);
  }

  Future handleStartUpLogic(BuildContext context) async {
    AccountDAO _accountDAO = AccountDAO();
    bool hasLoggedInUser = await _accountDAO.isUserLoggedIn();

    if(hasLoggedInUser) {
      Route route = MaterialPageRoute(builder: (context) => RootScreen());
        Navigator.push(context, route);
    } else {
      Route route = MaterialPageRoute(builder: (context) => LoginHome());
        Navigator.push(context, route);
    }
  }
}