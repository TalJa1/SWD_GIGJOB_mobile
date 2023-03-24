// ignore_for_file: avoid_print

import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DTO/HistoryDTO.dart';
import 'package:gigjob_mobile/DTO/UserDTO.dart';
import 'package:gigjob_mobile/DTO/WalletDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/services/request.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:intl/intl.dart';

import '../DTO/MetaDataDTO.dart';

class UserDAO extends BaseDAO {
  late MetaDataDTO _metaDataDTO;

  JobDAO jobDAO = JobDAO();

  @override
  MetaDataDTO get metaDataDTO => _metaDataDTO;

  Future<WorkerDTO> getProfile(String id) async {
    // ignore: unnecessary_brace_in_string_interps
    final res = await ApiService.get("/v1/worker/account/${id}", null, null);
    WorkerDTO userDTO = WorkerDTO.fromJson(res.data);
    return userDTO;
  }

  Future registerWorker(WorkerDTO dto) async {
    try {
      String? accID = await getAccountID();
      Future<WorkerDTO> workerID = jobDAO.getWorkerId(accID!);
      final res = await ApiService.post("/v1/worker", null, null, {
        "accountId": workerID,
        "firstName": dto.firstName,
        "lastName": dto.lastName,
        "middleName": dto.middleName,
        "birthday": dto.birthday,
        "phone": dto.phone,
        "education": dto.education,
        "username": dto.username,
        "password": dto.password
      });
      // ignore: avoid_print
      print(res.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future updateUserprofile(WorkerDTO dto, String workerID) async {
    try {
      String? accID = await getAccountID();
      // String? birth = dto.birthday;
      // DateTime parsedDate = DateTime.parse(birth!);
      // // ignore: unused_local_variable
      // String formattedDateTime =
      //     DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(parsedDate.toUtc());
      // Future<WorkerDTO> workerID = jobDAO.getWorkerId(accID!);
      final res = await ApiService.put("/v1/worker", null, null, {
        "id": workerID,
        "accountId": accID,
        "firstName": dto.firstName,
        "lastName": dto.lastName,
        "middleName": dto.middleName,
        "birthday": dto.birthday,
        "phone": dto.phone,
        "education": dto.education,
        "username": dto.username,
        "password": dto.password
      });
      // print(res.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<WalletDTO?> getWallet() async {
    String? accid = await getAccountID();
    final res = await ApiService.get('/v1/wallet/account/$accid', null, null);
    WalletDTO walletDTO = WalletDTO.fromJson(res.data);
    return walletDTO;
  }

  Future<List<HistoryDTO>> getHistory(String? workerid) async {
    try {
      final res =
          await ApiService.get('/v1/history/worker/$workerid', null, null);
      List<dynamic> list = res.data;
      final history = HistoryDTO.fromList(list);
      return history;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future addHitory(HistoryDTO historyDTO, String? workerid) async {
    try {
      final res = await ApiService.post("/v1/history", null, null, {
        "workerId": workerid,
        "position": historyDTO.position,
        "startDate": historyDTO.startDate,
        "endDate": historyDTO.endDate
      });
      print("res.statusCode >>>>>>> ${res.statusCode}");
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future updateHistory(HistoryDTO dto) async {
    try {
      final res = await ApiService.put("/v1/history", null, null, {
        "id": dto.id,
        "position": dto.position,
        "startDate": dto.startDate,
        "endDate": dto.endDate
      });
      print("res.statusCode >>>>>>> $res");
    } catch (e) {
      print(e);
    }
  }
}
