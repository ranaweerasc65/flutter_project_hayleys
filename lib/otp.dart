import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_project_hayleys/register_screen.dart';

class Otp extends StatefulWidget {
  final String userId;

  //const Otp({required Key key}) : super(key: key);
  const Otp({super.key, required this.userId});

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final _otpController = List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _otpController) {
      controller.dispose();
    }

    super.dispose();
  }

  void _verifyOtp() {
    String otp = _otpController.map((controller) => controller.text).join();

    if (otp == "123456") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification Successful")),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          //MaterialPageRoute(builder: (context) => const RegisterScreen(userId)),
          MaterialPageRoute(
            builder: (context) => RegisterScreen(userId: widget.userId),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP, please try again")),
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
                            onPressed: _verifyOtp,
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
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                'Verify',
                                style: TextStyle(fontSize: 16),
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
