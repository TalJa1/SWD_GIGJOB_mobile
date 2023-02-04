// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ConfirmationCode extends StatefulWidget {
  const ConfirmationCode({Key? key}) : super(key: key);

  @override
  _ConfirmationCodeState createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        // ignore: avoid_unnecessary_containers
        Container(
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              // ignore: prefer_const_constructors
              child: Text('hhlalal')),
        )
      ],
    ));
  }
}
