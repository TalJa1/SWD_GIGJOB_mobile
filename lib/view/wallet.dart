import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        backgroundColor: Colors.white,
        // ignore: avoid_unnecessary_containers
        // ignore: prefer_const_constructors
        body: CustomScrollView(
          // ignore: prefer_const_literals_to_create_immutables
          slivers: <Widget>[
            const SliverAppBar(
              expandedHeight: 100,
              title: Text(
                'data',
                style: TextStyle(color: Colors.black),
              ),
              leading: Text(
                'Back',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            )
          ],
        ));
  }
}
