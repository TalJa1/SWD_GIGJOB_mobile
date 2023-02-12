import 'package:flutter/material.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/view/post_list.dart';
import 'package:gigjob_mobile/view/sign_up.dart';

class AppFooter extends StatefulWidget {
  @override
  _AppFooter createState() => _AppFooter();
}

class _AppFooter extends State<AppFooter> {
  int _selectedIndex = 0;

  final List<String> _pageNames = [''];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pushNamed(context, '/${_pageNames[index]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_filled,
            color: Colors.black,
          ),

          // Image.asset(
          //             'assets/images/HomeIcon.png',
          //           ),
          label: "",
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            // Image.asset(
            //             'assets/images/BellIcon.png',
            //           ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            // Image.asset(
            //             'assets/images/BellIcon.png',
            //           ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.wallet,
              color: Colors.black,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: ""),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
