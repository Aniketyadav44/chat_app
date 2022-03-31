import 'package:chat_new/screens/Authentication/methods.dart';
import 'package:chat_new/screens/groups_list.dart';
import 'package:chat_new/widgets/course_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  List? courseList = [];

  void loadCourses() async {
    setState(() {
      isLoading = true;
    });
    await _firestore.collection("courses").get().then((value) {
      final courses = value.docs
          .map((doc) => {
                "id": doc.id,
                "data": doc.data(),
              })
          .toList();

      setState(() {
        courseList = courses;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  void createGroup(Map<String, dynamic>? courseDetails) async {
    Map<String, dynamic> groupData = {
      "name": courseDetails!["data"]["name"],
      "icon": courseDetails["data"]["image"],
      "mentors": courseDetails["data"]["mentors"],
      "student_id": _auth.currentUser!.uid,
      "student_name": _auth.currentUser!.displayName,
    };

    Fluttertoast.showToast(msg: "Creating group...");

    await _firestore.collection("groups").add(groupData);

    Fluttertoast.showToast(msg: "Group Created");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              LogOut(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: courseList!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    createGroup(courseList![index]);
                  },
                  child: CourseTile(courseList: courseList![index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => GroupsList(),
            ),
          );
        },
        child: Icon(Icons.group),
      ),
    );
  }
}
