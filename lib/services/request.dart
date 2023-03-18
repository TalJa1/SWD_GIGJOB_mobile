import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ApiService {
  static const String baseUrl = 'http://13.228.218.62:8080/api';
  // static const String baseUrl = 'http://54.179.205.85:8080/api';
  // static const String baseUrl = 'http://localhost/api';

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
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  ) async {
    headers ??= {};
    body ??= {};
    queryParams ??= {};

    try {
      print(baseHeaders);
      final response = await dio.post(
        path,
        queryParameters: queryParams,
        data: body,
        options: Options(headers: {...baseHeaders, ...headers}),
      );
      return response;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await DefaultCacheManager().emptyCache();
        await clearCacheAndStorage();
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
        await removeALL();
        await ApiService.setToken("");
        print(baseHeaders);
        Get.offAll(LoginHome());
        throw Exception(e.message);
      }
      if (e.response != null) {
        throw Exception(e.response);
      } else {
        await DefaultCacheManager().emptyCache();
        await clearCacheAndStorage();
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
        await removeALL();
        await ApiService.setToken("");
        print(baseHeaders);
        Get.offAll(LoginHome());
        throw Exception(e.message);
      }
    }
  }

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
      if (e.response?.statusCode == 401) {
        await DefaultCacheManager().emptyCache();
        await clearCacheAndStorage();
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
        await removeALL();
        await ApiService.setToken("");

        Get.offAll(LoginHome());
        throw Exception(e.message);
      }
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
    if (token.isNotEmpty) {
      baseHeaders["Authorization"] = "Bearer $token";
    } else {
      baseHeaders["Authorization"] = "";
    }
  }
}
