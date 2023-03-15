import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/MetaDataDTO.dart';
import 'package:gigjob_mobile/services/request.dart';

class JobTypeDAO extends BaseDAO {
  late MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  Future<List<JobType>> getJobType() async {
    try {
      // Map<String, dynamic>? body = {
      //   "filterKey": "",
      //   "value": "",
      //   "operation": "",
      //   "sortCriteria": {"sortKey": "createdDate", "direction": "asc"}
      // };
      final res = await ApiService.get('/v1/job-type', null, null);
      List<dynamic> list = res.data;
      final jobs = JobType.fromList(list);
      return jobs;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
