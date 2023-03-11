import 'dart:convert';

import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/AccountDTO.dart';
import 'package:gigjob_mobile/services/request.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AccountDAO extends BaseDAO {
  Future<bool> isUserLoggedIn() async {
    final isExpireToken = await expireToken();
    final token = await getToken();
    if (isExpireToken) return false;
    if (token != null) ApiService.setToken(token);
    return token != null;
  }

  Future<void> postToken(String? idToken) async {
    try {
      String path = "/v1/account/login/google";
      Map<String, String> headers = {
        'idTokenString': idToken ?? "",
      };

      final response = await ApiService.post(path, headers, null);

      // final userDTO = AccountDTO.fromJson(response);
      Map<String, dynamic> decode = Jwt.parseJwt(response.data["accessToken"]);

      print(decode);
      var role = decode["account"]["role"];
      if (role == "WORKER") {
        ApiService.setToken(response.data["accessToken"]);
        setToken(response.data["accessToken"]);
      } else {
        throw Exception("Your account is invalid");
      }

      // print(response);
      // return userDTO;
    } catch (e) {
      throw Exception(e);
    }
    // return null;
  }

  Future<bool> postFcmToken(String? fcmToken) async {
    try {
      String path = "/v1/notification/send";
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
