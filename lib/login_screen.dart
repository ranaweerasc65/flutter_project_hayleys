import 'package:flutter/material.dart';
import 'otp_verification_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';
import 'package:animate_do/animate_do.dart';
import 'phone_number_verification_forgot_password.dart';
import 'config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String? userName;

  // Future<void> loginUser() async {
  //   setState(() {
  //     _isLoading = true; // Show loading indicator
  //   });

  //   final phoneNo = phoneController.text.trim();
  //   final password = passwordController.text.trim();

  //   if (phoneNo.isEmpty || password.isEmpty) {
  //     setState(() {
  //       _isLoading = false; // Stop loading
  //     });
  //     _showErrorDialog('Please enter both phone number and password.');
  //     return;
  //   }

  //   try {
  //     final response = await http.post(
  //       Uri.parse("${Config.baseUrl}login.php"),
  //       body: {
  //         'phone_no': phoneNo,
  //         'password': password,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);

  //       if (jsonResponse['status'] == 'success') {
  //         userName = jsonResponse['name'];

  //         setState(() {
  //           _isLoading = false; // Stop loading
  //         });

  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => HomeScreen(
  //               userName: userName!,
  //               phoneNo: phoneNo,
  //             ),
  //           ),
  //         );
  //       } else {
  //         setState(() {
  //           _isLoading = false; // Stop loading
  //         });
  //         _showErrorDialog(jsonResponse['message']);
  //       }
  //     } else {
  //       setState(() {
  //         _isLoading = false; // Stop loading
  //       });
  //       _showErrorDialog('Server error. Please try again.');
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false; // Stop loading
  //     });
  //     _showErrorDialog('Network error. Please check your internet connection.');
  //   }
  // }

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final phoneNo = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (phoneNo.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false; // Stop loading
      });
      _showErrorDialog('Please enter both phone number and password.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${Config.baseUrl}login.php"),
        body: {
          'phone_no': phoneNo,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          userName = jsonResponse['name'];

          await Future.delayed(const Duration(milliseconds: 500));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                userName: userName!,
                phoneNo: phoneNo,
              ),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog(jsonResponse['message']);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Server error. Please try again.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Network error. Please check your internet connection.');
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
      body: RefreshIndicator(
        onRefresh: _refreshLoginScreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: const Text(
                          "Welcome Back to Fentons Medical Bill Claim System",
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                                      color: Color.fromRGBO(27, 86, 225, 0.298),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          hintText: "Phone number",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: passwordController,
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // FadeInUp(
                            //   duration: const Duration(milliseconds: 1500),
                            //   child: const Text(
                            //     "Forgot Password?",
                            //     style: TextStyle(color: Colors.grey),
                            //   ),
                            // ),

                            FadeInUp(
                              duration: const Duration(milliseconds: 1500),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .end, // Aligns to the right
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: Colors
                                            .blue[900], // Changed to blue color
                                        fontSize: 16, // Increased font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                            // FadeInUp(
                            //   duration: const Duration(milliseconds: 1600),
                            //   child: MaterialButton(
                            //     onPressed: loginUser,
                            //     height: 50,
                            //     color: Colors.blue[900],
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(50),
                            //     ),
                            //     child: const Center(
                            //       child: Text(
                            //         "Login",
                            //         style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 16,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return MaterialButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            loginUser();
                                          },
                                    height: 50,
                                    color: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: _isLoading
                                          ? const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Logging in...",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Text(
                                              "Login",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 30),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1500),
                              child: const Text(
                                "New to the system?",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OtpVerificationScreen(),
                                    ),
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
                                      color: Colors.blue[900],
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshLoginScreen() async {
    phoneController.clear();
    passwordController.clear();
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
  }
}
