import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DAO/UserDAO.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/UserDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';

import '../DAO/JobDAO.dart';

class UserViewModel extends BaseModel {
  JobDAO? jobDAO;
  UserDAO? userDAO;
  List<JobDTO>? jobs;
  List<ApplyJobDTO>? appliedjob;
  WorkerDTO? userDTO;
  // ignore: non_constant_identifier_names
  UserViewModel() {
    jobDAO = JobDAO();
    userDAO = UserDAO();
  }

  Future getAppliedJob() async {
    try {
      setState(ViewStatus.Loading);
      String? accountId = await getAccountID();
      WorkerDTO? workDTO = await jobDAO?.getWorkerId(accountId!);
      appliedjob = await jobDAO?.getJobApplied(workDTO?.id);
      setState(ViewStatus.Completed);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future processLogout() async {
    try {
      await DefaultCacheManager().emptyCache();
      await clearCacheAndStorage();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      await removeALL();

      Get.offAll(LoginHome());
    } catch (e) {
      print(e);
    }
  }

  Future getUserProfile() async {
    try {
      String? accountId = await getAccountID();
      setState(ViewStatus.Loading);
      userDTO = await userDAO?.getProfile(accountId!);
      setState(ViewStatus.Completed);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future updateUser(WorkerDTO dto, String workerID) async {
    try {
      await userDAO?.updateUserprofile(dto, workerID);
    } catch (e) {
      throw Exception(e);
    }
  }
}
