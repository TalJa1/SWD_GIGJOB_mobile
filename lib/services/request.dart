import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://54.179.205.85:8080/api';

  static Map<String, String> baseHeaders = {
    'Content-Type': 'application/json',
    'Authorization': '',
  };

  static Map<String, String> getHeader() {
    return baseHeaders;
  }

  static Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

  static Future<Response> post(
    String path,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  ) async {
    headers ??= {};
    body ??= {};
    try {
      final response = await dio.post(
        path,
        data: body,
        options: Options(headers: {...baseHeaders, ...headers}),
      );
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(e.response);
      } else {
        throw Exception(e.message);
      }
    }
  }

  // static Future<String> postString(
  //   String path,
  //   Map<String, String>? headers,
  //   Map<String, dynamic>? body,
  // ) async {
  //   headers ??= {};
  //   body ??= {};
  //   try {
  //     final response = await dio.post(
  //       path,
  //       data: body,
  //       options: Options(headers: {...baseHeaders, ...headers}),
  //     );
  //     return response.data;
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       throw Exception(e.response!.data);
  //     } else {
  //       throw Exception(e.message);
  //     }
  //   }
  // }

  static Future<Response> get(
    String path,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  ) async {
    headers ??= {};
    queryParams ??= {};
    try {
      print(baseHeaders);
      final response = await dio.get(
        path,
        queryParameters: queryParams,
        options: Options(headers: {...baseHeaders, ...headers}),
      );
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  static Future<Map<String, dynamic>> getMap(
    String path,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  ) async {
    headers ??= {};
    queryParams ??= {};
    try {
      print(baseHeaders);
      final response = await dio.get(
        path,
        queryParameters: queryParams,
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

  static Future<dynamic> put(
      String path, dynamic data, Map<String, String>? headers) async {
    headers ??= {};
    try {
      final response = await dio.put(
        path,
        data: data,
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

  static setToken(String token) {
    baseHeaders["Authorization"] = "Bearer $token";
  }
}
