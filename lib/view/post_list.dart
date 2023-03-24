// ignore_for_file: sized_box_for_whitespace

import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DTO/ApplyJobDTO.dart';
import 'package:gigjob_mobile/DTO/FilterDTO.dart';
import 'package:gigjob_mobile/DTO/JobDTO.dart';
import 'package:gigjob_mobile/accesories/dialog.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/services/locaiton_service.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';
import 'package:filter_list/filter_list.dart';
import 'package:gigjob_mobile/view/post_list_detail.dart';
import 'package:gigjob_mobile/view/start_up.dart';
import 'package:gigjob_mobile/viewmodel/job_viewmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late List<JobType>? selectedItems;
  late List<JobType>? preSelectItems;

  late Location selectLocation;
  late Location preSelectLocation;

  List<Location> listLocation = [
    Location(id: 1, label: 'All location', value: 'allLocation'),
    Location(id: 2, label: 'Near your locaiton', value: 'nearYourLocation')
  ];

  late JobViewModel jobViewModel;
  late LocationService locationService;

  final _searchFocusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();
  
  final ScrollController _scrollController = ScrollController();
  static const _pageSize = 10;
  static int _page = 0;
  bool _isLastPage = false;
  bool backToTop= false;

  Map<String, dynamic> params = {
    "pageIndex": _page,
    "pageSize": _pageSize,
    "searchValue": "",
  };

  void onChangeSort(SortBy sortBy) async {
    sortCriteria.sortKey = sortBy.value;
    sortCriteria.direction = sortBy.isAcs;
    setState(() {
      _page = 0;
      params = {...params, "pageIndex": 0};
      body = FilterDTO(
          searchCriteriaList: searchCriteriaList,
          sortCriteria: sortCriteria,
          dataOption: "any",
          latitude: body.latitude,
          longitude: body.longitude);
    });
    await jobViewModel.getJobs(params: params, body: body.toJson());
  }

  void _onSummitSearch(String searchText) async {
    setState(() {
      _page = 0;
      params = {
        ...params,
        "pageIndex": 0,
        "searchValue": _searchController.text
      };
      // body = FilterDTO(searchCriteriaList: searchCriteriaList, dataOption: "");
    });
    await jobViewModel.getJobs(params: params, body: body.toJson());
  }

  Future checkEnable(Location value) async {
    bool isServiceEnable = await locationService.location.serviceEnabled();
    if (isServiceEnable) {
      return true;
    } else if (value.id == 2) {
      // ignore: use_build_context_synchronously

      // await locationService.enableLocation();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission'),
            content: Text(
                'Background location access is required to use this feature.'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Launch the location settings page

                  // try {
                  //   final result = await launchUrl(Uri.parse(
                  //       'intent:#Intent;action=android.settings.LOCATION_SOURCE_SETTINGS;end'));
                  //   if (!result) {
                  //     // If the settings page cannot be opened, show a snackbar message
                  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //       content: Text('Unable to open location settings'),
                  //     ));
                  //   }
                  // } on PlatformException catch (e) {
                  //   if (e.code == 'ACTIVITY_NOT_FOUND') {
                  //     // Handle the exception gracefully
                  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //       content: Text('Unable to open location settings'),
                  //     ));
                  //   } else {
                  //     // Handle other exceptions
                  //   }
                  // }
                },
                child: Text('I know'),
              ),
            ],
          );
        },
      );
    }
    return false;
  }

  Future<void> filterByCate() async {
    searchCriteriaList = [];
    String dataOperation = "";
    double latitude = locationService.defaultLatitude;
    double longitude = locationService.defaultLongtitude;

    if (preSelectItems!.isNotEmpty) {
      for (var element in preSelectItems!) {
        SearchCriteriaList item = SearchCriteriaList.fromJson({
          "filterKey": "jobType",
          "value": element.id.toString(),
          "operation": "eq",
        });
        searchCriteriaList.add(item);
      }
    }

    if (preSelectLocation.value == 'nearYourLocation') {
      latitude = locationService.locationData.latitude!;
      longitude = locationService.locationData.longitude!;
    }

    // jobViewModel.setSelectFilter(preSelectItems);
    if (searchCriteriaList.length > 1) {
      dataOperation = "any";
    }

    setState(() {
      _searchController.text = "";
      _page = 0;
      params = {
        ...params,
        "pageIndex": 0,
        "searchValue": _searchController.text
      };
      body = FilterDTO(
          searchCriteriaList: searchCriteriaList,
          sortCriteria: sortCriteria,
          dataOption: dataOperation,
          latitude: latitude,
          longitude: longitude);
    });
    await jobViewModel.getJobs(params: params, body: body.toJson());
  }

  late SortBy selectedSort;

  final List<SortBy> itemsSort = [
    SortBy(
        id: 1,
        label: 'Create date new to old',
        value: 'createdDate',
        isAcs: "desc"),
    SortBy(
        id: 2,
        label: 'Create date old to new',
        value: 'createdDate',
        isAcs: "asc"),
  ];

  late FilterDTO body;
  late List<SearchCriteriaList> searchCriteriaList;
  late SortCriteria sortCriteria;

  @override
  void initState() {
    // TODO: implement initState
    jobViewModel = JobViewModel();
    locationService = LocationService();
    locationService.enableLocation();

    selectedSort = itemsSort.first;

    sortCriteria = SortCriteria(
      sortKey: selectedSort.value,
      direction: selectedSort.isAcs,
    );
    searchCriteriaList = [];

    body = FilterDTO(
        searchCriteriaList: searchCriteriaList,
        sortCriteria: sortCriteria,
        dataOption: "",
        latitude: locationService.defaultLatitude,
        longitude: locationService.defaultLongtitude);

    selectedItems = [];
    preSelectItems = [];

    preSelectLocation =
        Location(id: 1, label: 'All location', value: 'allLocation');
    selectLocation = preSelectLocation;

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
      if(_scrollController.position.pixels  != 0) {
          setState(() {
            backToTop = true;
          });
        } 
        else {
          setState(() {
            backToTop = false;
          });
        }
    });

    print("WELCOME");
    super.initState();
  }

  Future<void> _fetchPage(int page) async {
    setState(() {
      params = {...params, "pageIndex": _page, "pageSize": _pageSize};
    });
    await jobViewModel.getJobs(params: params, body: body.toJson());
    final newItems = jobViewModel.jobs;
    // if (newItems != null && newItems.length < _pageSize) {
    //   _isLastPage = true;
    // }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();

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
                  _searchFocusNode.unfocus();

                  // Get.to(StartUpView());
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
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                          // setState(() {
                          //   _showSuggestions = false; // turn off suggestions
                          // });
                        },
                      ),
                      prefixIcon: const Icon(Icons.search),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 4, top: 16),
                          child: InkWell(
                            onTap: () {
                              _searchFocusNode.unfocus();
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
                          padding:
                              const EdgeInsets.only(left: 4, right: 8, top: 16),
                          child: InkWell(
                            onTap: () async {
                              _searchFocusNode.unfocus();

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
            floatingActionButton: _buildBackToTopBtn()
            ),
      ),
    );
  }

  Widget _buildBackToTopBtn() {
    if (!backToTop) {
      return Container();
    }
    return FloatingActionButton(
      child: const Icon(Icons.arrow_upward_outlined),
      onPressed: () {
        _scrollController.jumpTo(0);
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const EditProfilePage()));
      },
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
                      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
    return StatefulBuilder(
      builder: (context, setState) {
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
                  preSelectLocation = selectLocation;
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
                      onTap: () {
                        setState(() {
                          preSelectItems = [];
                          preSelectLocation = Location(
                              id: 1,
                              label: 'All location',
                              value: 'allLocation');
                        });
                      },
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: _buildMultipJobTypeChipSelectCheckBox(),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  // _buildMultipLocationChipSelectCheckBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: _buildSelectLocationDropdown(),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildFilterButton(),
          ),
        );
      },
    );
  }

  Widget _buildMultipJobTypeChipSelectCheckBox() {
    List<JobType> emptyList = [];
    return MultiSelectChipField<JobType?>(
      decoration: const BoxDecoration(
          // border: Border(
          //   bottom: BorderSide(color: Colors.black)
          // ),
          ),
      selectedChipColor: Colors.black,
      selectedTextStyle: const TextStyle(color: Colors.white),
      icon: const Icon(Icons.cancel, color: Colors.white),
      scroll: true,
      headerColor: Colors.white,
      title: const Text(
        "Job type",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      items: jobViewModel.jobTypes == null
          ? emptyList.map((e) => MultiSelectItem(e, e.name ?? '')).toList()
          : jobViewModel.jobTypes!
              .map((e) => MultiSelectItem(e, e.name ?? ''))
              .toList(),
      initialValue: preSelectItems ?? [],
      onTap: (values) {
        setState(() {
          preSelectItems = values.cast<JobType>();
        });
      },
    );
  }

  Widget _buildSelectLocationDropdown() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      'Select Item',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: listLocation
                        .map((item) => DropdownMenuItem<Location>(
                              value: item,
                              child: Text(
                                item.label,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ))
                        .toList(),
                    value: preSelectLocation,
                    onChanged: (value) async {
                      bool isCheckEnable = await checkEnable(value!);
                      if (isCheckEnable) {
                        setState(() {
                          preSelectLocation = value;
                        });
                      }
                    },
                    // buttonStyleData: const ButtonStyleData(
                    //   height: 40,
                    //   width: 140,
                    // ),
                    // menuItemStyleData: const MenuItemStyleData(
                    //   height: 40,
                    // ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
            selectLocation = preSelectLocation;
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
        _searchFocusNode.unfocus();

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
                  height: 168,
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
                    Container(
                      child: Text(
                        "Salary: ${job.salary}",
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
                    _searchFocusNode.unfocus();

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

class Location {
  final int id;
  final String label;
  final String value;

  Location({
    required this.id,
    required this.label,
    required this.value,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          value == other.value;

  @override
  int get hashCode => id.hashCode ^ label.hashCode ^ value.hashCode;
}
