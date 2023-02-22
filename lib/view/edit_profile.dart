// ignore_for_file: avoid_print, sized_box_for_whitespace

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/request.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  final ImagePicker picker = ImagePicker();
  XFile? uploadfile;
  XFile? pickedFile;

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  Future pickImg() async {
    // ignore: unused_local_variable
    pickedFile = (await picker.pickImage(source: ImageSource.gallery));
    if (pickedFile != null) {
      setState(() {
        uploadfile = pickedFile;
        print(uploadfile!.path.toString());
      });
    }
    print(uploadfile);
  }

  //Post with DIO
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
      Response response = await dio.post(
          "http://ec2-13-229-83-87.ap-southeast-1.compute.amazonaws.com/api/v1/resource/upload",
          data: formData);
      return "Upload Status for $fileName ${response.statusCode}";
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Positioned(
                    child: SizedBox(
                  height: 240,
                  width: MediaQuery.of(context).size.width,
                )),
                // ignore: prefer_const_constructors
                CustomScrollView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  // ignore: prefer_const_literals_to_create_immutables
                  slivers: <Widget>[
                    // ignore: prefer_const_constructors
                    SliverAppBar(
                        backgroundColor:
                            const Color.fromARGB(255, 234, 234, 234),
                        floating: true,
                        leading: TextButton(
                          child: const Text(
                            'Back',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                        )),
                    // ignore: prefer_const_constructors
                    SliverAppBar(
                      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
                      floating: true,
                      flexibleSpace: const FlexibleSpaceBar(
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      leading: const Text(''),
                    )
                  ],
                ),
                Positioned(right: 20, top: 80, child: userImg()),
                // Positioned(top: 230, child: formEdit()),
                // Positioned(bottom: 5, child: uploadbtn())
              ],
            ),
            Expanded(child: formEdit()),
            // Expanded(child: )
            uploadbtn(),
            const SizedBox(height: 10)
          ],
        ));
  }

  Widget userImg() {
    return GestureDetector(
      onTap: () async {
        await pickImg();
      },
      child: pickedFile == null
          ? Container(
              // constraints: const BoxConstraints.expand(width: 150, height: 150),
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                // color: const Color(0xff7c94b6),
                image: const DecorationImage(
                  image: AssetImage('assets/images/GigJob.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                border: Border.all(
                  color: const Color.fromARGB(179, 124, 123, 123),
                  width: 4.0,
                ),
              ),
            )
          : Container(
              // constraints: const BoxConstraints.expand(width: 150, height: 150),
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                // color: const Color(0xff7c94b6),
                image: DecorationImage(
                  image: FileImage(File(pickedFile!.path)),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                border: Border.all(
                  color: const Color.fromARGB(179, 124, 123, 123),
                  width: 4.0,
                ),
              ),
            ),
    );
  }

  Widget formEdit() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textForm("name"),
                textForm("address"),
                textForm("education"),
                textForm("address"),
                textForm("address"),
                textForm("address"),
                textForm("address"),
                textForm("education"),
                textForm("address"),
                textForm("address"),
                textForm("address"),
              ],
            ),
          ),
        ));
  }

  Widget textForm(String field) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        controller: _textController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Enter your $field',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $field';
          }
          return null;
        },
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            // The form is valid, do something with the input
            print('User entered: $value');
          }
        },
      ),
    );
  }

  Widget uploadbtn() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: TextButton(
        onPressed: () {
          uploadImage(uploadfile!);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
        child: const Text(
          'Apply',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
