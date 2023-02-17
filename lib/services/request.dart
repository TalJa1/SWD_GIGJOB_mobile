import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://ec2-18-141-203-185.ap-southeast-1.compute.amazonaws.com/api/v1';

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl + path),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  static Future<Map<String, dynamic>> get(
    String path,
    Map<String, String> headers,
  ) async {
    final response = await http.get(
      Uri.parse(baseUrl + path),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<dynamic> put(String path, dynamic data) async {
    final url = Uri.parse(baseUrl + path);

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    final parsedJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return parsedJson;
    } else {
      throw Exception('Failed to update data.');
    }
  }
}
