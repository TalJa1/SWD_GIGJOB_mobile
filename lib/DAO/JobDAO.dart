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
    try{
    final res = await ApiService.get('/v1/job', null, params);
    List<dynamic> list = res.data;
    final jobs = JobDTO.fromList(list);
    return jobs;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    
  }

  Future<bool> applyJob(String? id, int jobId) async {
    try {
      final res = await ApiService.post('/v1/application', null,
        {"workerId": id, "status": "PENDING", "jobId": jobId});
      return true;
    // ignore: avoid_print
    print(res);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<WorkerDTO> getWorkerId(String accId) async {
    final res = await ApiService.get('/workers/account/$accId', null, null);
    WorkerDTO workerDTO = WorkerDTO.fromJson(res.data);
    return workerDTO;
  }

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}
