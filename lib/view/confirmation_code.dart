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
            Center(
              child: const Text('Please enter your',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Center(
              child: const Text('digit code',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 60,
            ),
            // Implement 4 input fields
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOtpInput(_fieldOne, true),
                  _buildOtpInput(_fieldTwo, false),
                  _buildOtpInput(_fieldThree, false),
                  _buildOtpInput(_fieldFour, false)
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
              child: Text(
              'Resend OTP',
              style: TextStyle(color: Colors.blue))
              ),
            const SizedBox(
              height: 30,
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // _otp = _fieldOne.text +
                      //     _fieldTwo.text +
                      //     _fieldThree.text +
                      //     _fieldFour.text;
                    });
                  },
                  child: const Text('Continue')),
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
}
