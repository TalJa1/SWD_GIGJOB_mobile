// ignore_for_file: avoid_print, unnecessary_new
import 'package:flutter/material.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
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

  bool isInfo = true;
  var userName = "Tui La Tai";

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          bottomLayer(),
          Container(
            height: 450,
            color: Colors.white,
          ),
          backGround(),
          Positioned(top: 150, child: profileImage()),
          // ignore: prefer_const_constructors
          Positioned(
              // bottom: 0,
              top: 300,
              child: SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            editBtn()
                          ],
                        ),
                        stateButton()
                      ],
                    ),
                  ))),
          Positioned(
              bottom: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 330,
                width: MediaQuery.of(context).size.width,
                // decoration: const BoxDecoration(color: Colors.black),
                // child: userData(isInfo),
              )),
        ],
      ),
    );
  }

  Widget backGround() {
    return Container(
        // constraints: const BoxConstraints.expand(height: 250),
        height: 250,
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
              padding: const EdgeInsets.only(top: 80),
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

  Widget bottomLayer() {
    // bool showFirstPage = false;
    return const SizedBox(height: 900);
  }

  Widget stateButton() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      // constraints: const BoxConstraints.expand(height: 100, width: 420),
      height: 85,
      width: MediaQuery.of(context).size.width,
      child: AnimatedButtonBar(
        radius: 32.0,
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
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
              child: const Text('Experience')),
        ],
      ),
    );
  }

  Widget userData(bool checkIsInfo) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Text('Email '),
        ],
      ),
    ));
  }

  Widget editBtn() {
    return IconButton(
      // ignore: prefer_const_constructors
      icon: Icon(Icons.edit),
      // onPressed: () async {
      //   await pickImg();
      // },
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfilePage()),
        );
      },
    );
  }
}
