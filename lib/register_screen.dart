import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> registerUser() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/flutter_project_hayleys/lib/register.php'),
        body: {
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
          'email': _emailController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        debugPrint(response.body);
        final Map<String, dynamic> result = jsonDecode(response.body);

        if (result['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          Navigator.pop(context); // Navigate back to login screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                gradient: LinearGradient(colors: [
                  Color(0xff2196F3),
                  Color(0xff42A5F5),
                  Color(0xffBBDEFB),
                ], begin: Alignment.centerLeft, end: Alignment.centerRight),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      height: 120,
                      width: 120,
                      child: Image.asset("assets/app_logo.png"),
                    ),
                    const Text(
                      "Register",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            _buildTextField(_usernameController, Icons.person, "User name",
                false, TextInputType.text),
            _buildTextField(_emailController, Icons.email, "Email", false,
                TextInputType.emailAddress),
            _buildTextField(_passwordController, Icons.vpn_key, "Password",
                true, TextInputType.visiblePassword),
            _buildTextField(_confirmPasswordController, Icons.verified_user,
                "Confirm Password", true, TextInputType.visiblePassword),
            const SizedBox(height: 30),

            GestureDetector(
              //onTap: loginUser,
              child: GFButton(
                onPressed: registerUser, // Triggering the same function
                text: "REGISTER",
                blockButton: true,
                //type: GFButtonType.outline2x,
                //color: const Color(0xff2196F3), // Set the primary button color
                // textStyle: const TextStyle(
                //   color: Colors.white,
                //   fontSize: 16,
                // ),
                // shape: GFButtonShape.pills, // Rounded edges for the button
                size: GFSize.LARGE, // Adjust size as needed
              ),
            ),

            // GestureDetector
            // (
            //   onTap: registerUser,
            //   child: Container(
            //     margin: const EdgeInsets.only(left: 20, right: 20, top: 60),
            //     padding: const EdgeInsets.only(left: 20, right: 20),
            //     alignment: Alignment.center,
            //     height: 50,
            //     decoration: BoxDecoration(
            //       gradient: const LinearGradient(colors: [
            //         Color(0xff2196F3),
            //         Color(0xff42A5F5),
            //         Color(0xffBBDEFB),
            //       ], begin: Alignment.centerLeft, end: Alignment.centerRight),
            //       borderRadius: BorderRadius.circular(50),
            //       boxShadow: const [
            //         BoxShadow(
            //             offset: Offset(0, 10),
            //             blurRadius: 50,
            //             color: Color(0x0ffeeeee))
            //       ],
            //     ),
            //     child: const Text(
            //       "REGISTER",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 40), // Add spacing for better layout
            // GFButton(
            //   onPressed: registerUser,
            //   text: "REGISTER",
            //   textStyle: const TextStyle(color: Colors.white),
            //   type: GFButtonType.outline2x,
            //   blockButton: true,
            //   color: const Color(0xff2196F3),
            // ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 90),
              child: Row(
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      " Login Now",
                      style: TextStyle(color: Color(0xff2196F3)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon,
      String hintText, bool obscureText, TextInputType keyboardType) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey[200],
        boxShadow: const [
          BoxShadow(
              offset: Offset(0, 10), blurRadius: 50, color: Color(0x0ffeeeee)),
        ],
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        cursorColor: const Color(0xff2196F3),
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xff2196F3)),
          hintText: hintText,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
