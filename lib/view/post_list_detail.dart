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
import 'package:intl/intl.dart';
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                                  height: 180,
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
                                    Text(
                                      "${jobDetailViewModel.jobDTO?.shop?.name}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    CircleAvatar(
                                      radius: 32, // Image radius
                                      backgroundImage: NetworkImage(
                                          'https://cdn.searchenginejournal.com/wp-content/uploads/2017/06/shutterstock_268688447.jpg'),
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
                                    Flexible(
                                      child: Text(
                                        "${jobDetailViewModel.jobDTO!.title}",
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    jobDetailViewModel.jobDTO!.expiredDate == null
                                        ? Container()
                                        : Row(
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
                                                DateFormat("yyyy-MM-dd").format(
                                                    DateTime.parse(widget
                                                        .data.expiredDate!)),
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
                          children: const [],
                        ),
                        Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Expanded(
                                child: Text(
                              "Description:",
                              style: TextStyle(fontSize: 24.0),
                            )),
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
                              jobDetailViewModel.jobDTO!.description.toString(),
                              style: TextStyle(fontSize: 16),
                            ))
                          ],
                        ),
                        _buildTabView(),
                        Column(
                          children: const [
                            Text(
                              "Relate",
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ],
                        ),
                        _buildRelateJobList()

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

  Widget _buildRelateJobList(){
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if(jobDetailViewModel.relateJobs != null && jobDetailViewModel.relateJobs!.isNotEmpty)
            ...jobDetailViewModel.relateJobs!.map((e) => _buildRelateJob(e)).toList()
            else
            ...[
              Center(child: Text("No relate job"))
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildRelateJob(JobDTO job){
    return InkWell(
      onTap: () async {
          await jobDetailViewModel.getJobApplied(job.id);

        // setState(() async {
        // });
        // Get.to(PostListDetail(data: job));
      },
      child: Container(
        child: Card(
            // color: Color(0xFFf7418c),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Container(
              // padding: const EdgeInsets.all(8.0),
              width: 200,
              child: Column(
                children: [
                  Image.network(
                    "https://cdn.searchenginejournal.com/wp-content/uploads/2017/06/shutterstock_268688447.jpg",
                    width: 300,
                    height: 140,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${job.title}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildTabView() {
    return DefaultTabController(
        length: 5, // length of tabs
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
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Job type'),
                    Tab(text: 'Skill'),
                    Tab(text: 'Salary'),
                    Tab(text: 'Benifit'),
                    Tab(text: 'Shop info'),
                  ],
                ),
              ),
              Container(
                
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ), //height of TabBarView
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5))),
                  child: TabBarView(children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text('${jobDetailViewModel.jobDTO!.jobType?.name}',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text('${jobDetailViewModel.jobDTO!.skill}',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text('${jobDetailViewModel.jobDTO!.salary}\$',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text('${jobDetailViewModel.jobDTO!.benefit}',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Column(children: [
                        Row(
                          children: [
                            Text("Shop Name:", style: TextStyle(fontSize: 16)),
                            Text(
                              " ${jobDetailViewModel.jobDTO!.shop?.name}",
                              style: TextStyle(fontSize: 16,
                              color: Colors.blue),
                              
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
                                      Text("${jobDetailViewModel.jobDTO!.shop?.description}",
                                      maxLines: 10,),
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
    return ScopedModelDescendant<JobDetailViewModel>(
      builder: (context, child, model) {
        if (jobDetailViewModel.status == ViewStatus.Loading) {
          return Container();
        } else if (jobDetailViewModel.status == ViewStatus.Completed) {
          return InkWell(
            onTap: jobDetailViewModel.isApplied == null
                ? () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildDialog(context));
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
        } else {
          return Container();
        }
      },
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
            bool isApply = await jobDetailViewModel
                .applyJob(jobDetailViewModel.jobDTO!.id);

            Navigator.pop(context, 'OK');
            if (isApply) {
              showMyDialog(context, "SUCESS", "Apply success");
            } else {
              showMyDialog(context, "FAIL", "Apply fail");
            }
            setState(() {
              jobDetailViewModel.getJobApplied(jobDetailViewModel.jobDTO?.id);
            });
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
