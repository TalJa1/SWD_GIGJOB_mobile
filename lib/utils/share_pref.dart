import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';


Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String expireDate = DateFormat("yyyy-MM-dd hh:mm:ss")
      .format(DateTime.now().add(Duration(days: 20)));
  prefs.setString('expireDate', expireDate.toString());
  return prefs.setString('token', value);
}

Future<bool> setAccountId(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.setString('AccountID', value);
}

Future<bool> expireToken() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(prefs.getString('expireDate')!);
    return tempDate.compareTo(DateTime.now()) < 0;
  } catch (e) {
    return true;
  }
}

Future<bool> setFCMToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.setString('fcmToken', value);
}

Future<String?> getFCMToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString('fcmToken');
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString('token');
}

Future<String?> getAccountID() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString('AccountID');
}

Future<void> removeALL() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<void> clearCacheAndStorage() async {
  final cacheDir = await getTemporaryDirectory();
  final appDir = await getApplicationSupportDirectory();
  
  await Future.wait([
    Directory(cacheDir.path).delete(recursive: true),
    Directory(appDir.path).delete(recursive: true),
  ]);
}