import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String expireDate = DateFormat("yyyy-MM-dd hh:mm:ss")
      .format(DateTime.now().add(Duration(seconds: 60)));
  prefs.setString('expireDate', expireDate.toString());
  return prefs.setString('token', value);
}

Future<bool> expireToken() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(prefs.getString('expireDate')!);
    return tempDate.compareTo(DateTime.now()) < 0;
  } catch (e) {
    return true;
  }
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  return prefs.getString('token');
}