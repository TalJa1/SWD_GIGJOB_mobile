import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/accesories/dialog.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';

class JobViewModel extends BaseModel {
  JobDAO? jobDAO;
  List<JobDTO>? jobs;
  ApplyJobDTO? appliedjob;
  JobViewModel() {
    jobDAO = JobDAO();
  }

  Future getJobs({Map<String, dynamic>? params}) async {
    try {
      setState(ViewStatus.Loading);
      jobs = await jobDAO?.getJob(params: params);
      setState(ViewStatus.Completed);
      // print(products);
    } catch (e) {
      await FirebaseAuth.instance.signOut();
      await removeALL();
      Get.offAll(LoginHome());
      throw Exception(e);
    }
  }
}
