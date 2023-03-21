// ignore_for_file: sized_box_for_whitespace

import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/FilterDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:filter_list/filter_list.dart';
import 'package:gigjob_mobile/view/post_list_detail.dart';
import 'package:gigjob_mobile/view/start_up.dart';
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

   JobType job1 =   JobType(id: 3, name: "Jobtype3");
   JobType job2 =   JobType(id: 3, name: "Jobtype3");
   
  

  late List<JobType>? selectedItems;
  late List<JobType>? preSelectItems;
  // List<JobType> AutoSelectItems = [
  //   JobType(id: 3, name: "Jobtype3"),
  //   JobType(id: 4, name: "Jobtype4"),
  //   JobType(id: 5, name: "Jobtype5"),
  // ];

  late List<JobType> init;

  late JobViewModel jobViewModel;

  final ScrollController _scrollController = ScrollController();
  static const _pageSize = 5;
  static int _page = 0;
  bool _isLastPage = false;

  Map<String, dynamic> params = {
    "pageIndex": _page,
    "pageSize": _pageSize,
    "searchValue": "",
  };

  void onChangeSort(SortBy sortBy) async {
    // SearchCriteriaList? searchCriteriaWithSort = searchCriteriaList.firstWhere(
    //     (element) => element.filterKey == "sortCriteria",
    //     orElse: () => SearchCriteriaList());
    // if (searchCriteriaWithSort.filterKey == "sortCriteria") {
    //   SortCriteria tmpSort =
    //       SortCriteria(sortKey: sortBy.value, direction: sortBy.isAcs);
    //   searchCriteriaWithSort.sortCriteria = tmpSort;
    // }
    sortCriteria.sortKey = sortBy.value;
    sortCriteria.direction = sortBy.isAcs;
    setState(() {
      _page = 0;
      params = {...params, "page": 0};
      body = FilterDTO(searchCriteriaList: searchCriteriaList, sortCriteria: sortCriteria,dataOption: "");
    });
    await jobViewModel.getJobs(params: params, body: body.toJson());
  }

  void _onSummitSearch(String searchText) async {
    // SearchCriteriaList? searchCriteriaWithTitle = searchCriteriaList.firstWhere(
    //     (element) => element.filterKey == "title",
    //     orElse: () => SearchCriteriaList());
    // if (searchCriteriaWithTitle.filterKey == "title") {
    //   searchCriteriaWithTitle.value = searchText;
    // } else if (searchCriteriaWithTitle.filterKey != "title") {
    //   searchCriteriaWithTitle = SearchCriteriaList.fromJson({
    //     "filterKey": "title",
    //     "value": searchText,
    //     "dataOption": "",
    //     "operation": "eq",
    //     "sortCriteria": sortCriteria.toJson()
    //   });
    //   searchCriteriaList.add(searchCriteriaWithTitle);
    // }
    setState(() {
      _page = 0;
      params = {...params, "pageIndex": 0, "searchValue": searchText};
      // body = FilterDTO(searchCriteriaList: searchCriteriaList, dataOption: "");
    });
    await jobViewModel.getJobs(params: params, body: body.toJson());
  }

  Future<void> filterByCate() async {
    searchCriteriaList = [];
    String dataOperation = "";
    for (var element in preSelectItems!) {
      SearchCriteriaList item = SearchCriteriaList.fromJson({
        "filterKey": "jobType",
        "value": element.id.toString(),
        "operation": "eq",
      });
      searchCriteriaList.add(item);
    }
    // jobViewModel.setSelectFilter(preSelectItems);
    if(searchCriteriaList.length > 1){
      dataOperation = "ANY";
    }

    setState(() {
      _page = 0;
      params = {...params, "pageIndex": 0,};
      body = FilterDTO(searchCriteriaList: searchCriteriaList, sortCriteria: sortCriteria,dataOption: dataOperation);
      // init = jobViewModel.selectedFilterJobType;
    });
    await jobViewModel.getJobs(params: params, body: body.toJson());
  }

  late SortBy selectedSort;

  final List<SortBy> itemsSort = [
    SortBy(id: 1, label: 'Create date new to old', value: 'id', isAcs: "desc"),
    SortBy(id: 2, label: 'Create date old to new', value: 'id', isAcs: "asc"),
  ];

  late FilterDTO body;
  late List<SearchCriteriaList> searchCriteriaList;
  late SortCriteria sortCriteria;

  @override
  void initState() {
    // TODO: implement initState
    selectedSort = itemsSort.first;

    sortCriteria = SortCriteria(
      sortKey: selectedSort.value,
      direction: selectedSort.isAcs,
    );
    searchCriteriaList = [];

    body = FilterDTO(searchCriteriaList: searchCriteriaList, sortCriteria: sortCriteria, dataOption: "");

    selectedItems = [];
    preSelectItems = [];
    init = [];

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


    print(job1 == job2);
    super.initState();
  }

  Future<void> _fetchPage(int page) async {
    setState(() {
      params = {...params, "pageIndex": _page, "pageSize": _pageSize};
    });
    await jobViewModel.getJobs(params: params, body: body.toJson());
    final newItems = jobViewModel.jobs;
    if (newItems != null && newItems.length < _pageSize) {
      _isLastPage = true;
    }
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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            toolbarHeight: 100,
            backgroundColor: const Color.fromARGB(255, 45, 45, 45),
            title: GestureDetector(
              onTap: () {
                Get.to(StartUpView());
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
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
          body: ScopedModelDescendant<JobViewModel>(
            builder: (context, child, model) {
              if (jobViewModel.status == ViewStatus.Loading) {
                return Center(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      width: 100,
                      height: 100,
                      child: const CircularProgressIndicator()),
                );
              }
              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 4, top: 16),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return _buiBottomSheetSort();
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 4, right: 8, top: 16),
                            child: InkWell(
                              onTap: () async {
                                await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    builder: (context) {
                                      return _buidBottomSheetFilter();
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
                    ),
                    Expanded(
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
                            if (jobViewModel.status == ViewStatus.LoadMore) ...[
                              const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator())
                            ]
                          ]),
                        ),
                      ),
                    ),
                    // ScopedModelDescendant<JobViewModel>(
                    //   builder: (context, child, model) {
                    //     if (jobViewModel.status == ViewStatus.Loading) {
                    //       return Center(
                    //         child: Container(
                    //             padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    //             width: 100,
                    //             height: 100,
                    //             child: const CircularProgressIndicator()),
                    //       );
                    //     } else {
                    //       return
                    //     }
                    //   },
                    // )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buiBottomSheetSort() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black),
                width: 81,
                height: 4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                const Text(
                  "SORT BY",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: itemsSort.map((item) {
                    return RadioListTile<SortBy>(
                      title: Text(item.label),
                      value: item,
                      activeColor: Colors.black,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      groupValue: selectedSort,
                      onChanged: (value) {
                        setState(() {
                          selectedSort = value!;
                        });
                        onChangeSort(value!);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buidBottomSheetFilter() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
              print(selectedItems);
              preSelectItems = [...selectedItems!];
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
              padding: const EdgeInsets.only(right: 28),
              child: Center(
                child: InkWell(
                  onTap: () {},
                  child: const Text(
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
      ),
    );
  }

  Widget _buildMultipSelectCheckBox() {
    List<JobType> emptyList = [];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: MultiSelectDialogField<JobType>(
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

        items: jobViewModel.jobTypes == null
            ? emptyList.map((e) => MultiSelectItem(e, e.name ?? '')).toList()
            : jobViewModel.jobTypes!
                .map((e) => MultiSelectItem(e, e.name ?? ''))
                .toList(),
                
        initialValue: preSelectItems ?? [],
        
        listType: MultiSelectListType.CHIP,

        chipDisplay: MultiSelectChipDisplay<JobType>(
          icon: const Icon(
            Icons.cancel,
            color: Colors.white,
          ),
          chipColor: Colors.black,
          textStyle: const TextStyle(color: Colors.white),
          scroll: true,
          items: preSelectItems
              ?.map((e) => MultiSelectItem(e, e.name ?? ''))
              .toList(),
          onTap: (value) {
            setState(() {
              preSelectItems?.remove(value);
            });
            return preSelectItems;
          },
        ),

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
        onTap: () async {
          setState(() {
            selectedItems = [
              ...preSelectItems!,
            ];
          });
          await filterByCate();
          // Get.back();
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
                    Get.to(PostListDetail(
                      data: job,
                    ));
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

class SortBy {
  final int id;
  final String label;
  final String value;
  final String isAcs;

  SortBy(
      {required this.id,
      required this.label,
      required this.value,
      required this.isAcs});
}
