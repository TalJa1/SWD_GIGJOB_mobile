import 'package:gigjob_mobile/viewmodel/base_model.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class LocationService {
  late Location location;
  late LocationData locationData;
  

  final formatter = NumberFormat('.######');
  final double defaultLatitude = 91;
  final double defaultLongtitude = 181;
  

  LocationService() {
    location = Location();
  }

  Future enableLocation() async {
    bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
  }
}
