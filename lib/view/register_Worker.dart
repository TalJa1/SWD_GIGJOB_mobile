// ignore_for_file: avoid_print, sized_box_for_whitespace, unnecessary_new, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gigjob_mobile/services/UploadFile_service.dart';
import 'dart:math';

class RegisterWorkerPage extends StatefulWidget {
  const RegisterWorkerPage({Key? key}) : super(key: key);

  @override
  _RegisterWorkerPageState createState() => _RegisterWorkerPageState();
}

class _RegisterWorkerPageState extends State<RegisterWorkerPage> {
  @override
  void initState() {
    super.initState();
  }

  final ImagePicker picker = ImagePicker();
  XFile? uploadfile;
  XFile? pickedFile;

  final _formKey = GlobalKey<FormState>();
  final _textnameController = TextEditingController();
  final _textdiplomaController = TextEditingController();
  final _textbirtdayController = TextEditingController();

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
                      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
                      floating: true,
                    ),
                    // ignore: prefer_const_constructors
                    SliverAppBar(
                      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
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

            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: formEdit(),
            )),
            // Expanded(child: )
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
        child: SingleChildScrollView(
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
        ));
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
                labelText: 'Enter your name',
              ),
              validator: (value1) {
                if (value1!.isEmpty) {
                  return 'Please enter your name';
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
              controller: _textbirtdayController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your birthday',
              ),
              validator: (value3) {
                if (value3!.isEmpty) {
                  return 'Please enter your birthday';
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
          Container(
            height: MediaQuery.of(context).size.height / 10,
          ),
          uploadbtn(_formKey.currentState),
        ],
      ),
    );
  }

  Widget uploadbtn(FormState? state) {
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
            onPressed: () {
              if (state!.validate()) {
                UploadFileService().uploadImage(uploadfile!);
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
