// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:filter_list/filter_list.dart';
import 'package:gigjob_mobile/view/post_list_detail.dart';
import 'package:gigjob_mobile/viewmodel/job_viewmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<JobType> selectedItems = [];
  List<JobType> preSelectItems = [];

  late JobViewModel jobViewModel;

  final ScrollController _scrollController = ScrollController();
  static const _pageSize = 5;
  static int _page = 0;
  bool _isLastPage = false;

  Map<String, dynamic> params = {
    "pageIndex": _page,
    "pageSize": _pageSize,
  };

  Map<String, dynamic> body = {
    "searchKey": "",
    "filterKey": "jobType",
    "value": "1",
    "operation": "eq",
    "sortCriteria": {"sortKey": "createdDate", "direction": "acs"}
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobViewModel = JobViewModel();
    _fetchPage(_page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Trigger the loading event when the user reaches the end of the scroll view
        if (!_isLastPage) {
          _page++;
          _fetchPage(_page);
        }
      }
    });
  }

  Future<void> _fetchPage(int page) async {
    setState(() {
      params = {...params, "pageIndex": _page, "pageSize": _pageSize};
    });
    await jobViewModel.getJobs(params: params, body: body);
    final newItems = jobViewModel.jobs;
    if (newItems != null && newItems.length < _pageSize) {
      _isLastPage = true;
    }
  }

  void _onSummitSearch(String searchText) async {
    setState(() {
      _page = 0;
      params = {...params, "pageIndex": 0};
      body = {
        ...body,
        "searchKey": searchText,
      };
    });
    print(searchText);
    await jobViewModel.getJobs(params: params, body: body);
  }

  void filterByCate(String? id) async {
    setState(() {
      _page = 0;
      params = {...params, "page": 0};
      body = {
        ...body,
        "searchKey": "",
        "filterKey": "jobType",
        "value": 1,
      };
    });
    print(params);
    await jobViewModel.getJobs(params: params, body: body);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<JobViewModel>(
      model: jobViewModel,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 45, 45, 45),
            title: InkWell(
              onTap: () {
                Get.to(RootScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/GigJob.png'),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Text(
                      'GIG JOB',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.filter_list_alt),
            //     tooltip: 'Show Snackbar',
            //     onPressed: () {
            //       showDialog<String>(
            //           context: context,
            //           builder: (BuildContext context) => _buildDialog(context));
            //     },
            //   ),
            // ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search by title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(Icons.search),
                  ),
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(fontSize: 16.0),
                  onSubmitted: (value) {
                    _onSummitSearch(value);
                  },
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 4, top: 16),
                      child: Container(
                        width: 190,
                        height: 50,
                        child: Card(
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.sort),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Sort",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 4, right: 8, top: 16),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return _buidBottomSheet();
                              });
                        },
                        child: Container(
                          width: 190,
                          height: 50,
                          child: Card(
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.filter_alt_sharp),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Filter",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ScopedModelDescendant<JobViewModel>(
                  builder: (context, child, model) {
                    if (jobViewModel.status == ViewStatus.Loading) {
                      return Center(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            width: 100,
                            height: 100,
                            child: const CircularProgressIndicator()),
                      );
                    } else {
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              _page = 0;
                            });
                            _fetchPage(0);
                          },
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(children: [
                              ...jobViewModel.jobs!
                                  .map((e) => _buildPostLists(e))
                                  .toList(),
                              if (jobViewModel.status ==
                                  ViewStatus.LoadMore) ...[
                                const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator())
                              ]
                            ]),
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buidBottomSheet() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            print(selectedItems);
            preSelectItems = [...selectedItems];
          },
        ),
        foregroundColor: Colors.black,
        title: const Text(
          "Filter",
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 28),
            child: Center(
              child: InkWell(
                onTap: () {},
                child: Text(
                  "Reset",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildMultipSelectCheckBox(),
            const Divider(
              thickness: 1,
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildFilterButton(),
    );
  }

  Widget _buildMultipSelectCheckBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: MultiSelectDialogField(
        decoration: const BoxDecoration(
          border: null,
        ),

        buttonIcon: const Icon(Icons.arrow_forward_ios),
        selectedColor: Colors.black,

        selectedItemsTextStyle: const TextStyle(color: Colors.white),
        searchTextStyle: const TextStyle(color: Colors.white),

        // dialogHeight: MediaQuery.of(context).size.height,
        searchable: true,
        title: const Text("Job type"),
        buttonText: const Text(
          "Job type",
          style: TextStyle(fontSize: 18),
        ),
        initialValue: preSelectItems,

        items: jobViewModel.jobTypes!
            .map((e) => MultiSelectItem(e, e.name ?? ''))
            .toList(),
        listType: MultiSelectListType.CHIP,

        //
        // chipDisplay: MultiSelectChipDisplay(
        //   items: preSelectItems.map((e) => MultiSelectItem(e, e.name ?? '')).toList(),
        //   onTap: (value) {
        //     setState(() {
        //       preSelectItems.remove(value);
        //     });
        //   },
        // ),
        //
        onConfirm: (values) {
          setState(() {
            preSelectItems = values;
          });
        },
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          filterByCate;
          selectedItems = [
            ...preSelectItems,
          ];
          Navigator.pop(context);
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
              child: const Center(
                child: Text(
                  'Show',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildPostLists(JobDTO job) {
    ApplyJobDTO? isApplied() {
      List<ApplyJobDTO>? list = jobViewModel.appliedjob;

      for (var i = 0; i < list!.length; i++) {
        if (list[i].job?.id == job.id) {
          return list[i];
        }
      }
      print("nulls");
      return null;
    }

    return GestureDetector(
      onTap: () {
        Get.to(PostListDetail(
          data: job,
          appliedJob: jobViewModel.appliedjob,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.network(
                  "https://cdn.searchenginejournal.com/wp-content/uploads/2017/06/shutterstock_268688447.jpg",
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "${job.title}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 64,
                      constraints: new BoxConstraints(maxHeight: 64),
                      child: Text(
                        "Skill: ${job.skill}",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "Created: ",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          Jiffy("${job.createdDate}").fromNow(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostList(JobDTO job) {
    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(PostListDetail(data: job));
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Test_img.png',
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Text(
                              "${job.title}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 8),
                              child: Text(
                                "${job.description}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            child: const CircleAvatar(),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            Jiffy("${job.createdDate}").fromNow(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // Widget _buildPost(int e) {

  // }
}
