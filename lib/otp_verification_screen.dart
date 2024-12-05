import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project_hayleys/otp.dart';
import 'login_screen.dart';
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
    if (_phonenoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/flutter_project_hayleys/lib/register.php'),
        body: {
          'phoneno': _phonenoController.text.trim(),
          'password': _passwordController.text.trim()
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);

        if (result['status'] == 'exists') {
          // Phone number exists, proceed to login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const LoginScreen()), // Navigate to login screen
          );
        } else if (result['status'] == 'not_exists') {
          // Phone number doesn't exist, proceed with registration
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          // Proceed to OTP screen for registration
          // Optionally, you can trigger OTP request here if needed
        } else {
          // Handle any other unexpected response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error processing the request')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to the server')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception: $e')),
      );
    }
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
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "OTP Verification",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInUp(
                    duration: Duration(milliseconds: 1300),
                    child: Text(
                      // "Welcome to Fentons Medical Bill Claim System",
                      "We will send you an One Time Password for the entered mobile number for the registration.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
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
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
                      FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Otp(key: UniqueKey())),
                            );
                          },
                          height: 50,
                          color: Colors.blue[600],
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
                      SizedBox(height: 20),
                      FadeInUp(
                        duration: Duration(milliseconds: 1500),
                        child: Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigate back to login screen
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
                      SizedBox(height: 50),
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

  Widget buildTextField(String hintText, {bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.all(10),
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
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
