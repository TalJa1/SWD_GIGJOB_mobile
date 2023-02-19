import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileDAO extends BaseDAO {
  final ImagePicker picker = ImagePicker();

  Future pickImg(XFile? pickedFile) async {
    // ignore: unused_local_variable
    pickedFile = (await picker.pickImage(source: ImageSource.gallery));
  }

  Future<String> uploadImage(XFile? file) async {
    Dio dio = Dio();
    String fileName = file!.path.split('/').last;
    final Uint8List bytes = await file.readAsBytes();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YOUR_API_TOKEN',
    };
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(bytes,
          filename: fileName, contentType: new MediaType('image', 'jpeg')),
    });
    try {
      Response response = await dio.post(
          "http://ec2-18-141-203-185.ap-southeast-1.compute.amazonaws.com/api/v1/resource/upload",
          data: formData);
      return "Upload Status for $fileName ${response.statusCode}";
    } catch (e) {
      return e.toString();
    }
  }
}
