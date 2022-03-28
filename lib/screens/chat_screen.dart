import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final groupData;
  String? groupId;

  ChatScreen({this.groupData, this.groupId});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Container(
          padding: EdgeInsets.only(left: 0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_back),
                  )),
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(groupData!["data"]["icon"]),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.52,
                          child: Text(
                            groupData!["data"]["name"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Text("Chat screen"),
    );
  }
}
