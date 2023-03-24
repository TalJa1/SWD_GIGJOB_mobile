// ignore_for_file: file_names, unnecessary_new

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/services/request.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import '../utils/share_pref.dart';

class UploadFileService extends BaseDAO {
  String urlAPI = "http://13.228.218.62:8080/api/v1/resource/upload";
  String urlAPIl = "/v1/resource/upload";

  Future<String> uploadImage(XFile? file) async {
    Map<String, String> baseHeaders = ApiService.getHeader();
    Dio dio = Dio();
    dio.options.headers = baseHeaders;
    String fileName = file!.path.split('/').last;
    final Uint8List bytes = await file.readAsBytes();
    String? accId = await getAccountID();
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(bytes,
          filename: fileName, contentType: new MediaType('image', 'jpeg')),
    });
    try {
      Response response = await dio.post(
          "http://13.228.218.62:8080/api/v1/account/$accId/image",
          data: formData);
      // Response response = await ApiService.patch("/v1/account/$accId/image",
      //     null, {"Content-Type": "multipart/form-data"}, formData);
      return "Upload Status for $fileName ${response.statusCode}";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
