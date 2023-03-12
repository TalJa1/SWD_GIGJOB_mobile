// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:filter_list/filter_list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gigjob_mobile/view/post_list_detail.dart';
import 'package:gigjob_mobile/viewmodel/job_viewmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jiffy/jiffy.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobViewModel = JobViewModel();
    try {
      jobViewModel.getJobs();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<JobViewModel>(
      model: jobViewModel,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "POST",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 32.0,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black),
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildDialog(context));
                          },
                          icon: const Icon(Icons.filter_list_alt),
                          label: const Text('Filter'),
                        )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                decoration: BoxDecoration(color: Colors.white, ),
                child: TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Search',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(fontSize: 16),
                  onSubmitted: (value) {
                    // Perform the search action
                  },
                ),
              ),
              ScopedModelDescendant<JobViewModel>(
                builder: (context, child, model) {
                  if (jobViewModel.status == ViewStatus.Loading) {
                    return const SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          jobViewModel.getJobs();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: jobViewModel.jobs!
                                .map((e) => _buildPostLists(e))
                                .toList(),
                          ),
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
    return GestureDetector(
      onTap: () {
        Get.to(PostListDetail(data: job));
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
                    Text(
                      "Skill: ${job.skill}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      Jiffy("${job.createdDate}").fromNow(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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
