import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_project_hayleys/change_password.dart';

import 'config.dart';

class OtpForgotPassword extends StatefulWidget {
  final String phoneNo;
  final String userId;

  //const Otp({required Key key}) : super(key: key);
  const OtpForgotPassword(
      {super.key, required this.phoneNo, required this.userId});

  @override
  _OtpForgotPasswordState createState() => _OtpForgotPasswordState();
}

class _OtpForgotPasswordState extends State<OtpForgotPassword> {
//16/01/2024
  bool isVerifying = false; // Track OTP verification state
  final _otpController = List.generate(6, (index) => TextEditingController());
  // final String apiUrlVerifyOtp =
  //     'http://172.16.200.79/flutter_project_hayleys/php/forgot_password_otp.php';
  final String apiUrlVerifyOtp = '${Config.baseUrl}forgot_password_otp.php';

  @override
  void dispose() {
    for (var controller in _otpController) {
      controller.dispose();
    }

    super.dispose();
  }

  void _fetchOtp() async {
    print("come to _fetchOtp");

    try {
      // final url = Uri.parse(
      //     'http://172.16.200.79/flutter_project_hayleys/php/forgot_password_otp.php');
      final url = Uri.parse('${Config.baseUrl}forgot_password_otp.php');

      print("Fetching OTP from $url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('generated_otp')) {
          final generatedOtp = data['generated_otp'];
          print("Generated OTP: $generatedOtp");
        } else {
          print(
              "Response JSON does not contain 'generated_otp': ${response.body}");
        }
      } else {
        print("Failed to fetch OTP. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching OTP: $e");
    }
  }

  // void _verifyOtp() async {
  //   print("come to _verifyOtp in the otp_forgot_password.dart");
  //   // Combine OTP input
  //   String userOtp = _otpController.map((controller) => controller.text).join();

  //   if (userOtp.length < 6) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please enter a 6-digit OTP")),
  //     );
  //     return;
  //   }

  //   try {
  //     // Make a POST request to verify OTP
  //     final response = await http.post(
  //       Uri.parse(apiUrlVerifyOtp),
  //       body: {
  //         'phoneno': widget.phoneNo,
  //         'otp': userOtp,
  //         'action': 'verify',
  //       },
  //     );

  //     print("User-entered OTP: $userOtp");
  //     print("OTP sent to: ${widget.phoneNo}");

  //     if (response.statusCode == 200) {
  //       print("come to 200 status code");
  //       // Parse the response
  //       final result = json.decode(response.body);

  //       print("result: $result");

  //       if (result['status'] == 'success') {
  //         // OTP verified successfully, navigate to change password screen
  //         print("OTP verified, now navigate to change password screen.");

  //         Future.delayed(const Duration(seconds: 1), () {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ChangePasswordScreen(
  //                 phoneNo: 'widget.phoneNo',
  //               ), // New screen for password change
  //             ),
  //           );
  //         });
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text(result['message'] ?? "Invalid OTP, try again")),
  //         );
  //       }
  //     } else {
  //       // Handle non-200 HTTP responses
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Failed with status: ${response.statusCode}")),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("An error occurred. Please try again.")),
  //     );
  //   }
  // }

  void _showSuccessDialog(String message, String phoneNo) {
    print('Phone number at successdialog: $phoneNo');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF00C853), // Green color
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.check_circle,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!!!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C853), // Green color
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(
                          phoneNo:
                              phoneNo, // Pass the phone number to HomeScreen
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _verifyOtp() async {
    setState(() {
      isVerifying = true; // Set verifying state to true
    });

    print("come to _verifyOtp in the otp_forgot_password.dart");
    // Combine OTP input
    String userOtp = _otpController.map((controller) => controller.text).join();

    if (userOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a 6-digit OTP")),
      );

      setState(() {
        isVerifying = false; // Reset verifying state
      });
      return;
    }

    try {
      // Make a POST request to verify OTP
      final response = await http.post(
        Uri.parse(apiUrlVerifyOtp),
        body: {
          'phoneno': widget.phoneNo,
          'otp': userOtp,
          'action': 'verify',
        },
      );

      print("User-entered OTP: $userOtp");
      print("OTP sent to: ${widget.phoneNo}");

      if (response.statusCode == 200) {
        print("come to 200 status code");
        // Parse the response
        final result = json.decode(response.body);

        print("result: $result");

        if (result['status'] == 'success') {
          // OTP verified successfully, show the success dialog
          print("OTP verified, now show success dialog.");
          _showSuccessDialog("OTP verified successfully!", widget.phoneNo);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result['message'] ?? "Invalid OTP, try again")),
          );
        }
      } else {
        // Handle non-200 HTTP responses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed with status: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
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
              child: FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "OTP Verification",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Please enter the OTP sent to your number",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 60),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              6,
                              (index) => Flexible(
                                child: _textFieldOTP(
                                  controller: _otpController[index],
                                  first: index == 0,
                                  last: index == 5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isVerifying
                                ? null
                                : _verifyOtp, // Disable during verification
                            //onPressed: _verifyOtp,
                            style: ButtonStyle(
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.blue.shade900),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                isVerifying ? 'Verifying...' : 'Verify',
                                //'Verify',
                                style: const TextStyle(fontSize: 16),
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
          ],
        ),
      ),
    );
  }

  Widget _textFieldOTP({
    required bool first,
    required bool last,
    required TextEditingController controller,
  }) {
    return SizedBox(
      height: 85,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: controller,
          autofocus: first,
          onChanged: (value) {
            if (value.length == 1 && !last) {
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty && !first) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.blue.shade900),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
