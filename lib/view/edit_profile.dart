// ignore_for_file: avoid_print, sized_box_for_whitespace, unnecessary_new, unused_local_variable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gigjob_mobile/DTO/UserDTO.dart';
import 'package:gigjob_mobile/viewmodel/user_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gigjob_mobile/services/UploadFile_service.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../DAO/JobDAO.dart';
import '../DTO/WorkerDTO.dart';
import '../enum/view_status.dart';
import '../utils/share_pref.dart';

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
    userViewModel = UserViewModel();
    userViewModel.getUserProfile();
  }

  late UserViewModel userViewModel;

  final ImagePicker picker = ImagePicker();
  XFile? uploadfile;
  XFile? pickedFile;

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

  final _formKey = GlobalKey<FormState>();
  // final _textnameController = TextEditingController();
  // final _textdiplomaController = TextEditingController();
  // // final _textbirtdayController = TextEditingController();
  // final _textfirstController = TextEditingController();
  // final _textmidleController = TextEditingController();
  // final _textlastController = TextEditingController();
  // final _textpassController = TextEditingController();
  // final _textphoneController = TextEditingController();

  DateTime? selectedDate;

  Future pickImg() async {
    pickedFile = (await picker.pickImage(source: ImageSource.gallery));
    if (pickedFile != null) {
      setState(() {
        uploadfile = pickedFile;
        print(uploadfile!.path.toString());
      });
    }
    print(uploadfile);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return ScopedModel<UserViewModel>(
        model: userViewModel,
        child: ScopedModel<UserViewModel>(
          model: userViewModel,
          child: ScopedModelDescendant<UserViewModel>(
            builder: (context, child, model) {
              if (userViewModel.status == ViewStatus.Loading) {
                return Center(
                  child: Container(
                      width: 100,
                      height: 100,
                      child: const CircularProgressIndicator()),
                );
              } else if (userViewModel.status == ViewStatus.Completed) {
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
                                backgroundColor:
                                    const Color.fromARGB(255, 234, 234, 234),
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
                        ],
                      ),
                      Expanded(child: formEdit()),
                      // Expanded(child: )
                      const SizedBox(height: 10)
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ));
  }

  Widget userImg() {
    return GestureDetector(
      onTap: () async {
        await pickImg();
      },
      child: pickedFile == null
          ? (userViewModel.userDTO!.imageUrl == null ||
                  userViewModel.userDTO!.imageUrl!.isEmpty)
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
                      image: NetworkImage('${userViewModel.userDTO!.imageUrl}'),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // textForm("email"),
              textForm(),
            ],
          ),
        ));
  }

  Widget textForm() {
    var username = userViewModel.userDTO?.username ?? "";
    var diploma = userViewModel.userDTO?.education ?? "";
    var firstname = userViewModel.userDTO?.firstName ?? "";
    var midlename = userViewModel.userDTO?.middleName ?? "";
    var lastname = userViewModel.userDTO?.lastName ?? "";
    var phone = userViewModel.userDTO?.phone ?? "";
    var pass = userViewModel.userDTO?.password ?? "";
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                // controller: _textnameController,
                initialValue: username,
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
                    setState(() {
                      username = value1;
                    });
                    print('User entered: $value1');
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                // controller: _textdiplomaController,
                initialValue: diploma,
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
                    setState(() {
                      diploma = value2;
                    });
                    // The form is valid, do something with the input
                    print('User entered: $value2');
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                // controller: _textfirstController,
                initialValue: firstname,
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
                    setState(() {
                      firstname = value3;
                    });
                    // The form is valid, do something with the input
                    print('User entered: $value3');
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                // controller: _textmidleController,
                initialValue: midlename,
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
                    setState(() {
                      midlename = value4;
                    });
                    // The form is valid, do something with the input
                    print('User entered: $value4');
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                // controller: _textlastController,
                initialValue: lastname,
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
                    setState(() {
                      lastname = value5;
                    });
                    // The form is valid, do something with the input
                    print('User entered: $value5');
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                // controller: _textphoneController,
                initialValue: phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your phone',
                ),
                validator: _validatePhoneNumber,
                onChanged: (value6) {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      phone = value6;
                    });
                    // The form is valid, do something with the input
                    print('User entered: $value6');
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                // controller: _textpassController,
                initialValue: pass,
                obscureText: true,
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
                    setState(() {
                      pass = value7;
                    });
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
                    child: Column(
                      children: [
                        if (userViewModel.userDTO?.birthday != null &&
                            selectedDate == null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ignore: prefer_const_constructors
                              Text(
                                'Your birthday: ',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "${userViewModel.userDTO?.birthday}",
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          )
                        ],
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
                                DateFormat("yyyy-MM-dd").format(selectedDate!),
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          )
                        ],
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text(
                            'Choose your birthday',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ))),
            const SizedBox(
              height: 10,
            ),
            uploadbtn(_formKey.currentState, firstname, lastname, midlename,
                phone, username, pass, selectedDate.toString(), diploma),
          ],
        ));
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
    // Future<String?> workerid = getWorkerId();
    WorkerDTO dto = new WorkerDTO();
    dto.firstName = first;
    dto.middleName = middle;
    dto.lastName = last;
    dto.phone = phone;
    dto.username = username;
    dto.password = pass;
    dto.birthday = birth;
    dto.education = diploma;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: TextButton(
        onPressed: () async {
          String? accountId = await getAccountID();
          WorkerDTO? workDTO = await JobDAO().getWorkerId(accountId!);
          String? workerID = workDTO.id;
          // UploadFileService().uploadImage(uploadfile!);
          userViewModel.updateUser(dto, workerID!);
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
