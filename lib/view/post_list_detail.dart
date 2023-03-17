// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'dart:ffi';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DAO/AccountDAO.dart';
import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/accesories/dialog.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/utils/share_pref.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:gigjob_mobile/view/start_up.dart';
import 'package:gigjob_mobile/viewmodel/jobDetail_viewmodel.dart';
import 'package:gigjob_mobile/viewmodel/job_viewmodel.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:scoped_model/scoped_model.dart';

class PostListDetail extends StatefulWidget {
  @override
  _PostListDetailState createState() => _PostListDetailState();

  final JobDTO data;
  const PostListDetail({super.key, required this.data});
}

class _PostListDetailState extends State<PostListDetail> {
  late AccountDAO accountDAO;
  bool _showConfirm = false;
  late JobDetailViewModel jobDetailViewModel;

  @override
  void initState() {
    super.initState();
    jobDetailViewModel = JobDetailViewModel();
    jobDetailViewModel.getJobApplied(widget.data.id);
    print(jobDetailViewModel.isApplied);
  }

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

  Future<String?> getWorkerId() async {
    String? accountId = await getAccountID();
    WorkerDTO? workDTO = await JobDAO().getWorkerId(accountId!);
    return workDTO.id;
  }

  // ApplyJobDTO? isApplied() {
  //   List<ApplyJobDTO>? list = jobDetailViewModel.appliedjob;

  //   for (var i = 0; i < list!.length; i++) {
  //     if (list[i].job?.id == widget.data.id) {
  //       return list[i];
  //     }
  //   }
  //   print("nulls");
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<JobDetailViewModel>(
      model: jobDetailViewModel,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Color.fromARGB(255, 45, 45, 45),
          ),
          body: ScopedModelDescendant<JobDetailViewModel>(
            builder: (context, child, model) {
              if (jobDetailViewModel.status == ViewStatus.Completed) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
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
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 32, // Image radius
                                      backgroundImage: NetworkImage(
                                          'https://cdn.searchenginejournal.com/wp-content/uploads/2017/06/shutterstock_268688447.jpg'),
                                    ),
                                    Text(
                                      "${jobDetailViewModel.jobDTO?.shop?.name}",
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
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${widget.data.title}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Expire: ",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          Jiffy("${widget.data.expiredDate}")
                                              .fromNow(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      ],
                                    )
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
                );
              } else if (jobDetailViewModel.status == ViewStatus.Loading) {
                return Center(
                    child: Container(
                        width: 100,
                        height: 100,
                        child: const CircularProgressIndicator()));
              }
              return Container();
            },
          ),
          bottomNavigationBar: _buildButtonApply()),
    );
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
                  height: 200, //height of TabBarView
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
                            Text(
                              " ${widget.data.shop?.name}",
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
    return
    ScopedModelDescendant<JobDetailViewModel>(builder: (context, child, model) {
      if (jobDetailViewModel.status == ViewStatus.Loading) {
      return Container();
    } else if (jobDetailViewModel.status == ViewStatus.Completed) {
      return InkWell(
        onTap: jobDetailViewModel.isApplied == null
            ? () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => _buildDialog(context));
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: jobDetailViewModel.isApplied == null
                    ? Colors.black
                    : Colors.grey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  jobDetailViewModel.isApplied == null
                      ? 'Apply Now!!!'
                      : 'You are applying',
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
    else {
      return Container();
    }
    },);
    
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
              await Get.off(PostListDetail(data: widget.data,));
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
