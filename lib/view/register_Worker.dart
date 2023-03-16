// ignore_for_file: avoid_print, sized_box_for_whitespace, unnecessary_new, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/viewmodel/register_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gigjob_mobile/services/UploadFile_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:math';

import 'package:intl/intl.dart';

class RegisterWorkerPage extends StatefulWidget {
  const RegisterWorkerPage({Key? key}) : super(key: key);

  @override
  _RegisterWorkerPageState createState() => _RegisterWorkerPageState();
}

class _RegisterWorkerPageState extends State<RegisterWorkerPage> {
  @override
  void initState() {
    super.initState();
    registerViewModel = RegisterViewModel();
  }

  late RegisterViewModel registerViewModel;

  final ImagePicker picker = ImagePicker();
  XFile? uploadfile;
  XFile? pickedFile;

  final _formKey = GlobalKey<FormState>();
  final _textnameController = TextEditingController();
  final _textdiplomaController = TextEditingController();
  final _textbirtdayController = TextEditingController();
  final _textfirstController = TextEditingController();
  final _textmidleController = TextEditingController();
  final _textlastController = TextEditingController();
  final _textpassController = TextEditingController();
  final _textphoneController = TextEditingController();

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

  String? _validatePhoneNumber(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
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
                      ),
                      // ignore: prefer_const_constructors
                      SliverAppBar(
                        backgroundColor:
                            const Color.fromARGB(255, 234, 234, 234),
                        floating: true,
                        flexibleSpace: const FlexibleSpaceBar(
                          title: Text(
                            '',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(right: 20, top: 80, child: userImg()),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: formEdit(),
              ),
              // Expanded(child: )
            ],
          ),
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
                  image: AssetImage('assets/images/click-2339189_960_720.png'),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Welcome to GIGJOB',
            style: TextStyle(
              fontWeight: FontWeight.bold, // to make text bold
              fontSize: 24, // to set font size
            ),
            textAlign: TextAlign.center, // to center the text
          ),
          const SizedBox(
            height: 20,
          ),
          textForm(),
        ],
      ),
    );
  }

  Widget textForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextFormField(
              controller: _textnameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your username',
              ),
              validator: (value1) {
                if (value1!.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              onChanged: (value1) {
                if (_formKey.currentState!.validate()) {
                  // The form is valid, do something with the input
                  print('User entered: $value1');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextFormField(
              controller: _textdiplomaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your diploma',
              ),
              validator: (value2) {
                if (value2!.isEmpty) {
                  return 'Please enter your diploma';
                }
                return null;
              },
              onChanged: (value2) {
                if (_formKey.currentState!.validate()) {
                  // The form is valid, do something with the input
                  print('User entered: $value2');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextFormField(
              controller: _textfirstController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your firstname',
              ),
              validator: (value3) {
                if (value3!.isEmpty) {
                  return 'Please enter your firstname';
                }
                return null;
              },
              onChanged: (value3) {
                if (_formKey.currentState!.validate()) {
                  // The form is valid, do something with the input
                  print('User entered: $value3');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextFormField(
              controller: _textmidleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your midlename',
              ),
              validator: (value4) {
                if (value4!.isEmpty) {
                  return 'Please enter your midlename';
                }
                return null;
              },
              onChanged: (value4) {
                if (_formKey.currentState!.validate()) {
                  // The form is valid, do something with the input
                  print('User entered: $value4');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextFormField(
              controller: _textlastController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your lastname',
              ),
              validator: (value5) {
                if (value5!.isEmpty) {
                  return 'Please enter your lastname';
                }
                return null;
              },
              onChanged: (value5) {
                if (_formKey.currentState!.validate()) {
                  // The form is valid, do something with the input
                  print('User entered: $value5');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextFormField(
              controller: _textphoneController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your phone',
              ),
              validator: _validatePhoneNumber,
              onChanged: (value6) {
                if (_formKey.currentState!.validate()) {
                  // The form is valid, do something with the input
                  print('User entered: $value6');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextFormField(
              controller: _textpassController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your password',
              ),
              validator: (value7) {
                if (value7!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onChanged: (value7) {
                if (_formKey.currentState!.validate()) {
                  // The form is valid, do something with the input
                  print('User entered: $value7');
                }
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1990, 3, 5),
                        maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                      print('confirm $date');
                    }, currentTime: DateTime.now(), locale: LocaleType.es);
                  },
                  child: Container(
                    child: Column(
                      children: [
                        if (selectedDate != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ignore: prefer_const_constructors
                              Text(
                                'Your birthday: ',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                '$selectedDate',
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          )
                        ],
                        const Text(
                          'Choose your birthday',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ))),
          const SizedBox(
            height: 10,
          ),
          uploadbtn(
              _formKey.currentState,
              _textfirstController.text,
              _textlastController.text,
              _textmidleController.text,
              _textphoneController.text,
              _textnameController.text,
              _textpassController.text,
              selectedDate.toString(),
              _textdiplomaController.text),
        ],
      ),
    );
  }

  Widget uploadbtn(
      FormState? state,
      String first,
      String last,
      String middle,
      String phone,
      String username,
      String pass,
      String birth,
      String diploma) {
    WorkerDTO dto = new WorkerDTO();
    dto.firstName = first;
    dto.middleName = middle;
    dto.lastName = last;
    dto.phone = phone;
    dto.username = username;
    dto.password = pass;
    dto.birthday = birth;
    dto.education = diploma;
    return Column(
      children: [
        const Text(
          "DON'T FORGET TO SET YOUR PROFILE'S IMAGE",
          style: TextStyle(
            fontSize: 12, // adjust font size as needed
            color: Colors.red, // set text color
            fontWeight: FontWeight.bold, // make the text bold
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: TextButton(
            onPressed: () async {
              if (state!.validate()) {
                // UploadFileService().uploadImage(uploadfile!);
                await registerViewModel.registerWorker(dto);
              } else {}
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
        )
      ],
    );
  }
}
