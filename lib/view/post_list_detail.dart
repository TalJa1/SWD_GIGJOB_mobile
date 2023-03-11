// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gigjob_mobile/DAO/AccountDAO.dart';
import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:jwt_decode/jwt_decode.dart';

class PostListDetail extends StatefulWidget {
  @override
  _PostListDetailState createState() => _PostListDetailState();

  final JobDTO data;

  const PostListDetail({super.key, required this.data});
}

class _PostListDetailState extends State<PostListDetail> {
  late AccountDAO accountDAO;
  bool _showConfirm = false;

  void _ontapShowConfirm() {
    setState(() {
      _showConfirm = !_showConfirm;
    });
  }

  // Future<String>? getUserId() {
  //   try {
  //     Map<String, dynamic> decode = Jwt.parseJwt(getToken().toString());
  //     return decode['id'];
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
          child: Column(
            children: [
              Stack(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ))
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
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Expanded(
                      child: Text(
                    widget.data.title.toString(),
                    style: TextStyle(fontSize: 24.0),
                  ))
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Expanded(
                      child: Text(
                    widget.data.shopId.toString(),
                    style: TextStyle(fontSize: 16),
                  ))
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(child: Text(widget.data.description.toString()))
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: _buildButtonApply());
  }

  Widget _buildButtonApply() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: InkWell(
        onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => _buildDialog(context)),
        child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25),
            ),
            child: GestureDetector(
              onTap: () {
                JobDAO().applyJob("04ef509f-fddf-47c7-bd94-ee89f6038523",
                    widget.data.id!.toInt());
              },
              child: Center(
                child: Text(
                  'Apply Now!!!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildDialog(BuildContext context) {
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
