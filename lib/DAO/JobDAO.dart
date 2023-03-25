// ignore_for_file: file_names, unnecessary_brace_in_string_interps, unused_local_variable

import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/MetaDataDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/services/request.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';

class JobDAO extends BaseDAO {
  late MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  Future<List<JobDTO>> getJob(
      {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    try {
      final res = await ApiService.post('/v1/job/search', params, null, body);
      List<dynamic> list = res.data;
      final jobs = JobDTO.fromList(list);
      return jobs;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<bool> applyJob(String? id, int? jobId) async {
    try {
      final res = await ApiService.post('/v1/application', null, null,
          {"workerId": id, "status": "PENDING", "jobId": jobId});

      return true;
      // ignore: avoid_print
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<WorkerDTO> getWorkerId(String accId) async {
    final res = await ApiService.get('/v1/worker/account/$accId', null, null);
    WorkerDTO workerDTO = WorkerDTO.fromJson(res.data);
    return workerDTO;
  }

  Future<List<ApplyJobDTO>> getJobApplied(String? workerID) async {
    final res =
        await ApiService.get('/v1/application/worker/${workerID}', null, null);
    List<ApplyJobDTO> applyJobDTO = ApplyJobDTO.fromList(res.data);
    return applyJobDTO;
  }

  Future<JobDTO> getJobById(int? jobID) async {
    try {
      final res = await ApiService.get("/v1/job/${jobID}", null, null);
      JobDTO job = JobDTO.fromJson(res.data);
      return job;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<JobDTO>> getRelateJobs(
      {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    try {
      final res = await ApiService.post('/v1/job/search', params, null, body);
      List<dynamic> list = res.data;
      final jobs = JobDTO.fromList(list);
      return jobs;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<Addresses?> getAddress(String? shopID) async {
    
    final res = await ApiService.get('/v1/shop/$shopID', {}, {});
    try {
    Shop shop = Shop.fromJson(res.data);
    return shop.addresses!.first;

    } catch (e) {
      print(e);
    }
    return null;
  }

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}
