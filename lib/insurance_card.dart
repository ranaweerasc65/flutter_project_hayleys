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

  List<Map<String, String>> addedCards = [];

  @override
  void initState() {
    super.initState();

    print('INSURANCE CARD SCREEN');
    print('Customer ID: ${widget.customerId}');
    print('Logged in user phone no: ${widget.phoneNo}');
  }

  Future<void> _addCard() async {
    // Simulate adding a card
    if (_formKey.currentState!.validate()) {
      setState(() {
        addedCards.add({
          'insuranceCompanyName': insuranceCompanyNameController.text,
          'cardHolderName': cardHolderNameController.text,
          'membershipNo': membershipNoController.text,
          'policyNo': policyNoController.text,
        });
        insuranceCompanyNameController.clear();
        cardHolderNameController.clear();
        membershipNoController.clear();
        policyNoController.clear();
      });
      Navigator.pop(context); // Close the popup
    }
  }

  void _showAddCardForm() {
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

  // Helper function to build form labels with required asterisk
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Added Cards",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            addedCards.isEmpty
                ? const Text(
                    "No cards added yet.",
                    style: TextStyle(color: Colors.grey),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: addedCards.length,
                      itemBuilder: (context, index) {
                        final card = addedCards[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(card['insuranceCompanyName'] ?? ""),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Card Holder: ${card['cardHolderName'] ?? ''}"),
                                Text(
                                    "Membership No: ${card['membershipNo'] ?? ''}"),
                                Text("Policy No: ${card['policyNo'] ?? ''}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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



 //Insurance Card (Display the existing details)
              // Card(
              //   elevation: 8,
              //   color: Colors.orange,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         // Card Title
              //         Text(
              //           insuranceCompanyNameController.text.isNotEmpty
              //               ? insuranceCompanyNameController.text
              //               : "Insurance Company",
              //           style: TextStyle(
              //             fontSize: 24,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.red.shade800,
              //           ),
              //         ),
              //         const SizedBox(height: 16),
              //         // Membership and Policy Number
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 const Text(
              //                   "MEMBERSHIP NO :",
              //                   style: TextStyle(fontWeight: FontWeight.bold),
              //                 ),
              //                 Text(
              //                   membershipNoController.text,
              //                   style: TextStyle(fontSize: 16),
              //                 ),
              //               ],
              //             ),
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 const Text(
              //                   "POLICY NO :",
              //                   style: TextStyle(fontWeight: FontWeight.bold),
              //                 ),
              //                 Text(
              //                   policyNoController.text,
              //                   style: TextStyle(fontSize: 16),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 16),
              //         // Name of the insured
              //         Text(
              //           cardHolderNameController.text,
              //           style: TextStyle(
              //               fontSize: 18, fontWeight: FontWeight.bold),
              //         ),
              //         const SizedBox(height: 16),
              //         // Footer text
              //         const Align(
              //           alignment: Alignment.bottomRight,
              //           child: Text(
              //             "Continental Insurance Lanka Ltd.",
              //             style: TextStyle(fontSize: 12, color: Colors.grey),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),