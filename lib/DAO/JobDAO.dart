
import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/MetaDataDTO.dart';
import 'package:gigjob_mobile/services/request.dart';

class JobDAO extends BaseDAO {

  late MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  Future<List<JobDTO>> getJob({
    Map<String, dynamic>? params
  }) async {
    final res = await ApiService.get('/job', null, params);
    final jobs = JobDTO.fromList(res);
    return jobs;
  }

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}