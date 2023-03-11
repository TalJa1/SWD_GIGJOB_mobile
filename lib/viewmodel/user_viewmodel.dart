import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';

import '../DAO/JobDAO.dart';

class UserViewModel extends BaseModel {
  JobDAO? jobDAO;
  List<JobDTO>? jobs;
  List<ApplyJobDTO>? appliedjob;
  // ignore: non_constant_identifier_names
  UserViewModel() {
    jobDAO = JobDAO();
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
}
