import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/UserDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/services/request.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';

import '../DTO/MetaDataDTO.dart';

class UserDAO extends BaseDAO {
  late MetaDataDTO _metaDataDTO;

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
      final res = await ApiService.post("/v1/worker", null, null, {
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
      // ignore: avoid_print
      print(res.data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
