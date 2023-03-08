// ignore_for_file: file_names, unnecessary_new

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:gigjob_mobile/DAO/BaseDAO.dart';
import 'package:gigjob_mobile/services/request.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class UploadFileService extends BaseDAO {
  String urlAPI =
      "http://ec2-18-141-203-185.ap-southeast-1.compute.amazonaws.com/api/v1/resource/upload";
  String urlAPIlocal = "";

  Future<String> uploadImage(XFile? file) async {
    Map<String, String> baseHeaders = ApiService.getHeader();
    Dio dio = Dio();
    dio.options.headers = baseHeaders;
    String fileName = file!.path.split('/').last;
    final Uint8List bytes = await file.readAsBytes();
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(bytes,
          filename: fileName, contentType: new MediaType('image', 'jpeg')),
    });
    try {
      Response response = await dio.post(urlAPIlocal, data: formData);
      return "Upload Status for $fileName ${response.statusCode}";
    } catch (e) {
      return e.toString();
    }
  }
}
