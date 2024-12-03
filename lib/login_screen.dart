import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';
import 'package:animate_do/animate_do.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<LoginScreen> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final email = emailController.text;
    final password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://10.0.2.2/flutter_project_hayleys/lib/login.php'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        // Navigate to HomePage if login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Show error message if login fails
        _showErrorDialog(jsonResponse['message']);
      }
    } else {
      // Show server error if the request fails
      _showErrorDialog('Server error. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blue.shade900,
          Colors.blue.shade800,
          Colors.blue.shade400
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Welcome Back to Fentons Medical Bill Claim System",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60))),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(27, 86, 225, 0.298),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: "Phone number",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );
                            },
                            height: 50,
                            color: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1500),
                        child: Text(
                          "New to the system?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: MaterialButton(
                          onPressed: () {
                            // Navigate to the RegisterScreen when the button is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          height: 50,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(
                              color: Colors.blue[900]!,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color:
                                    Colors.blue[900], // Set text color to blue
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
