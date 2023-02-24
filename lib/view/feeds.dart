import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<int> arr = [
    1,
    2,
    3,
    5,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
          child: Column(
            children: [
              Stack(
                children: const [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "NOTIFICATION",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 32.0,
                      ),
                    ),
                  ),
                  // Align(
                  //     alignment: Alignment.topRight,
                  //     child: ElevatedButton.icon(
                  //       onPressed: () {
                  //         showDialog<String>(
                  //             context: context,
                  //             builder: (BuildContext context) =>
                  //                 _buildDialog(context));
                  //       },
                  //       icon: const Icon(Icons.filter_list_alt),
                  //       label: const Text('Filter'),
                  //     )),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
                textInputAction: TextInputAction.search,
                style: const TextStyle(fontSize: 16),
                onSubmitted: (value) {
                  // Perform the search action
                },
              ),
              const SizedBox(
                height: 32,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: arr.map((e) => _buildFeed(e)).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeed(int e) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                height: 68,
                width: 68,
                child: const CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                      'https://nguoinoitieng.tv/images/nnt/100/0/beoj.jpg'),
                )),
          ),
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Header",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text("8m ago")
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                          "He'll want to use your yacht, and I don't want this thing smelling like fish."),
                    ),
                    const Divider(
                      thickness: 1,
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
