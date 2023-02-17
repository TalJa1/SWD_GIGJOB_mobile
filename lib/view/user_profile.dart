import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:http/http.dart' as http;

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
  String img = "";
  // Object userInfor = {
  //   "email": "tt@gamail.com",
  //   "education": "asdfa",
  //   "major": "asdfasf",
  //   "age": 12,
  //   "address": "asdasd",
  //   "phone": "012310231",
  // };

  Future<http.Response> createAlbum(String title) {
    return http.post(
      Uri.parse(
          'http://ec2-18-141-146-248.ap-southeast-1.compute.amazonaws.com/swagger-ui/index.html?fbclid=IwAR0KSo01YfEznIuNJon6_RMZwO1XdTxdNXDC-EaFWGukOylCxY_YVRVEaFM#/resource-controller/upload/api/v1/resource/upload'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'file': title,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          // Positioned(
          //     // bottom: 0,
          //     child: Container(
          //   height: 800,
          //   decoration: const BoxDecoration(color: Colors.black),
          // )),
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
                        Text(
                          userName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        stateButton()
                      ],
                    ),
                  ))),
          Positioned(
              bottom: 110,
              child: SizedBox(
                height: 330,
                width: MediaQuery.of(context).size.width,
                // decoration: const BoxDecoration(color: Colors.black),
                // child: userData(isInfo),
              )),
          Positioned(
              bottom: 35,
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      onChanged: (value) {
                        img = value;
                        print(img);
                      },
                    ),
                  ),
                  editBtn(img),
                ],
              ))
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
      height: 88,
      width: 420,
      child: AnimatedButtonBar(
        radius: 32.0,
        padding: const EdgeInsets.all(16.0),
        backgroundColor: const Color.fromARGB(255, 228, 227, 227),
        foregroundColor: Colors.white,
        borderColor: const Color.fromARGB(255, 228, 227, 227),
        borderWidth: 2,
        children: [
          ButtonBarEntry(
              onTap: () => {
                    setState(() {
                      isInfo = true;
                    })
                  },
              child: const Text('Info')),
          ButtonBarEntry(
              onTap: () => {
                    setState(() {
                      isInfo = false;
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

  Widget editBtn(String img) {
    return TextButton(
      onPressed: () {
        createAlbum(img);
      },
      child: const Text('Edit'),
    );
  }
}
