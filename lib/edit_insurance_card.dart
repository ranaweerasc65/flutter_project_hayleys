import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EditInsuranceCard extends StatefulWidget {
  final int insuranceId;
  final int customerId;
  final String phoneNo;
  const EditInsuranceCard({
    super.key,
    required this.insuranceId,
    required this.customerId,
    required this.phoneNo,
  });

  @override
  State<EditInsuranceCard> createState() => _EditInsuranceCardState();
}

class _EditInsuranceCardState extends State<EditInsuranceCard> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController membershipNoController = TextEditingController();
  final TextEditingController policyNoController = TextEditingController();
  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController insuranceCompanyNameController =
      TextEditingController();

  bool isLoading = false;

  List<Map<String, dynamic>> addedCards = [];

  @override
  void initState() {
    super.initState();

    print('INSURANCE CARD SCREEN');
    print('Insurance ID: ${widget.insuranceId}');
    print('Logged in user phone no: ${widget.phoneNo}');

    _fetchAddedCards();

    _fetchExistingDetails();
  }

  Future<void> _fetchExistingDetails() async {
    print('come to _fetchExistingDetails');
    print('Insurance ID : ${widget.insuranceId} ');

    setState(() {
      isLoading = true; // Start loading
    });

    try {
      final url = Uri.parse(
          "http://172.16.200.79/flutter_project_hayleys/php/fetch_insurance_card.php?INSURANCE_ID=${widget.insuranceId}");

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
        isLoading = false; // Stop loading
      });
    }
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

  void _showSuccessDialog(String message, int insuranceId) {
    print('Insurance ID at successdialog: $insuranceId');
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
                              onPressed: _showConfirmationDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                minimumSize: const Size(200, 50),
                              ),
                              child: const Text(
                                "Save Changes",
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

  void _showConfirmationDialog() {
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
                          _saveDetails(); // Now call the save details function
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

  Future<void> _refreshForm() async {
    setState(() {
      membershipNoController.clear();
      policyNoController.clear();
      cardHolderNameController.clear();
      insuranceCompanyNameController.clear();
    });
    await Future.delayed(const Duration(seconds: 1));

    // Fetch details from the database to repopulate the fields
    await _fetchExistingDetails();
  }

  Future<void> _fetchAddedCards() async {
    final url = Uri.parse(
      "http://172.16.200.79/flutter_project_hayleys/php/get_insurance_cards.php?insurance_id=${widget.insuranceId}",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("status = 200");
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

  // Function to save the updated details
  Future<void> _saveDetails() async {
    print(' _saveDetails function');

    final TextEditingController membershipNoController =
        TextEditingController();
    final TextEditingController policyNoController = TextEditingController();
    final TextEditingController cardHolderNameController =
        TextEditingController();
    final TextEditingController insuranceCompanyNameController =
        TextEditingController();

// Mandatory fields to check
    final mandatoryFields = {
      "Membership No": membershipNoController.text,
      "Policy No": policyNoController.text,
      "Card Holder Name": cardHolderNameController.text,
      "Insurance Company Name": insuranceCompanyNameController.text,
    };

    // Check if any mandatory field is missing
    final missingFields = mandatoryFields.entries
        .where((entry) => entry.value.toString().trim().isEmpty)
        .map((entry) => entry.key)
        .toList();

    print('Mandatory Fields Check: $mandatoryFields');
    print('Missing Fields: $missingFields');

    if (missingFields.isNotEmpty) {
      // Show error message for missing mandatory fields
      _showErrorDialog(
          "Please fill all the mandatory fields before submitting.");
      return;
    }

    if (_formKey.currentState!.validate()) {
      final userDetails = {
        "customer_id": widget.customerId.toString(),
        "phone_no": widget.phoneNo,
        "insurance_membership_no": membershipNoController.text,
        "insurance_policy_no": policyNoController.text,
        "insurance_card_holder_name": cardHolderNameController.text,
        "insurance_company_name": insuranceCompanyNameController.text,
      };

      // Print the user-entered details to the terminal for debugging
      print('Insurance Card Details: $userDetails');

      try {
        final response = await http.post(
          Uri.parse(
              "http://172.16.200.79/flutter_project_hayleys/php/user_details.php"),
          //172.16.200.79
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: userDetails,
        );

        // Print response body to terminal for debugging
        print('Response: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            final insuranceId =
                jsonResponse['insurance_id']; // Extract customer_id
            print('Customer ID: $insuranceId');

            if (jsonResponse['message'] ==
                'Customer details updated successfully') {
              _showSuccessDialog(
                  'Insurance card details added successfully', insuranceId);
              //_showConfirmationDialog();
            }
          } else {
            _showErrorDialog(
                jsonResponse['message'] ?? "An unknown error occurred.");
          }
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Error: $e")),
        // );
        _showErrorDialog("An error occurred: $e");
        print("Error: $e");
      }
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
          // Added SingleChildScrollView
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
                          // Small screen, use ListView
                          return ListView.builder(
                            shrinkWrap:
                                true, // To prevent ListView from taking full height
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling of ListView
                            itemCount: addedCards.length,
                            itemBuilder: (context, index) {
                              final card = addedCards[index];
                              return GestureDetector(
                                onTap: () {
                                  _showCardDetailsDialog(context, card);
                                },
                                child: Card(
                                  color:
                                      const Color.fromARGB(255, 140, 185, 218),
                                  elevation: 4,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card['insurance_company'] ??
                                              "Unknown Company",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.person,
                                                color: Colors.blue),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Card Holder Name: ${card['insurance_card_holder_name'] ?? 'N/A'}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.card_membership,
                                                color: Colors.green),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Membership No: ${card['insurance_membership_no'] ?? 'N/A'}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.policy,
                                                color: Color.fromARGB(
                                                    255, 238, 0, 255)),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Policy No: ${card['insurance_policy_no'] ?? 'N/A'}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
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
                        } else {
                          // Large screen, use GridView
                          return GridView.builder(
                            shrinkWrap:
                                true, // To prevent GridView from taking full height
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling of GridView
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of cards in a row
                              crossAxisSpacing: 10, // Spacing between columns
                              mainAxisSpacing: 10, // Spacing between rows
                              childAspectRatio:
                                  5 / 2, // Adjust the card height/width ratio
                            ),
                            itemCount: addedCards.length,
                            itemBuilder: (context, index) {
                              final card = addedCards[index];
                              return Card(
                                color: Colors.blue.shade50,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card['insurance_company'] ??
                                            "Unknown Company",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.person,
                                              color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Card Holder Name: ${card['insurance_card_holder_name'] ?? 'N/A'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.card_membership,
                                              color: Colors.green),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Membership No: ${card['insurance_membership_no'] ?? 'N/A'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.policy,
                                              color: Colors.orange),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Policy No: ${card['insurance_policy_no'] ?? 'N/A'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
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

  void _showCardDetailsDialog(BuildContext context, Map<String, dynamic> card) {
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
                          "Insurance Card Details",
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabel("Insurance Company Name"),
                      Text(card['insurance_company'] ?? "Unknown Company"),
                      const SizedBox(height: 16),
                      buildLabel("Card Holder Name"),
                      Text(card['insurance_card_holder_name'] ?? 'N/A'),
                      const SizedBox(height: 16),
                      buildLabel("Membership No."),
                      Text(card['insurance_membership_no'] ?? 'N/A'),
                      const SizedBox(height: 16),
                      buildLabel("Policy No."),
                      Text(card['insurance_policy_no'] ?? 'N/A'),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
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
}
