import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project_hayleys/otp_forgot_password.dart';
import 'package:animate_do/animate_do.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isSendingOtp = false; // Track OTP sending state
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> identifyUser() async {
    print("Phone Number Verification - Forgot Password");
    print("identifyUser Function ");
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

    // 16/01/2025
    setState(() {
      isSendingOtp = true; // Set OTP sending flag to true
    });

    try {
      final response = await http.post(
        Uri.parse(
            'http://172.16.200.79/flutter_project_hayleys/php/forgot_password_otp.php'),
        body: {
          'phoneno': phoneNo,
          'action': 'generate',
        },
      );

      if (response.statusCode == 200) {
        print("200");
        print("Raw Response Body: ${response.body}");
        final Map<String, dynamic> result = jsonDecode(response.body);

        // Print the status to the terminal
        print("Status: ${result['status']}");
        debugPrint(response.body);

        if (result['status'] == 'not_exists') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else if (result['status'] == 'exists') {
          String userId = result['user_id'].toString();
          print("User ID: $userId");

          // Navigate to OTP screen for verification
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpForgotPassword(
                key: UniqueKey(),
                userId: userId,
                phoneNo: phoneNo,
              ),
            ),
          );
        } else {
          // Handle unexpected status if needed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error processing the request')),
          );
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

    // 16/01/2025
    finally {
      setState(() {
        isSendingOtp = false; // Reset OTP sending flag
      });
    }
  }

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

                    // Back Button
                    FadeInUp(
                      duration: const Duration(milliseconds: 1500),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(
                              context); // Goes back to the previous screen
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: const Text(
                              "Forgot Password",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: const Text(
                              "We will send you a One Time Password for the entered mobile number for change the password.",
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
                                  // 16/01/2025
                                  onPressed: isSendingOtp
                                      ? null
                                      : identifyUser, // Disable button if sending OTP

                                  //onPressed: identifyUser,
                                  height: 50,
                                  color: Colors.blue[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isSendingOtp
                                          ? "Sending OTP..."
                                          : "Request OTP", // Update text based on state
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
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
