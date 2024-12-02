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
          MaterialPageRoute(builder: (context) => const HomePage()),
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
                        "Welcome Back",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
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
                        height: 40,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: () {},
                            height: 50,
                            // margin: EdgeInsets.symmetric(horizontal: 50),
                            color: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            // decoration: BoxDecoration(
                            // ),
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
                        height: 50,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: Text(
                            "Already have an acocunt?",
                            style: TextStyle(color: Colors.grey),
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: () {},
                            height: 50,
                            // margin: EdgeInsets.symmetric(horizontal: 50),
                            color: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            // decoration: BoxDecoration(
                            // ),
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  // Widget build(BuildContext context)
  // {
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           // Header Container
  //           Container(
  //             height: 250,
  //             decoration: const BoxDecoration(
  //               borderRadius: BorderRadius.only(
  //                 bottomLeft: Radius.circular(90),
  //               ),
  //               color: Color(0xff2196F3),
  //               gradient: LinearGradient(
  //                 colors: [
  //                   Color(0xff2196F3), // Blue shade
  //                   Color(0xff42A5F5), // Lighter blue
  //                   Color(0xffBBDEFB), // Very light blue
  //                 ],
  //                 begin: Alignment.topCenter,
  //                 end: Alignment.bottomCenter,
  //               ),
  //             ),
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   SizedBox(
  //                     height: 120,
  //                     width: 120,
  //                     child: Image.asset("assets/app_logo.png"),
  //                   ),
  //                   Container(
  //                     alignment: Alignment.center,
  //                     child: const Text(
  //                       "Login",
  //                       style: TextStyle(fontSize: 20, color: Colors.white),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           // Email Text Field
  //           Container(
  //             margin: const EdgeInsets.only(left: 20, right: 20, top: 70),
  //             padding: const EdgeInsets.only(left: 20, right: 20),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(50),
  //               color: Colors.grey[200],
  //               boxShadow: const [
  //                 BoxShadow(
  //                     offset: Offset(0, 10),
  //                     blurRadius: 50,
  //                     color: Color(0x0ffeeeee)),
  //               ],
  //             ),
  //             alignment: Alignment.center,
  //             child: TextField(
  //               controller: emailController,
  //               obscureText: false,
  //               cursorColor: const Color(0xff2196F3),
  //               decoration: const InputDecoration(
  //                 icon: Icon(
  //                   Icons.email,
  //                   color: Color(0xff2196F3),
  //                 ),
  //                 hintText: "Enter your email",
  //                 enabledBorder: InputBorder.none,
  //                 focusedBorder: InputBorder.none,
  //               ),
  //             ),
  //           ),
  //           // Password Text Field
  //           Container(
  //             margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
  //             padding: const EdgeInsets.only(left: 20, right: 20),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(50),
  //               color: Colors.grey[200],
  //               boxShadow: const [
  //                 BoxShadow(
  //                     offset: Offset(0, 10),
  //                     blurRadius: 50,
  //                     color: Color(0x0ffeeeee)),
  //               ],
  //             ),
  //             alignment: Alignment.center,
  //             child: TextField(
  //               controller: passwordController,
  //               obscureText: true,
  //               cursorColor: const Color(0xff2196F3),
  //               decoration: const InputDecoration(
  //                 icon: Icon(
  //                   Icons.vpn_key,
  //                   color: Color(0xff2196F3),
  //                 ),
  //                 hintText: "Enter your password",
  //                 enabledBorder: InputBorder.none,
  //                 focusedBorder: InputBorder.none,
  //               ),
  //             ),
  //           ),

  //           const SizedBox(height: 30),

  //           GestureDetector(
  //             child: GFButton(
  //               onPressed: loginUser,
  //               text: "LOGIN",
  //               blockButton: true,
  //               size: GFSize.LARGE,
  //             ),
  //           ),

  //           // Register Link
  //           Container(
  //             margin: const EdgeInsets.only(top: 20, left: 90),
  //             child: Row(
  //               children: [
  //                 const Text("Don't have account?"),
  //                 GestureDetector(
  //                   onTap: () => {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => const RegisterScreen()),
  //                     ),
  //                   },
  //                   child: const Text(
  //                     " Register Now",
  //                     style: TextStyle(color: Color(0xff2196F3)),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
