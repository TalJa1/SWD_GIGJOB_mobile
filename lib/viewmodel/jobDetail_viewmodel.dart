import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';



class JobDetailViewModel extends BaseModel {
  List<ApplyJobDTO>? appliedjob;
  JobDTO? jobDTO;
  JobDAO? jobDAO;
  ApplyJobDTO? isApplied;


  JobDetailViewModel() {
    jobDAO = JobDAO();
  }

  Future getJobApplied(int? jobID) async {
    try {
      setState(ViewStatus.Loading);
      jobDTO = await jobDAO?.getJobById(jobID);
      String? accountId = await getAccountID();
      WorkerDTO? workDTO = await jobDAO?.getWorkerId(accountId!);
      appliedjob = await jobDAO?.getJobApplied(workDTO?.id);
      isApplied = isAppliedJob(appliedjob, jobDTO);
      setState(ViewStatus.Completed);
    } catch (e) {
      print(e);
    }
  }

  ApplyJobDTO? isAppliedJob(List<ApplyJobDTO>? appliedjob, JobDTO? jobDTO) {
    List<ApplyJobDTO>? list = 
    [...appliedjob!];

    for (var i = 0; i < list.length; i++) {
      if (list[i].job?.id == jobDTO?.id) {
        return list[i];
      }
    }
    print("nulls");
    return null;
  }
}