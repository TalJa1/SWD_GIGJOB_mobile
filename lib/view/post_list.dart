// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:filter_list/filter_list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gigjob_mobile/view/post_list_detail.dart';
import 'package:gigjob_mobile/viewmodel/job_viewmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<int> arr = [1, 2, 3, 5];

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  List<String> selectedItems = [];

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
        "filterKey": "jobType",
        "value": "1",
        "operation": "eq",
        "sortCriteria": {"sortKey": "createdDate", "direction": "acs"}
      };
    });
    print(searchText);
    await jobViewModel.getJobs(params: params, body: body);
  }

  void filterByCate(String? id) async {
    setState(() {
      _page = 1;
      params = {...params, "page": "1", "category_id": id.toString()};
    });
    print(params);
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
            backgroundColor: Color.fromARGB(255, 45, 45, 45),
            title: InkWell(
              onTap: () {
                Get.to(RootScreen());
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/GigJob.png'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: const Text(
                      'GIG JOB',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list_alt),
                tooltip: 'Show Snackbar',
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => _buildDialog(context));
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search by title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.search),
                  ),
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 16.0),
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
                ScopedModelDescendant<JobViewModel>(
                  builder: (context, child, model) {
                    if (jobViewModel.status == ViewStatus.Loading) {
                      return Center(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator()),
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
          // bottomNavigationBar: StatefulBuilder(
          //   builder: (BuildContext context, StateSetter setState) {
          //     return AppFooter();
          //   },
          // ),
        ),
      ),
    );
  }

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter'),
      content: _buildListSelectCheckBox(),
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

  Widget _buildListSelectCheckBox() {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMultipSelectCheckBox(),
          _buildMultipSelectCheckBox(),
          _buildMultipSelectCheckBox(),
        ],
      ),
    );
  }

  Widget _buildMultipSelectCheckBox() {
    return DropdownButtonHideUnderline(
      child: Container(
        width: 250,
        child: DropdownButton2(
          buttonDecoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(32),
          ),
          isExpanded: true,
          hint: Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              'Select',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              //disable default onTap to avoid closing menu when selecting an item
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final _isSelected = selectedItems.contains(item);
                  return InkWell(
                    onTap: () {
                      _isSelected
                          ? selectedItems.remove(item)
                          : selectedItems.add(item);
                      //This rebuilds the StatefulWidget to update the button's text
                      setState(() {});
                      //This rebuilds the dropdownMenu Widget to update the check mark
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          _isSelected
                              ? const Icon(Icons.check_box_outlined)
                              : const Icon(Icons.check_box_outline_blank),
                          const SizedBox(width: 16),
                          Text(
                            item,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
          value: selectedItems.isEmpty ? null : selectedItems.last,
          onChanged: (value) {},
          buttonHeight: 40,
          buttonWidth: 140,
          itemHeight: 40,
          itemPadding: EdgeInsets.zero,
          selectedItemBuilder: (context) {
            return items.map(
              (item) {
                return Container(
                  alignment: AlignmentDirectional.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    selectedItems.join(', '),
                    style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },
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
                borderRadius: BorderRadius.only(
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
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      "${job.title}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 8),
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
                    SizedBox(height: 8),
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
                          style: TextStyle(
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
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Text(
                              "${job.title}",
                              style: TextStyle(fontSize: 16),
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
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            child: CircleAvatar(),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            Jiffy("${job.createdDate}").fromNow(),
                            style: TextStyle(fontSize: 14),
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
