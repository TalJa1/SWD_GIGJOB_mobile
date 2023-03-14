import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/UserDTO.dart';
import 'package:gigjob_mobile/services/request.dart';

import '../DTO/MetaDataDTO.dart';

class UserDAO extends BaseDAO {
  late MetaDataDTO _metaDataDTO;

  @override
  MetaDataDTO get metaDataDTO => _metaDataDTO;

  Future<UserDTO> getProfile(String id) async {
    final res = await ApiService.get("/workers/account/$id", null, null);
    UserDTO userDTO = res.data;
    return userDTO;
  }
}
