// ignore_for_file: file_names, unnecessary_brace_in_string_interps

import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/MetaDataDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/services/request.dart';

class JobDAO extends BaseDAO {
  late MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  Future<List<JobDTO>> getJob({Map<String, dynamic>? params}) async {
    final res = await ApiService.get('/job', null, params);
    final jobs = JobDTO.fromList(res);
    return jobs;
  }

  Future applyJob(String? id, int jobId) async {
    final res = await ApiService.post('/application', null,
        {"workerId": id, "status": "PENDING", "jobId": jobId});
    // ignore: avoid_print
    print(res);
  }

  Future<WorkerDTO> getWorkerId(Future<String> accId) async {
    final res = await ApiService.get('/workers/account/${accId}', null, null);

    return res.first;
  }

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}
