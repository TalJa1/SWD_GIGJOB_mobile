import 'package:flutter/material.dart';

import 'package:get/get.dart';

Future<void> showMyDialog(BuildContext context, String status, String content) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button to dismiss dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(status),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}