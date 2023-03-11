// ignore_for_file: file_names

import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/MetaDataDTO.dart';
import 'package:gigjob_mobile/services/request.dart';

class JobDAO extends BaseDAO {
  late MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  Future<List<JobDTO>> getJob({Map<String, dynamic>? params}) async {
    try {
      final res = await ApiService.get('/job', null, params);
    final jobs = JobDTO.fromList(res);
    return jobs;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    
  }

  Future applyJob(String id, int jobId) async {
    final res = await ApiService.post('/application', null,
        {"workerId": id, "status": "PENDING", "jobId": jobId});
    // ignore: avoid_print
    print(res);
  }

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}
