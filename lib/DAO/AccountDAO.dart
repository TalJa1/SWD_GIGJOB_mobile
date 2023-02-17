import 'dart:convert';

import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/DTO/AccountDTO.dart';
import 'package:gigjob_mobile/services/request.dart';
import 'package:http/http.dart' as http;

class AccountDAO extends BaseDAO {
  Future<AccountDTO?> postToken(String? idToken) async {
    var url = Uri.parse(
        "http://ec2-18-141-203-185.ap-southeast-1.compute.amazonaws.com/api/v1/account/authenticate-google");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'idTokenString': idToken ?? ""
        },
      );

      String path = "/account/authenticate-google";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'idTokenString': idToken ?? ""
      };

      final res = ApiService.post(path, headers, null);


      if (response.statusCode == 200) {
        final user = response.body;
        final userDTO = AccountDTO.fromJson(jsonDecode(user));
        return userDTO;
      } else {
        throw Exception('Failed to post token');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> postFcmToken(String? fcmToken) async {
    var url = Uri.parse(
        "http://ec2-18-141-203-185.ap-southeast-1.compute.amazonaws.com/api/v1/send-notification");

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "subject": "",
            "content": "",
            "imageUrl": "",
            "data": {
              "additionalProp1": "",
              "additionalProp2": "",
              "additionalProp3": ""
            },
            'registrationTokens': [fcmToken]
          }));

      String path = "/send-notification";
      Map<String, String> headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "subject": "",
        "content": "",
        "imageUrl": "",
        "data": {
          "additionalProp1": "",
          "additionalProp2": "",
          "additionalProp3": ""
        },
        'registrationTokens': [fcmToken]
      };

      final res = ApiService.post(path, headers, body);

      print(response);

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return true;
      } else {
        throw Exception('Failed to post token');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
