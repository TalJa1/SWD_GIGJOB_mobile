import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';



class PushNotificationService {
  static PushNotificationService? _instance;
  
  static PushNotificationService? getInstance() {
    if (_instance == null) {
      _instance = PushNotificationService();
    }
    return _instance;
  }


  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String?> getFcmToken() async {
    if (!isSmartPhoneDevice()) return null;
    String? token = await _fcm.getToken();
    return token;
  }
}

bool isSmartPhoneDevice() {
  return (defaultTargetPlatform == TargetPlatform.iOS) ||
      (defaultTargetPlatform == TargetPlatform.android);
}
