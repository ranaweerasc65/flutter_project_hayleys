import 'package:flutter/material.dart';

class InsuranceCardPage extends StatefulWidget {
  final int customerId;
  const InsuranceCardPage({super.key, required this.customerId});

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

  @override
  void initState() {
    super.initState();

    print('INSURANCE CARD SCREEN');
    print('Customer ID: ${widget.customerId}');
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
      body: RefreshIndicator(
        onRefresh:
            _refreshForm, // The function to handle the pull-to-refresh action
        color: const Color.fromARGB(255, 8, 120, 212),
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //Insurance Card (Display the existing details)
              // COMMENT BELOW

              const SizedBox(height: 8),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name title
                      const Text(
                        "Insurance Company Name",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),

                      Row(
                        children: [
                          // First Name
                          Expanded(
                            child: buildTextField(
                              insuranceCompanyNameController,
                              "Enter the Insurance Company Name",
                            ),
                          ),
                        ],
                      ),

                      // Name title
                      const Text(
                        "Card Holder Name",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),

                      Row(
                        children: [
                          // First Name
                          Expanded(
                            child: buildTextField(
                              cardHolderNameController,
                              "Enter the card holder name",
                            ),
                          ),
                        ],
                      ),

                      const Text(
                        "Membership No.",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),

                      Row(
                        children: [
                          // City
                          Expanded(
                            child: buildTextField(
                              membershipNoController,
                              "Enter the membership number",
                            ),
                          ),
                        ],
                      ),

                      const Text(
                        "Policy No.",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),

                      Row(
                        children: [
                          // Occupation
                          Expanded(
                            child: buildTextField(
                              policyNoController,
                              "Enter the policy number",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Container(
                        //duration: const Duration(milliseconds: 1600),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: MaterialButton(
                                height: 50, // Button height
                                minWidth: MediaQuery.of(context).size.width *
                                    0.4, // 40% of the screen width
                                color:
                                    Colors.blue[800], // Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      50), // Rounded corners
                                ),

                                onPressed: () {},
                                child: const Center(
                                  child: Text(
                                    "Add and Save Insurance Card",
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
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
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