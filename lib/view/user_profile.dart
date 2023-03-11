// ignore_for_file: avoid_print, unnecessary_new
import 'package:flutter/material.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:gigjob_mobile/DTO/UserDTO.dart';
import 'package:gigjob_mobile/view/edit_profile.dart';

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
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool isInfo = true;

  final user = new UserDTO("Nguyen Thi Bong Van Hoa", "tt@gmail.com",
      "Obispo Tajon", "0909999999", "Nivel B1", "20/01/2022", [
    Experience("FPT", "Dev", "1 year"),
    Experience("Google", "Manager", "6 months"),
    Experience("HPT", "Master", "2 years"),
    Experience("HPT", "Master", "2 years"),
    Experience("HPT", "Master", "2 years"),
    Experience("HPT", "Master", "2 years"),
  ]);

  Future<void> reload() async {}

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    // ignore: prefer_const_constructors
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  user.name.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
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
        image: const DecorationImage(
          image: AssetImage('assets/images/GigJob.png'),
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
              onTap: () => {
                    setState(() {
                      isInfo = false;
                      print("isInfo $isInfo");
                    })
                  },
              child: const Text('Applied job')),
        ],
      ),
    );
  }

  Widget userData(bool checkIsInfo) {
    // final combinedList = _combineLists();
    return checkIsInfo
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(children: [
                  userInfo("Email", user.email.toString()),
                  userInfo("Address", user.address.toString()),
                  userInfo("Phone", user.phone.toString()),
                  userInfo("Education", user.education.toString()),
                  userInfo("Birth", user.birth.toString())
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
                  itemCount: user.experience!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.experience![index].company.toString(),
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
                                  const Text('Working for:'),
                                  Text(user.experience![index].duration
                                      .toString())
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('At position:'),
                                  Text(user.experience![index].position
                                      .toString())
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
    // ignore: sort_child_properties_last
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
  }

  Widget editBtn() {
    return FloatingActionButton(
      child: const Icon(Icons.edit),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfilePage()),
        );
      },
    );
  }
}
