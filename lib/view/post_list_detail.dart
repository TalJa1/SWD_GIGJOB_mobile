import 'dart:ffi';

import 'package:flutter/material.dart';

class PostListDetail extends StatefulWidget {
  @override
  _PostListDetailState createState() => _PostListDetailState();
}

class _PostListDetailState extends State<PostListDetail> {
  bool _showConfirm = false;

  void _ontapShowConfirm() {
    setState(() {
      _showConfirm = !_showConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
        child: Column(
          children: [
            Stack(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Image.asset(
              'assets/images/Test_img.png',
              width: 500,
              height: 240,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Expanded(
                    child: Text(
                  "Post Title Here...",
                  style: TextStyle(fontSize: 24.0),
                ))
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                const Expanded(
                    child: Text(
                  "Author",
                  style: TextStyle(fontSize: 16),
                ))
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [const Expanded(child: Text("Description"))],
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildButtonApply()
    );
  }

  Widget _buildButtonApply() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: InkWell(
          onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => _buildDialog(context)
      ),
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
        ),
      );
  }

  Widget _buildDialog(BuildContext context){
    return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Do you want to apply this company?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('Apply'),
            ),
          ],
        );
  }
}
