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

  List? groupsList = [];
  Map? userData = {};

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
        groupsList = groups;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  loadMentorGroups() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("groups")
        .where("mentors", arrayContains: _auth.currentUser!.uid)
        .get()
        .then((value) {
      final groups = value.docs
          .map((doc) => {
                "id": doc.id,
                "data": doc.data(),
              })
          .toList();

      setState(() {
        groupsList = groups;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  loadUserData() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        userData = value.data();
      });
      userData!["role"] == "student" ? loadGroups() : loadMentorGroups();
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(userData!["role"] == "student" ? "Groups" : "Groups(Mentor)"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : groupsList == null || groupsList!.isEmpty
              ? Center(
                  child: Text("No Groups Found!"),
                )
              : ListView.builder(
                  itemCount: groupsList!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => ChatScreen(
                              groupData: groupsList![index],
                              groupId: groupsList![index]["id"],
                            ),
                          ),
                        );
                      },
                      child: GroupTile(
                        groupData: groupsList![index],
                        userData: userData,
                      ),
                    );
                  }),
    );
  }
}
