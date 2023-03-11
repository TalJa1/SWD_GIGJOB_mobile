import 'package:flutter/material.dart';
import 'package:gigjob_mobile/view/login_home.dart';
import 'package:gigjob_mobile/view/post_list.dart';
import 'package:gigjob_mobile/view/post_list_detail.dart';
import 'package:gigjob_mobile/view/sign_up.dart';
import 'package:gigjob_mobile/view/user_profile.dart';
import 'package:gigjob_mobile/view/wallet.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";

class RootScreen extends StatefulWidget {
  @override
  _RootScreen createState() => _RootScreen();
}

class _RootScreen extends State<RootScreen> {
  // int _selectedIndex = 0;

  // final List<String> _pageNames = [''];
  // final List<Widget> _screen = [
  //   PostList(),
  //   PostList(),
  //   PostList(),
  //   PostList(),
  //   UserProfile(),
  // ];

  // void _onItemTapped(int index) {
  //   if (index != _selectedIndex) {
  //     setState(() {
  //       _selectedIndex = index;
  //     });
  //     Navigator.pushNamed(context, '/${_pageNames[index]}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    List<Widget> _buildScreens() {
      return [
        PostList(),
        const WalletPage(),
        const UserProfile()
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() => [
          PersistentBottomNavBarItem(
              icon: const Icon(Icons.home),
              title: "Home",
              activeColorPrimary: Colors.black,
              inactiveColorPrimary: Colors.black),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.wallet),
            title: "Wallet",
            activeColorPrimary: Colors.black,
            inactiveColorPrimary: Colors.black,
            // routeAndNavigatorSettings: RouteAndNavigatorSettings(
            //   initialRoute: "/",
            //   routes: {
            //     "/first": (final context) => const MainScreen2(),
            //     "/second": (final context) => const MainScreen3(),
            //   },
            // ),
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.person),
            title: "Profile",
            activeColorPrimary: Colors.black,
            inactiveColorPrimary: Colors.black,
            // routeAndNavigatorSettings: RouteAndNavigatorSettings(
            //   initialRoute: "/",
            //   routes: {
            //     "/first": (final context) => const MainScreen2(),
            //     "/second": (final context) => const MainScreen3(),
            //   },
            // ),
          ),
        ];

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      resizeToAvoidBottomInset: true,
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress:
          true, // Default is true. This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
