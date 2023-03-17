import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DAO/UserDAO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/viewmodel/base_model.dart';

class RegisterViewModel extends BaseModel {
  UserDAO? userDAO;

  Future registerWorker(WorkerDTO workerDTO) async {
    try {
      final res = await UserDAO().registerWorker(workerDTO);
    } catch (e) {
      throw Exception(e);
    }
  }
}
