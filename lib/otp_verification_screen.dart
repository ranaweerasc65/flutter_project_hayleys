// this is the phone number verification dart file
// check whether
// 1. enter a correct format phone number
// 2. check that the phone number exsits in the database

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project_hayleys/otp.dart';
import 'package:animate_do/animate_do.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> registerUser() async {
    String phoneNo = _phonenoController.text.trim();

    print("Phone No: $phoneNo");

    if (phoneNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the phone number.')),
      );
      return;
    }

    // Check if the phone number starts with '0' and has exactly 10 digits
    if (!RegExp(r"^0\d{9}$").hasMatch(phoneNo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://172.16.200.79/flutter_project_hayleys/php/otp.php'),
        body: {
          'phoneno': _phonenoController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        debugPrint(response.body);
        if (result['status'] == 'exists') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else if (result['status'] == 'not_exists') {
          String userId = result['user_id'].toString();
          //String contact = result['phoneno'].toString();

          print("User ID: $userId");
          //print("Contact: $phoneNo");

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Otp(
                      key: UniqueKey(),
                      userId: userId,
                      phoneNo: phoneNo,
                    )),
          );
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Error processing the request'))

          // );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to the server')),
        );
        debugPrint(response.statusCode.toString());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception: $e')),
      );
      debugPrint('Exception: $e');
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     resizeToAvoidBottomInset: true,
  //     body: Container(
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //           gradient: LinearGradient(begin: Alignment.topCenter, colors: [
  //         Colors.blue.shade900,
  //         Colors.blue.shade800,
  //         Colors.blue.shade400
  //       ])),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           const SizedBox(height: 80),
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 FadeInUp(
  //                   duration: const Duration(milliseconds: 1000),
  //                   child: const Text(
  //                     "Phone Number Verification",
  //                     style: TextStyle(color: Colors.white, fontSize: 40),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 FadeInUp(
  //                   duration: const Duration(milliseconds: 1300),
  //                   child: const Text(
  //                     // "Welcome to Fentons Medical Bill Claim System",
  //                     "We will send you an One Time Password for the entered mobile number for the registration.",
  //                     style: TextStyle(color: Colors.white, fontSize: 18),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           Expanded(
  //             child: SingleChildScrollView(
  //               physics: const AlwaysScrollableScrollPhysics(),
  //               child: Container(
  //                 decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(60),
  //                         topRight: Radius.circular(60),
  //                         bottomLeft: Radius.circular(60),
  //                         bottomRight: Radius.circular(60))),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(30),
  //                   child: Column(
  //                     children: <Widget>[
  //                       const SizedBox(height: 60),
  //                       FadeInUp(
  //                         duration: const Duration(milliseconds: 1400),
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(10),
  //                             boxShadow: const [
  //                               BoxShadow(
  //                                 color: Color.fromRGBO(27, 86, 225, 0.298),
  //                                 blurRadius: 20,
  //                                 offset: Offset(0, 10),
  //                               ),
  //                             ],
  //                           ),
  //                           child: Column(
  //                             children: <Widget>[
  //                               buildTextField("Phone Number"),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 20),
  //                       FadeInUp(
  //                         duration: const Duration(milliseconds: 1600),
  //                         child: MaterialButton(
  //                           onPressed: () {
  //                             registerUser();
  //                           },
  //                           height: 50,
  //                           color: Colors.blue[600],
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(50),
  //                           ),
  //                           child: const Center(
  //                             child: Text(
  //                               "Request OTP",
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 20),
  //                       const SizedBox(height: 20),
  //                       FadeInUp(
  //                         duration: const Duration(milliseconds: 1500),
  //                         child: const Text(
  //                           "Already have an account?",
  //                           style: TextStyle(color: Colors.grey),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 20),
  //                       FadeInUp(
  //                         duration: const Duration(milliseconds: 1600),
  //                         child: MaterialButton(
  //                           onPressed: () {
  //                             Navigator.pop(
  //                                 context); // Navigate back to login screen
  //                           },
  //                           height: 50,
  //                           color: Colors.white,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(50),
  //                             side: BorderSide(
  //                               color: Colors.blue[900]!,
  //                               width: 2,
  //                             ),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "Login",
  //                               style: TextStyle(
  //                                 color: Colors.blue[900],
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 50),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: _refreshVerificationScreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade800,
                  Colors.blue.shade400,
                ],
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: const Text(
                              "Phone Number Verification",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: const Text(
                              "We will send you a One Time Password for the entered mobile number for the registration.",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 60),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1400),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromRGBO(27, 86, 225, 0.298),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      buildTextField("Phone Number"),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1600),
                                child: MaterialButton(
                                  onPressed: registerUser,
                                  height: 50,
                                  color: Colors.blue[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Request OTP",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1500),
                                child: const Text(
                                  "Already have an account?",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 20),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1600),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
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
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshVerificationScreen() async {
    // Add logic here if needed, e.g., clear text fields
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
  }

  Widget buildTextField(String hintText, {bool obscureText = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TextField(
        obscureText: obscureText,
        keyboardType: hintText == "Phone Number"
            ? TextInputType.phone
            : TextInputType.text,
        controller: hintText == "Phone Number"
            ? _phonenoController
            : hintText == "Password"
                ? _passwordController
                : _confirmPasswordController,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
