import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gigjob_mobile/services/locaiton_service.dart';

Future setUp() async {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  LocationService location = LocationService();
  

  // Request permission to enable location
  await location.enableLocation();

  // Request permission to receive notifications and get the device token
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

}
