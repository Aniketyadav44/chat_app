import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_new/screens/Authentication/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<User?> CreateAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    userCredential.user!.updateDisplayName(name);
    await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
      "name": name,
      "email": email,
      "uid": _auth.currentUser!.uid,
      "role": "student"
    });
    return userCredential.user;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<User?> Login(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      Fluttertoast.showToast(msg: "Login successful");
      return user;
    } else {
      Fluttertoast.showToast(msg: "Login Failed");
      return user;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future? LogOut(BuildContext context) {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
    Fluttertoast.showToast(msg: "Logged out");
  } catch (e) {
    print(e.toString());
    return null;
  }
}
