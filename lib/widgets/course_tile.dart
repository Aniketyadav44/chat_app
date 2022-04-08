import 'package:flutter/material.dart';

class CourseTile extends StatelessWidget {
  Map<String, dynamic>? courseList;

  CourseTile({this.courseList});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: width * 0.5,
          padding: const EdgeInsets.all(10),
          child: Text(
            courseList!["data"]["name"],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
