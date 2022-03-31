import 'package:chat_new/screens/courses_list.dart';
import 'package:chat_new/screens/Authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return CourseScreen();
    } else {
      return LoginScreen();
    }
  }
}
