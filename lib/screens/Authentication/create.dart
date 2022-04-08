import 'package:chat_new/screens/Authentication/login.dart';
import 'package:chat_new/screens/courses_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './methods.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 10,
                  ),
                  inputField(size, "Name", Icons.account_box, _name),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: inputField(size, "Email", Icons.account_box, _email),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: inputField(size, "Password", Icons.lock, _password),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  customBtn(size),
                  TextButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginScreen())),
                      child: const Text("Login"))
                ],
              ),
            ),
    );
  }

  Widget customBtn(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          CreateAccount(_name.text, _email.text, _password.text).then((user) {
            if (user != null) {
              Fluttertoast.showToast(msg: "Account Created");
              setState(() {
                isLoading = false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => CourseScreen()),
                  (route) => false);
            } else {
              Fluttertoast.showToast(msg: "Login Failed");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          Fluttertoast.showToast(msg: "Plese provide email and password");
        }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: const Text(
          "Create",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }

  Widget inputField(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      width: size.width,
      alignment: Alignment.center,
      child: Container(
        height: size.height / 15,
        width: size.width / 1.1,
        child: TextField(
          controller: cont,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
