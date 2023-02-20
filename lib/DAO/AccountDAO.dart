import 'dart:convert';


import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/AccountDTO.dart';
import 'package:gigjob_mobile/services/request.dart';
import 'package:http/http.dart' as http;

class AccountDAO extends BaseDAO {
  Future<void> postToken(String? idToken) async {

    try {

      String path = "/account/login-google";
      Map<String, String> headers = {
        'idTokenString': idToken ?? "",
      };

      final response = await ApiService.post(path, headers, null);

    
      // final userDTO = AccountDTO.fromJson(response);
      ApiService.setToken(response["accessToken"]);
      // print(response);
      // return userDTO;
    } catch (e) {
      throw Exception(e);
    }
    // return null;
  }

  Future<bool> postFcmToken(String? fcmToken) async {

    try {

      String path = "/send-notification";
      Map<String, String> headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "subject": "FROM ME",
        "content": "TO HUY",
        "imageUrl": "",
        "data": {
          "additionalProp1": "",
          "additionalProp2": "",
          "additionalProp3": ""
        },
        'registrationTokens': [fcmToken]
      };

      final response = await ApiService.post(path, headers, body);

      // print(response);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
