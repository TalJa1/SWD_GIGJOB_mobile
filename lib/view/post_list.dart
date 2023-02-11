import 'package:flutter/material.dart';
import 'package:gigjob_mobile/view/nav_screen.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<int> arr = [1, 2, 3, 5];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Content",
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
                textInputAction: TextInputAction.search,
                style: TextStyle(fontSize: 16),
                onSubmitted: (value) {
                  // Perform the search action
                },
              ),
              SizedBox(
                height: 32,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: arr.map((e) => _buildPostList(e)).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AppFooter();
        },
      ),
    );
  }

  Widget _buildPostList(int e) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
      child: Column(
        children: [
          Image.asset(
            'assets/images/Test_img.png',
            width: 500,
            height: 240,
            fit: BoxFit.cover,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Text(
                  "Header",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Text(
            "He'll want to use your yacht, and I don't want this thing smelling like fish.",
            style: TextStyle(fontSize: 14),
          ),
          Row(
            children: [
              Text("8m ago",
              style: TextStyle(fontSize: 14),),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildPost(int e) {

  // }
}
