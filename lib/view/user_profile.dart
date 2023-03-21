// ignore_for_file: avoid_print, unnecessary_new
import 'package:flutter/material.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:get/get.dart';
import 'package:gigjob_mobile/DAO/JobDAO.dart';
import 'package:gigjob_mobile/DTO/UserDTO.dart';
import 'package:gigjob_mobile/DTO/WorkerDTO.dart';
import 'package:gigjob_mobile/enum/view_status.dart';
import 'package:gigjob_mobile/view/edit_profile.dart';
import 'package:gigjob_mobile/viewmodel/job_viewmodel.dart';
import 'package:gigjob_mobile/viewmodel/user_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

// ignore: depend_on_referenced_packages

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    userViewModel = UserViewModel();
    userViewModel.getAppliedJob();
    userViewModel.getUserProfile();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool isInfo = true;

  late UserViewModel userViewModel;

  Future<void> reload() async {
    setState(() {
      
      isInfo = !isInfo;
    });
    userViewModel.getAppliedJob();
    userViewModel.getUserProfile();
  }

  Future<WorkerDTO?> fetchData() async {
    try {
      final WorkerDTO? user = userViewModel.userDTO;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    // ignore: prefer_const_constructors
    return ScopedModel<UserViewModel>(
      model: userViewModel,
      child: ScopedModelDescendant<UserViewModel>(
        builder: (context, child, model) {
          if (userViewModel.status == ViewStatus.Loading) {
            return Center(
              child: Container(
                  width: 100,
                  height: 100,
                  child: const CircularProgressIndicator()),
            );
          } else if (userViewModel.status == ViewStatus.Completed) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: RefreshIndicator(
                onRefresh: reload,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          const SizedBox(
                            height: 370,
                          ),
                          backGround(),
                          // ignore: prefer_const_constructors
                          Positioned(
                              right: 28,
                              top: 40,
                              child: InkWell(
                                onTap: () {
                                  userViewModel.processLogout();
                                },
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              )),
                          Positioned(top: 120, child: profileImage()),
                          // ignore: prefer_const_constructors
                          Positioned(
                              top: 270,
                              child: SizedBox(
                                  // height: 80,
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        if (userViewModel.userDTO!.firstName!
                                                    .toUpperCase() !=
                                                "" &&
                                            userViewModel.userDTO!.lastName!
                                                    .toUpperCase() !=
                                                "") ...[
                                          Text(
                                            "${userViewModel.userDTO!.firstName!.toUpperCase()} ${userViewModel.userDTO!.lastName!.toUpperCase()}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ] else ...[
                                          const Text(
                                            "User",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]
                                        // editBtn()
                                      ],
                                    ),
                                    stateButton()
                                  ],
                                ),
                              ))),
                        ],
                      ),
                      userData(isInfo),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: editBtn(),
            );
          }
          return Container();
        },
      ),
    );
    // return FutureBuilder<UserDTO?>(
    //   future: fetchData(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       // Data has been successfully fetched, display it here

    //     } else if (snapshot.hasError) {
    //       // An error occurred while fetching the data, display an error message
    //       return Text("Error: ${snapshot.error}");
    //     } else {
    //       // Data is still being fetched, display a loading indicator
    //       // ignore: prefer_const_constructors
    //       return Center(
    //         child: const CircularProgressIndicator(),
    //       );
    //     }
    //   },
    // );
  }

  Widget backGround() {
    return Container(
        // constraints: const BoxConstraints.expand(height: 250),
        height: 200,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 45, 45, 45),
        // ignore: prefer_const_constructors
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: const Text(
                'Profile',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            )
          ],
        ));
  }

  Widget profileImage() {
    // ignore: avoid_unnecessary_containers
    return Container(
      // constraints: const BoxConstraints.expand(width: 150, height: 150),
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        image: userViewModel.userDTO!.imageUrl == null ||
                userViewModel.userDTO!.imageUrl!.isEmpty
            ? const DecorationImage(
                image: AssetImage('assets/images/GigJob.png'),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: NetworkImage('${userViewModel.userDTO!.imageUrl}'),
                fit: BoxFit.cover,
              ),
        borderRadius: const BorderRadius.all(Radius.circular(80.0)),
        border: Border.all(
          color: const Color.fromARGB(179, 124, 123, 123),
          width: 4.0,
        ),
      ),
    );
  }

  Widget stateButton() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: AnimatedButtonBar(
        radius: 32.0,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 30),
        backgroundColor: const Color.fromARGB(255, 228, 227, 227),
        foregroundColor: Colors.white,
        borderColor: const Color.fromARGB(255, 228, 227, 227),
        borderWidth: 2,
        children: [
          ButtonBarEntry(
              onTap: () => {
                    setState(() {
                      isInfo = true;
                      print("isInfo $isInfo");
                    })
                  },
              child: const Text('Info')),
          ButtonBarEntry(
              onTap: () async {
                    setState(() {
                      isInfo = false;
                      print("isInfo $isInfo");
                    });
                  },
              child: const Text('Applied job')),
        ],
      ),
    );
  }

  Widget userData(bool checkIsInfo) {
    String? birth = userViewModel.userDTO!.birthday;
    // int firstSpaceIndex = birth!.indexOf("T");
    // String firstWord = birth.substring(0, firstSpaceIndex);
    // String? getBirth = birth?.split(" ");
    return checkIsInfo
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(children: [
                  userInfo("Email", "${userViewModel.userDTO!.email}"),
                  // userInfo("Address", user.address.toString()),
                  // userInfo("Phone", user.phone.toString()),
                  userInfo("Education", "${userViewModel.userDTO!.education}"),
                  userInfo("Birth", birth!),
                  userInfo("Phone", "${userViewModel.userDTO!.phone}"),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      reload();
                    },
                    child: const Text('Reload'),
                  )
                ]),
              ),
            ))
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: userViewModel.appliedjob?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // user.experience![index].company.toString(),
                                "${userViewModel.appliedjob![index].job?.shop?.name}",
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Tittle:'),
                                  Text(
                                      "${userViewModel.appliedjob![index].job?.title}")
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Status:'),
                                  Text(
                                    "${userViewModel.appliedjob![index].status}",
                                    style: const TextStyle(color: Colors.green),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
  }

  Widget userInfo(String tittle, String userdata) {
    if (userdata != "") {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Column(
            children: [
              Title(
                  color: Colors.black,
                  // ignore: prefer_const_constructors
                  child: Text(
                    tittle,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(userdata),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      );
    } else {
      return userInfo(tittle, "No infomation");
    }
  }

  Widget editBtn() {
    return FloatingActionButton(
      child: const Icon(Icons.edit),
      onPressed: () {
        Get.to(const EditProfilePage());
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const EditProfilePage()));
      },
    );
  }
}
