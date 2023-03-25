import 'package:gigjob_mobile/DAO/AccountDAO.dart';
import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/services/locaiton_service.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';
import 'package:jwt_decode/jwt_decode.dart';

class JobDetailViewModel extends BaseModel {
  List<ApplyJobDTO>? appliedjob;
  List<JobDTO>? relateJobs;
  JobDTO? jobDTO;
  JobDAO? jobDAO;
  AccountDAO? accountDAO;
  ApplyJobDTO? isApplied;
  LocationService? locationService;
  Addresses? address;

  JobDetailViewModel() {
    jobDAO = JobDAO();
    accountDAO = AccountDAO();
    locationService = LocationService();
  }

  Future getJobApplied(int? jobID) async {
    try {
      setState(ViewStatus.Loading);
      jobDTO = await jobDAO?.getJobById(jobID);
      String? accountId = await getAccountID();
      WorkerDTO? workDTO = await jobDAO?.getWorkerId(accountId!);
      appliedjob = await jobDAO?.getJobApplied(workDTO?.id);
      isApplied = isAppliedJob(appliedjob, jobDTO);
      address = await jobDAO?.getAddress(jobDTO!.shop!.accountId);
      relateJobs = await jobDAO?.getJob(body: {
        "searchCriteriaList": [
          {
            "filterKey": "shop",
            "value": jobDTO!.shop!.id,
            "operation": "eq"
          },
          {
            "filterKey": "jobType",
            "value": jobDTO!.jobType!.id,
            "operation": "eq"
          }
        ],
        "sortCriteria": {"sortKey": "createdDate", "direction": "asc"},
        "dataOption": "any",
        "latitude": locationService!.defaultLatitude,
        "longitude": locationService!.defaultLongtitude
      });
      setState(ViewStatus.Completed);
    } catch (e) {
      print(e);
    }
  }

  ApplyJobDTO? isAppliedJob(List<ApplyJobDTO>? appliedjob, JobDTO? jobDTO) {
    List<ApplyJobDTO>? list = [...appliedjob!];

    for (var i = 0; i < list.length; i++) {
      if (list[i].job?.id == jobDTO?.id) {
        return list[i];
      }
    }
    print("nulls");
    return null;
  }

  Future<String> getAccountId() async {
    try {
      String? token = await getToken();
      Map<String, dynamic> decode = Jwt.parseJwt(token!);
      print(decode['account']['id']);
      return decode['account']['id'];
    } catch (e) {
      print(e.toString());
    }
    return "";
  }

  Future<bool> applyJob(int? jobId) async {
    try {
      setState(ViewStatus.Loading);
      String accountID = await getAccountId();
      WorkerDTO workerDTO = await JobDAO().getWorkerId(accountID);
      print("Worker id ${workerDTO.id}");
      bool isApply = await JobDAO().applyJob(workerDTO.id, jobId);
      String? fcmToken = await getFCMToken();
      if (isApply) {
        await accountDAO?.postFcmToken(fcmToken, "Apply job", "SUCCESS");
      }
      setState(ViewStatus.Completed);
      return isApply;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
