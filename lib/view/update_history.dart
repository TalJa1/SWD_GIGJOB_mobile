// ignore_for_file: avoid_print, sized_box_for_whitespace, unnecessary_new, unused_local_variable, unnecessary_string_interpolations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gigjob_mobile/DTO/HistoryDTO.dart';
import 'package:gigjob_mobile/view/user_profile.dart';

import 'package:gigjob_mobile/viewmodel/user_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../DAO/JobDAO.dart';
import '../DTO/WorkerDTO.dart';
import '../utils/share_pref.dart';

class UpdateHistoryPage extends StatefulWidget {
  // const UpdateHistoryPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateHistoryPageState createState() => _UpdateHistoryPageState();
  final HistoryDTO? userData;

  const UpdateHistoryPage({super.key, required this.userData});
}

class _UpdateHistoryPageState extends State<UpdateHistoryPage> {
  @override
  void initState() {
    super.initState();
    userViewModel = UserViewModel();
  }

  UserViewModel userViewModel = UserViewModel();

  final _formKey = GlobalKey<FormState>();
  // final _textnameController = TextEditingController();

  var position = "";
  late String? sd = widget.userData?.startDate;
  late String? ed = widget.userData?.endDate;
  late DateTime? selectedStart = DateTime.parse(sd!);
  late DateTime? selectedEnd = DateTime.parse(ed!);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return ScopedModel<UserViewModel>(
        model: userViewModel,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      const SizedBox(
                        height: 300,
                      ),
                      backGround(),
                      Positioned(top: 120, child: profileImage()),
                    ],
                  ),
                  formEdit(),
                ],
              ),
            )));
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
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Let's change your history",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                // controller: _textnameController,
                initialValue: widget.userData?.position,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your work position',
                ),
                validator: (value1) {
                  if (value1!.isEmpty) {
                    return 'Please enter your work position';
                  }
                  return null;
                },
                onChanged: (value1) {
                  // The form is valid, do something with the input
                  setState(() {
                    position = value1;
                  });
                  print('User entered: $value1');
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1980, 3, 5),
                          maxTime: DateTime.now(), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        setState(() {
                          selectedStart = date;
                        });
                        print('confirm $date');
                      }, currentTime: selectedStart, locale: LocaleType.en);
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ignore: prefer_const_constructors
                            Text(
                              'Start at: ',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              "${DateFormat("yyyy-MM-dd").format(selectedStart!)}",
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text(
                            'Your startdate',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ))),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1980, 3, 5),
                          maxTime: DateTime.now(), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        if (date.isAfter(selectedStart!)) {
                          setState(() {
                            selectedEnd = date;
                          });
                        } else {
                          setState(() {
                            selectedEnd = selectedStart;
                          });
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Center(
                                    child: Text(
                                      'End date must be after start date',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              });
                        }

                        print('confirm $date');
                      }, currentTime: selectedEnd, locale: LocaleType.en);
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ignore: prefer_const_constructors
                            Text(
                              'End at: ',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              "${DateFormat("yyyy-MM-dd").format(selectedEnd!)}",
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text(
                            'Your enddate',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ))),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    HistoryDTO dto = new HistoryDTO();
                    dto.id = widget.userData?.id;
                    dto.position = position;
                    dto.startDate = selectedStart.toString();
                    dto.endDate = selectedEnd.toString();
                    // String? accountId = await getAccountID();
                    // WorkerDTO? workDTO = await JobDAO().getWorkerId(accountId!);
                    // String? workerID = workDTO.id;
                    await userViewModel.updateHistory(dto);
                    Timer(const Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserProfile()),
                      );
                    });
                  } catch (e) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Center(
                              child: Text('Update failed'),
                            ),
                          );
                        });
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ));
  }

  Widget profileImage() {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
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
    );
  }

  Widget backGround() {
    return Container(
        // constraints: const BoxConstraints.expand(height: 250),
        height: 200,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 59, 51, 51),
        // ignore: prefer_const_constructors
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: const Text(
                'History',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            )
          ],
        ));
  }
}
