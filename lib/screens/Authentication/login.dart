import 'package:chat_new/screens/courses_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './create.dart';
import './methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 10,
                  ),
                  inputField(size, "Email", Icons.account_box, _email),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: inputField(size, "Password", Icons.lock, _password),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  customBtn(size),
                  TextButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CreateScreen())),
                      child: Text("Create Account"))
                ],
              ),
            ),
    );
  }

  Widget customBtn(Size size) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          Login(_email.text, _password.text).then((user) {
            if (user != null) {
              Fluttertoast.showToast(msg: "Login Successful");
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
        child: Text(
          "Login",
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
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
