import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';

import '../DAO/JobDAO.dart';

class UserViewModel extends BaseModel {
  JobDAO? jobDAO;
  List<JobDTO>? jobs;
  List<ApplyJobDTO>? appliedjob;
  // ignore: non_constant_identifier_names
  JobViewModel() {
    jobDAO = JobDAO();
  }

  Future getAppliedJob() async {
    try {
      String? accountId = await getAccountID();
      setState(ViewStatus.Loading);
      appliedjob = await jobDAO?.getJobApplied(accountId!);
      setState(ViewStatus.Completed);
    } catch (e) {
      throw Exception(e);
    }
  }
}
