import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/config.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ClaimScreen extends StatefulWidget {
  final int customerId;

  const ClaimScreen({
    super.key,
    required this.customerId,
  });

  @override
  _ClaimScreenState createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> {
  bool _isLoading = false;
  String firstName = '';
  String lastName = '';

  void _submitClaim() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Claim submitted successfully!')),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchCustomerDetails();
  }

  Future<void> _fetchCustomerDetails() async {
    try {
      final url = Uri.parse(
          "${Config.baseUrl}get_First&LastNames.php?customer_id=${widget.customerId}");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Response Body: ${response.body}");
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            firstName = data['first_name'];
            lastName = data['last_name'];
          });
        } else {
          // print("Error from server: ${data['message']}");
        }
      } else {
        // print('Error: Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      // print('Error fetching customer details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$firstName $lastName',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                // Add any action for the Cancel button if needed
              },
              child: const Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: _isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blue,
                  size: 50,
                )
              : ElevatedButton(
                  onPressed: _submitClaim,
                  child: const Text('Submit Claim'),
                ),
        ),
      ),
    );
  }
}
