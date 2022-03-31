import 'package:chat_new/screens/chat_screen.dart';
import 'package:chat_new/widgets/group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({Key? key}) : super(key: key);

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  List? userGroups = [];

  void loadGroups() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("groups")
        .where("student_id", isEqualTo: _auth.currentUser!.uid)
        .get()
        .then((value) {
      final groups = value.docs
          .map((doc) => {
                "id": doc.id,
                "data": doc.data(),
              })
          .toList();

      setState(() {
        userGroups = groups;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userGroups == null || userGroups!.isEmpty
              ? Center(
                  child: Text("No Groups Found!"),
                )
              : ListView.builder(
                  itemCount: userGroups!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => ChatScreen(
                              groupData: userGroups![index],
                              groupId: userGroups![index]["id"],
                            ),
                          ),
                        );
                      },
                      child: GroupTile(
                        groupData: userGroups![index],
                      ),
                    );
                  }),
    );
  }
}
