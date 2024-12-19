import 'package:flutter/material.dart';

class CustomerDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // You can add any action here when the button is pressed
          },
          child: Text('This is the Customer Details Page'),
        ),
      ),
    );
  }
}
