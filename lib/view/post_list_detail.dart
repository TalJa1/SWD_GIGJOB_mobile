// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'dart:ffi';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DAO/AccountDAO.dart';
import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/accesories/dialog.dart';
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

  Future<String> getAccountId() async {
    try {
      String? token = await getToken();
      Map<String, dynamic> decode = Jwt.parseJwt(token!);
      print(decode['account']['id']);
      return decode['account']['id'];
    } catch (e) {
      print(e.toString());
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
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
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          'https://cdn.searchenginejournal.com/wp-content/uploads/2017/06/shutterstock_268688447.jpg',
                          width: 500,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 32, // Image radius
                              backgroundImage: NetworkImage(
                                  'https://cdn.searchenginejournal.com/wp-content/uploads/2017/06/shutterstock_268688447.jpg'),
                            ),
                            Text(
                              "${widget.data.shop?.name}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.data.title}",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  children: [],
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Expanded(
                        child: Text(
                      "Description",
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
                      widget.data.description.toString(),
                      style: TextStyle(fontSize: 16),
                    ))
                  ],
                ),
                _buildTabView(),
                // const SizedBox(
                //   height: 12,
                // ),
                // Text("Job type"),
                // Row(
                //   children: [
                //     Expanded(child: Text(widget.data.description.toString()))
                //   ],
                // )
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildButtonApply());
  }

  Widget _buildTabView() {
    return DefaultTabController(
        length: 4, // length of tabs
        initialIndex: 0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  enableFeedback: true,

                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Job type'),
                    Tab(text: 'Skill'),
                    Tab(text: 'Benifit'),
                    Tab(text: 'Shop info'),
                  ],
                ),
              ),
              Container(
                  height: 200,//height of TabBarView
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5))),
                  child: TabBarView(children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text('${widget.data.jobType?.name}',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text('${widget.data.skill}',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text('${widget.data.benefit}',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Column(children: [
                        Row(
                          children: [
                            Text("Shop Name:", style: TextStyle(fontSize: 16)),
                            Text(" ${widget.data.shop?.name}",
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description:",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Flexible(
                                  child:
                                      Text("${widget.data.shop?.description}"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ]))
            ]));
  }

  Widget _buildButtonApply() {
    return InkWell(
      onTap: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => _buildDialog(context));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                'Apply Now!!!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String accountID = await getAccountId();
            WorkerDTO workerDTO = await JobDAO().getWorkerId(accountID);

            print("Worker id ${workerDTO.id}");
            bool isApply =
                await JobDAO().applyJob(workerDTO.id, widget.data.id!);
            Navigator.pop(context, 'OK');
            if (isApply) {
              showMyDialog(context, "SUCESS", "Apply success");
            } else {
              showMyDialog(context, "FAIL", "Apply fail");
            }
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
