import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class InsuranceCardPage extends StatefulWidget {
  final int customerId;
  final String phoneNo;
  const InsuranceCardPage({
    super.key,
    required this.customerId,
    required this.phoneNo,
  });

  @override
  State<InsuranceCardPage> createState() => _InsuranceCardPageState();
}

class _InsuranceCardPageState extends State<InsuranceCardPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController membershipNoController = TextEditingController();
  final TextEditingController policyNoController = TextEditingController();
  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController insuranceCompanyNameController =
      TextEditingController();

  List<Map<String, dynamic>> addedCards = [];

  @override
  void initState() {
    super.initState();

    print('INSURANCE CARD SCREEN');
    print('Customer ID: ${widget.customerId}');
    print('Logged in user phone no: ${widget.phoneNo}');

    _fetchAddedCards();
  }

  Future<void> _addCard() async {
    print('insurance_card.dart');
    print('_addCard function');

    // Mandatory fields to check
    final mandatoryFields = {
      "Insurance Company Name": insuranceCompanyNameController.text,
      "Card Holder Name": cardHolderNameController.text,
      "Membership No": membershipNoController.text,
      "Policy No": policyNoController.text,
    };

    // Check for missing mandatory fields
    final missingFields = mandatoryFields.entries
        .where((entry) => entry.value.toString().trim().isEmpty)
        .map((entry) => entry.key)
        .toList();

    if (missingFields.isNotEmpty) {
      // Show error message for missing mandatory fields
      _showErrorDialog(
          "Please fill all the mandatory fields before submitting.");
      return;
    }

    if (_formKey.currentState!.validate()) {
      final cardDetails = {
        "phone_no": widget.phoneNo, // Ensure widget.phoneNo is a String
        "customers_id": widget.customerId.toString(), // Convert int to String
        "insurance_card_holder_name": cardHolderNameController.text,
        "insurance_membership_no": membershipNoController.text,
        "insurance_policy_no": policyNoController.text,
        "insurance_company": insuranceCompanyNameController.text,
      };

      // Print card details for debugging
      print('Card Details: $cardDetails');

      try {
        final response = await http.post(
          Uri.parse(
              "http://172.16.200.79/flutter_project_hayleys/php/insurance_card.php"),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: cardDetails,
        );

        // Print response body for debugging
        print('Response: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            final insuranceId =
                jsonResponse['insurance_id']; // Extract insurance_id
            print('Insurance ID: $insuranceId');
            _showSuccessDialog(
                'Insurance card details added successfully\nInsurance ID: $insuranceId',
                insuranceId);
            // Refresh the list of cards
            _fetchAddedCards();
          } else {
            _showErrorDialog(
                jsonResponse['message'] ?? "An unknown error occurred.");
          }
        } else {
          _showErrorDialog("Server returned an error: ${response.statusCode}");
        }
      } catch (e) {
        _showErrorDialog("An error occurred: $e");
        print("Error: $e");
      }
    }
  }

  void _showSuccessDialog(String message, int customerId) {
    print('Insurance ID at successdialog: $customerId');
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
                    Navigator.of(context).pop(); // Close the success dialog
                    Navigator.of(context)
                        .pop(); // Close the card view dialog (_showAddCardForm)
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

  void _showErrorDialog(String errorMessage) {
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
                    color: Colors.red, // Red color
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.error,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Error!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Red color
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
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

  void _showAddCardForm() {
    // Reset the controllers
    insuranceCompanyNameController.clear();
    cardHolderNameController.clear();
    membershipNoController.clear();
    policyNoController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header section with close button
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 5, 94, 166), // Dark blue header
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Add New Insurance Card",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const CircleAvatar(
                            backgroundColor: Color.fromARGB(0, 227, 4, 4),
                            radius: 16,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel("Insurance Company Name"),
                        buildTextField(
                          insuranceCompanyNameController,
                          "Enter the Insurance Company Name",
                        ),
                        const SizedBox(height: 16),
                        buildLabel("Card Holder Name"),
                        buildTextField(
                          cardHolderNameController,
                          "Enter the card holder name",
                        ),
                        const SizedBox(height: 16),
                        buildLabel("Membership No."),
                        buildTextField(
                          membershipNoController,
                          "Enter the membership number",
                        ),
                        const SizedBox(height: 16),
                        buildLabel("Policy No."),
                        buildTextField(
                          policyNoController,
                          "Enter the policy number",
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _addCard,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                minimumSize: const Size(200, 50),
                              ),
                              child: const Text(
                                "Add Card",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () => _showClearFormDialog(context),
                              height: 50,
                              minWidth: 200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                  color: Colors.blue[800]!,
                                  width: 2.0,
                                ),
                              ),
                              child: const Text(
                                "Clear Form",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 2, 99, 178),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildLabel(String labelText) {
    return Row(
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          "*",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Future<void> _refreshForm() async {
    setState(() {
      membershipNoController.clear();
      policyNoController.clear();
      cardHolderNameController.clear();
      insuranceCompanyNameController.clear();
    });
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _fetchExistingDetails(int insuranceId) async {
    print('Fetching card details...');
    print('Insurance ID at successdialog: $insuranceId');

    setState(() {
      // isLoading = true; // Start loading
    });

    try {
      final url = Uri.parse(
          "http://172.16.200.79/flutter_project_hayleys/php/fetch_insurance_card.php?INSURANCE_ID=$insuranceId}");

      // Send the GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response body _fetchExistingDetails: ${response.body}');

        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          // Parse the existing data and populate the form fields
          var existingData = jsonResponse['customer_data'];

          setState(() {
            membershipNoController.text =
                existingData['INSURANCE_MEMBERSHIP_NO'];
            policyNoController.text = existingData['INSURANCE_POLICY_NO'];
            cardHolderNameController.text =
                existingData['INSURANCE_CARD_HOLDER_NAME'];
            insuranceCompanyNameController.text =
                existingData['INSURANCE_COMPANY_NAME'];
          });
        } else {
          _showErrorDialog(
              jsonResponse['message'] ?? "Failed to fetch details.");
        }
      } else {
        _showErrorDialog("Failed to fetch details. Please try again later.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
      print("Error: $e");
    } finally {
      setState(() {
        // isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _fetchAddedCards() async {
    print("Fetching added cards...");
    final url = Uri.parse(
      "http://172.16.200.79/flutter_project_hayleys/php/get_insurance_cards.php?customers_id=${widget.customerId}",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(
            'Response body: ${response.body}'); // Print the body of the response
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          print("status = success");
          setState(() {
            addedCards = List<Map<String, dynamic>>.from(data['addedCards']);
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load cards: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cards: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insurance Card Details',
          style: TextStyle(
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
                _showExitConfirmationDialog(context);
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Added Cards",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              addedCards.isEmpty
                  ? const Text(
                      "No cards added yet.",
                      style: TextStyle(color: Colors.grey),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          // For small screens, use ListView
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: addedCards.length,
                            itemBuilder: (context, index) {
                              final card = addedCards[index];
                              return _buildCardItem(card);
                            },
                          );
                        } else {
                          // For large screens, use GridView

                          // Fixed height for grid items
                          const fixedHeight = 240.0;

                          // Calculate the width of each item based on the screen width and crossAxisCount
                          final screenWidth = constraints.maxWidth;
                          const crossAxisCount = 2; // Number of items per row
                          const crossAxisSpacing =
                              10.0; // Spacing between items horizontally
                          const mainAxisSpacing = 10.0; // Spacing between rows

                          // Calculate the available width for each item
                          final availableWidthForItems = screenWidth -
                              (crossAxisSpacing * (crossAxisCount - 1));
                          final itemWidth =
                              availableWidthForItems / crossAxisCount;

                          // Calculate the childAspectRatio based on the fixed height and calculated width
                          final childAspectRatio = itemWidth / fixedHeight;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio:
                                  childAspectRatio, // Dynamic aspect ratio
                              crossAxisSpacing: crossAxisSpacing,
                              mainAxisSpacing: mainAxisSpacing,
                            ),
                            itemCount: addedCards.length,
                            itemBuilder: (context, index) {
                              final card = addedCards[index];
                              return _buildCardItem(card);
                            },
                          );
                        }
                      },
                    ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _showAddCardForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    "Add a New Card",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem(Map<String, dynamic> card) {
    return Container(
      height: 250.0, // Fixed height for the card
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 135, 59, 18),
            Color.fromARGB(255, 17, 25, 105)
          ],
        ),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 6,
        margin: EdgeInsets.zero, // Remove margin to avoid extra space
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand, // Ensure the Stack fills the entire card
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0), // Adjust padding as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['insurance_company'] ?? "Unknown Company",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          card['insurance_card_holder_name']?.toString() ??
                              'N/A',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Card Holder Name",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            card['insurance_membership_no']?.toString() ??
                                'N/A',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "Membership No",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            card['insurance_policy_no']?.toString() ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "Policy No",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom:
                  8, // Adjust this value to move buttons closer to the bottom
              right: 8, // Adjust this value to move buttons closer to the right
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      _showEditDialog(card);
                    },
                    icon: const Icon(Icons.edit, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () {
                      print(
                          "Delete button pressed for insurance_id: ${card['insurance_id']} customers_id=${widget.customerId} phone_no=${widget.phoneNo}");
                      _showDeleteConfirmationDialog(card['insurance_id']);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'Insurance Card Details',
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 24,
  //           color: Colors.white,
  //         ),
  //       ),
  //       automaticallyImplyLeading: false,
  //       centerTitle: true,
  //       backgroundColor: Colors.blue.shade800,
  //       leading: IconButton(
  //         icon: const Icon(Icons.arrow_back, color: Colors.white),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //       ),
  //       actions: [
  //         Padding(
  //           padding: const EdgeInsets.only(right: 16),
  //           child: GestureDetector(
  //             onTap: () {
  //               _showExitConfirmationDialog(context);
  //             },
  //             child: const Center(
  //               child: Text(
  //                 'Cancel',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     backgroundColor: Colors.white,
  //     body: Padding(
  //       padding: const EdgeInsets.all(40.0),
  //       child: SingleChildScrollView(
  //         // Added SingleChildScrollView
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               "Added Cards",
  //               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8),
  //             addedCards.isEmpty
  //                 ? const Text(
  //                     "No cards added yet.",
  //                     style: TextStyle(color: Colors.grey),
  //                   )
  //                 : LayoutBuilder(
  //                     builder: (context, constraints) {
  //                       return GridView.builder(
  //                         shrinkWrap:
  //                             true, // To prevent GridView from taking full height
  //                         physics:
  //                             const NeverScrollableScrollPhysics(), // Disable scrolling of GridView
  //                         gridDelegate:
  //                             const SliverGridDelegateWithFixedCrossAxisCount(
  //                           crossAxisCount: 2, // Number of cards in a row
  //                           crossAxisSpacing: 10, // Spacing between columns
  //                           mainAxisSpacing: 10, // Spacing between rows
  //                           childAspectRatio:
  //                               5 / 2, // Adjust the card height/width ratio
  //                         ),
  //                         itemCount: addedCards.length,
  //                         itemBuilder: (context, index) {
  //                           final card = addedCards[index];
  //                           return Container(
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(20),
  //                               gradient: const LinearGradient(
  //                                 begin: Alignment.topLeft,
  //                                 end: Alignment.bottomRight,
  //                                 colors: [
  //                                   Color.fromARGB(255, 135, 59, 18),
  //                                   Color.fromARGB(255, 17, 25, 105)
  //                                 ],
  //                               ),
  //                             ),
  //                             child: Card(
  //                               color: Colors
  //                                   .transparent, // Make the card transparent to show the gradient
  //                               elevation: 6,
  //                               margin: const EdgeInsets.symmetric(vertical: 8),
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(16),
  //                               ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(16.0),
  //                                 child: Stack(
  //                                   children: [
  //                                     // Main content column
  //                                     Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         // Insurance Company Name
  //                                         Text(
  //                                           card['insurance_company'] ??
  //                                               "Unknown Company",
  //                                           style: const TextStyle(
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 20,
  //                                             color: Colors.white,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 6),
  //                                         // Card Holder Name
  //                                         Center(
  //                                           child: Column(
  //                                             mainAxisSize: MainAxisSize
  //                                                 .min, // Ensures the column takes minimum height
  //                                             children: [
  //                                               Text(
  //                                                 card['insurance_card_holder_name']
  //                                                         ?.toString() ??
  //                                                     'N/A',
  //                                                 style: const TextStyle(
  //                                                   fontSize: 18,
  //                                                   color: Colors.white,
  //                                                 ),
  //                                               ),
  //                                               const SizedBox(
  //                                                   height:
  //                                                       2), // Adds spacing between text elements
  //                                               const Text(
  //                                                 "Card Holder Name",
  //                                                 style: TextStyle(
  //                                                   fontSize: 12,
  //                                                   color: Colors.white70,
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 16),
  //                                         // Membership No and Policy No
  //                                         Row(
  //                                           mainAxisAlignment:
  //                                               MainAxisAlignment.spaceBetween,
  //                                           children: [
  //                                             Column(
  //                                               children: [
  //                                                 Text(
  //                                                   card['insurance_membership_no']
  //                                                           ?.toString() ??
  //                                                       'N/A',
  //                                                   style: const TextStyle(
  //                                                     fontSize: 18,
  //                                                     color: Colors.white,
  //                                                   ),
  //                                                 ),
  //                                                 const Text(
  //                                                   "Membership No",
  //                                                   style: TextStyle(
  //                                                     fontSize: 12,
  //                                                     color: Colors.white70,
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             Column(
  //                                               children: [
  //                                                 Text(
  //                                                   card['insurance_policy_no']
  //                                                           ?.toString() ??
  //                                                       'N/A',
  //                                                   style: const TextStyle(
  //                                                     fontSize: 18,
  //                                                     color: Colors.white,
  //                                                   ),
  //                                                 ),
  //                                                 const Text(
  //                                                   "Policy No",
  //                                                   style: TextStyle(
  //                                                     fontSize: 12,
  //                                                     color: Colors.white70,
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     // Edit and Delete buttons positioned at the bottom-right
  //                                     Align(
  //                                       alignment: Alignment.bottomRight,
  //                                       child: Row(
  //                                         mainAxisSize: MainAxisSize.min,
  //                                         children: [
  //                                           // Edit Button
  //                                           IconButton(
  //                                             onPressed: () {
  //                                               _showEditDialog(
  //                                                   card); // Call the function instead of inline logic
  //                                             },
  //                                             icon: const Icon(Icons.edit,
  //                                                 color: Colors.red),
  //                                           ),
  //                                           // Delete Button
  //                                           IconButton(
  //                                             onPressed: () {
  //                                               print(
  //                                                   "Delete button pressed for insurance_id: ${card['insurance_id']} customers_id=${widget.customerId} phone_no=${widget.phoneNo}");
  //                                               _showDeleteConfirmationDialog(
  //                                                   card['insurance_id']);
  //                                             },
  //                                             icon: const Icon(Icons.delete,
  //                                                 color: Colors.red),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       );
  //                     },
  //                   ),
  //             const SizedBox(height: 20),
  //             Center(
  //               child: ElevatedButton(
  //                 onPressed: _showAddCardForm,
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.blue[800],
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(50),
  //                   ),
  //                   minimumSize: const Size(200, 50),
  //                 ),
  //                 child: const Text(
  //                   "Add a New Card",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showDeleteConfirmationDialog(int insuranceId) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismiss
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 300, // Fixed width for consistency
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red, // Red for delete warning
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.delete,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Confirm Deletion",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red, // Match icon color
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure you want to delete this insurance card?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey, // Neutral color for cancel
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red for delete action
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop(); // Close the dialog
                          final response =
                              await deleteInsuranceCard(insuranceId);
                          if (response['status'] == 'success') {
                            _fetchAddedCards(); // Refresh UI
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Failed to delete insurance card: ${response['message']}")),
                            );
                          }
                        },
                        child: const Text(
                          "Yes, Delete",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> deleteInsuranceCard(int insuranceId) async {
    final url = Uri.parse(
        'http://172.16.200.79/flutter_project_hayleys/php/insurance_card.php'); // Replace with your backend URL
    final response = await http.post(
      url,
      body: {
        'action': 'delete',
        'insurance_id': insuranceId.toString(), // Convert insuranceId to String
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete insurance card');
    }
  }

  Future<void> _saveDetails(int? insuranceId) async {
    print('Save details $insuranceId');

    final mandatoryFields = {
      "Insurance Company Name": insuranceCompanyNameController.text,
      "Card Holder Name": cardHolderNameController.text,
      "Membership No": membershipNoController.text,
      "Policy No": policyNoController.text,
    };

    final missingFields = mandatoryFields.entries
        .where((entry) => entry.value.trim().isEmpty)
        .map((entry) => entry.key)
        .toList();

    print('Mandatory Fields Check: $mandatoryFields');
    print('Missing Fields: $missingFields');

    if (missingFields.isNotEmpty) {
      _showErrorDialog(
          "Please fill all the mandatory fields before submitting.");
      return;
    }

    if (_formKey.currentState!.validate()) {
      final cardDetails = {
        "phone_no": widget.phoneNo,
        "customers_id": widget.customerId.toString(),
        "insurance_card_holder_name": cardHolderNameController.text,
        "insurance_membership_no": membershipNoController.text,
        "insurance_policy_no": policyNoController.text,
        "insurance_company": insuranceCompanyNameController.text,
        if (insuranceId != null)
          "insurance_id":
              insuranceId.toString(), // Pass `insurance_id` if it exists
      };

      print('Card Details: $cardDetails');

      try {
        final response = await http.post(
          Uri.parse(
              "http://172.16.200.79/flutter_project_hayleys/php/insurance_card.php"),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: cardDetails,
        );

        print('Response: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            final updatedInsuranceId =
                jsonResponse['insurance_id']; // Extract updated insurance_id
            print('Insurance ID: $updatedInsuranceId');
            _showSuccessDialog(
                'Insurance card details updated successfully\nInsurance ID: $updatedInsuranceId',
                updatedInsuranceId);
            _fetchAddedCards(); // Refresh the list of cards
          } else {
            _showErrorDialog(
                jsonResponse['message'] ?? "An unknown error occurred.");
          }
        } else {
          _showErrorDialog("Server returned an error: ${response.statusCode}");
        }
      } catch (e) {
        _showErrorDialog("An error occurred: $e");
        print("Error: $e");
      }
    }
  }

  Future<void> _showConfirmationDialog(int insuranceId) async {
    print("confirmation dialog $insuranceId");
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
            child: SizedBox(
              width: 300, // Fixed width for the dialog
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.orange, // Use orange for a neutral tone
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.info,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Confirmation",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange, // Match icon color
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure you want to save the details?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF00C853), // Green color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _saveDetails(
                              insuranceId); // Now call the save details function
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hint, {
    bool isMandatory = false,
    TextInputType keyboardType = TextInputType.text,
    Color hintColor = const Color(0xFFB0BEC5),
    Color borderColor = const Color(0xFFCFD8DC),
    Color labelColor = const Color(0xFF78909C),
    Color focusedBorderColor = const Color(0xFF607D8B),
    String? Function(String?)? validator,
    String? errorMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: hintColor,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10.0,
                ),
                // Show error message if exists
                errorText: errorMessage,
              ),
              keyboardType: keyboardType,
              validator: validator,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "Please enter $label.";
              //   }
              //   return null;
              // },
            ),
          ),
          const SizedBox(height: 8),
          // Label with optional red * for mandatory fields
        ],
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit Confirmation"),
          content: const Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _showClearFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear Form Confirmation"),
          content: const Text("Are you sure you want to clear the form?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearForm();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    insuranceCompanyNameController.clear();
    cardHolderNameController.clear();
    membershipNoController.clear();
    policyNoController.clear();
  }

  void _showEditDialog(Map<String, dynamic> card) {
    print(
        "Edit button pressed for insurance_id: ${card['insurance_id']} customers_id=${widget.customerId} phone_no=${widget.phoneNo}");

    // Set the controllers with the existing card details
    insuranceCompanyNameController.text = card['insurance_company'] ?? '';
    cardHolderNameController.text = card['insurance_card_holder_name'] ?? '';
    membershipNoController.text = card['insurance_membership_no'] ?? '';
    policyNoController.text = card['insurance_policy_no'] ?? '';

    // Show the edit dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header section with close button
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 5, 94, 166),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Edit Insurance Card",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const CircleAvatar(
                            backgroundColor: Color.fromARGB(0, 227, 4, 4),
                            radius: 16,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Form content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel("Insurance Company Name"),
                        buildTextField(
                          insuranceCompanyNameController,
                          "Enter the Insurance Company Name",
                        ),
                        const SizedBox(height: 16),
                        buildLabel("Card Holder Name"),
                        buildTextField(
                          cardHolderNameController,
                          "Enter the card holder name",
                        ),
                        const SizedBox(height: 16),
                        buildLabel("Membership No."),
                        buildTextField(
                          membershipNoController,
                          "Enter the membership number",
                        ),
                        const SizedBox(height: 16),
                        buildLabel("Policy No."),
                        buildTextField(
                          policyNoController,
                          "Enter the policy number",
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: MaterialButton(
                                onPressed: () {
                                  _showConfirmationDialog(card['insurance_id']);
                                },
                                height: 50,
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                                color: Colors.blue[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Save Changes",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
