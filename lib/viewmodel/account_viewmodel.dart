import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DAO/AccountDAO.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';

class AccountViewModel extends BaseModel {
  AccountDAO dao = AccountDAO();

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await removeALL();
    await Get.to(() => LoginHome());
  }
}
