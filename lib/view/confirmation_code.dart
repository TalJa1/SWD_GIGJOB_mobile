// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ConfirmationCode extends StatefulWidget {
  

  @override
  _ConfirmationCodeState createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,     
          children: [
            const Text('Enter confirm code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Center(
              child: Text('Please enter your',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Center(
              child: Text('digit code',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 60,
            ),
            // Implement 4 input fields
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOtpInput(_fieldOne, true),
                  _buildOtpInput(_fieldTwo, false),
                  _buildOtpInput(_fieldThree, false),
                  _buildOtpInput(_fieldFour, false),
                  _buildOtpInput(_fieldFive, false),
                  _buildOtpInput(_fieldSix, false),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            InkWell(
              onTap: () {
                // Resend OTP
              },
              child: const Text(
              'Resend OTP',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
                ))
              ),
            const SizedBox(
              height: 30,
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: _buildButtonApply(),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpInput(TextEditingController controller, bool autoFocus) {
    // final TextEditingController controller;
    // final bool autoFocus;

    return Container(
      height: 50,
      width: 50,

      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
    ),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 10.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  Widget _buildButtonApply() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: Text(
            'Apply Now!!!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
