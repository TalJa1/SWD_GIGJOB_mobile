import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl =
      'http://ec2-13-229-83-87.ap-southeast-1.compute.amazonaws.com/api/v1';

  static Map<String, String> baseHeaders = {
    'Content-Type': 'application/json',
    'Authorization': '',
  };

  static Map<String, String> getHeader() {
    return baseHeaders;
  }

  static Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) async {
    try {
      final response = await dio.post(
        path,
        data: body,
        options: Options(headers: {...baseHeaders, ...headers}),
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  static Future<Map<String, dynamic>> get(
    String path,
    Map<String, String> headers,
  ) async {
    try {
      final response = await dio.get(
        path,
        options: Options(headers: {...baseHeaders, ...headers}),
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  static Future<dynamic> put(String path, dynamic data) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  static setToken(String token) {
    baseHeaders["Authorization"] = "Bearer $token";
  }
}
