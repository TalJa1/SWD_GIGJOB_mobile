

import 'package:flutter/material.dart';
import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/accesories/dialog.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';

class JobViewModel extends BaseModel {

  JobDAO? jobDAO;
  List<JobDTO>? jobs;
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
      throw Exception(e);
    }
  }
}