import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../config.dart';

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
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  Set<int> revealedCards = {}; // Track revealed card IDs

  final TextEditingController membershipNoController = TextEditingController();
  final TextEditingController policyNoController = TextEditingController();
  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController insuranceCompanyNameController =
      TextEditingController();

  int? primaryUserId; // Store the primary user ID

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
      _showErrorDialog(
          "Please fill all the mandatory fields before submitting.");
      return;
    }

    if (_formKey.currentState!.validate()) {
      final cardDetails = {
        "customers_id": widget.customerId.toString(), // Convert int to String
        "insurance_card_holder_name": cardHolderNameController.text,
        "insurance_membership_no": membershipNoController.text,
        "insurance_policy_no": policyNoController.text,
        "insurance_company": insuranceCompanyNameController.text,
      };

      print('Card Details: $cardDetails');

      try {
//         final response = await http.post(
//           Uri.parse(
//               "http://192.168.8.100/flutter_project_hayleys/php/insurance_card.php"),
// //172.16.200.79

//           headers: {"Content-Type": "application/x-www-form-urlencoded"},
//           body: cardDetails,
//         );

        final response = await http.post(
          Uri.parse("${Config.baseUrl}insurance/insurance_card.php"),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: cardDetails,
        );

        print('Response: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            final insuranceId = jsonResponse['insurance_id'];
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

  // Future<void> _fetchAddedCards() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   print("Fetching added cards for customer id ${widget.customerId}...");
  //   final url = Uri.parse(
  //     "http://172.16.200.79/flutter_project_hayleys/php/get_insurance_cards.php?customers_id=${widget.customerId}",
  //   );

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       print('Response body: ${response.body}');
  //       final data = jsonDecode(response.body);

  //       if (data['status'] == 'success') {
  //         print("status = success");
  //         setState(() {
  //           primaryUserId = data['primaryUserId'];
  //           addedCards = List<Map<String, dynamic>>.from(data['addedCards']);
  //         });
  //       } else {
  //         print('Error: ${data['message']}');
  //       }
  //     } else {
  //       print('Failed to load cards: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching cards: $e');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

//   Future<void> _fetchAddedCards() async {
//     setState(() {
//       _isLoading = true;
//     });

//     print("Fetching added cards for customer id ${widget.customerId}...");
//     final url = Uri.parse(
//       "http://192.168.8.100/flutter_project_hayleys/php/get_insurance_cards.php?customers_id=${widget.customerId}",
//     );
// //172.16.200.79
//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         // print response body
//         print('Response body: ${response.body}');

//         final data = jsonDecode(response.body);

//         if (data['status'] == 'success') {
//           print("status = success");
//           print("Primary User ID: ${data['primaryUserId']}");
//           print("----------------------");

//           List<Map<String, dynamic>> rawCards =
//               List<Map<String, dynamic>>.from(data['addedCards']);
//           Set<int> uniqueInsuranceIds = {}; // Track unique insurance IDs
//           List<Map<String, dynamic>> filteredCards = [];

//           for (var card in rawCards) {
//             print("Insurance ID: ${card['insurance_id']}");
//             print("Insurance Company: ${card['insurance_company']}");
//             print("Card Holder Name: ${card['insurance_card_holder_name']}");
//             print("Membership No: ${card['insurance_membership_no']}");
//             print("Policy No: ${card['insurance_policy_no']}");
//             print("Is Revealed: ${card['is_revealed']}");
//             print("Customer ID: ${card['customers_id']}");
//             print("----------------------"); // Separator for readability

//             int insuranceId = card['insurance_id'];
//             if (!uniqueInsuranceIds.contains(insuranceId)) {
//               uniqueInsuranceIds.add(insuranceId);
//               filteredCards.add(card);
//             }
//           }

//           setState(() {
//             primaryUserId = data['primaryUserId'];
//             debugPrint('ok ${filteredCards.toString()}');
//             addedCards = filteredCards;
//           });
//         } else {
//           print('Error: ${data['message']}');
//         }
//       } else {
//         print('Failed to load cards: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching cards: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

  Future<void> _fetchAddedCards() async {
    setState(() {
      _isLoading = true;
    });

    print("Fetching added cards for customer id ${widget.customerId}...");
    // final url = Uri.parse(
    //   "http://192.168.8.100/flutter_project_hayleys/php/get_insurance_cards.php?customers_id=${widget.customerId}",
    // );

    final url = Uri.parse(
      "${Config.baseUrl}insurance/get_insurance_cards.php?customers_id=${widget.customerId}",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          print("Primary User ID: ${data['primaryUserId']}");
          print("----------------------");

          List<Map<String, dynamic>> rawCards =
              List<Map<String, dynamic>>.from(data['addedCards']);

          // Store the added cards into the addedCards list
          setState(() {
            addedCards =
                rawCards; // Assuming addedCards is a List<Map<String, dynamic>>
          });

          // Debug print the addedCards list
          debugPrint('Added Cards: ${addedCards.toString()}');

          Set<int> uniqueInsuranceIds = {}; // Track unique insurance IDs
          List<Map<String, dynamic>> filteredCards = [];

          // Create a map to track insurance_id and their associated customer_ids
          Map<int, Set<int>> insuranceCustomerIds = {};

          for (var card in rawCards) {
            int insuranceId = card['insurance_id'];
            int cardCustomerId =
                card['customers_id']; // Get the customer ID for this card

            // Store all customer ids for each insurance_id
            if (!insuranceCustomerIds.containsKey(insuranceId)) {
              insuranceCustomerIds[insuranceId] = {};
            }
            insuranceCustomerIds[insuranceId]?.add(cardCustomerId);

            // ✅ Filter: Only add cards where customers_id == widget.customerId
            if (cardCustomerId == widget.customerId &&
                !uniqueInsuranceIds.contains(insuranceId)) {
              uniqueInsuranceIds.add(insuranceId);
              filteredCards.add(card);

              // Print details of the selected card
              print("Filtered Cards");
              print(
                  "Insurance ID: ${card['insurance_id']}, Is Revealed: ${card['is_revealed']}, Customer ID: ${card['customers_id']}");
            }
          }

          // Now, we can pass primaryUserOwnership as a boolean to each card
          for (var card in filteredCards) {
            int insuranceId = card['insurance_id'];
            bool primaryUserOwnership = insuranceCustomerIds[insuranceId]
                    ?.contains(data['primaryUserId']) ??
                false;

            // Add primaryUserOwnership to the card map
            card['primaryUserOwnership'] = primaryUserOwnership;
            print(
                "primaryUserOwnership: $primaryUserOwnership for ${card['insurance_id']}");
            print("----------------------");
          }

          setState(() {
            primaryUserId = data['primaryUserId'];
            addedCards = filteredCards;
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load cards: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cards: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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

              // Show loading animation while fetching cards
              _isLoading
                  ? Center(
                      child: LoadingAnimationWidget.halfTriangleDot(
                        color: const Color.fromARGB(255, 243, 107, 33),
                        size: 30,
                      ),
                    )
                  : addedCards.isEmpty
                      ? const Text(
                          "No cards added yet.",
                          style: TextStyle(color: Colors.grey),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: addedCards.length,
                                itemBuilder: (context, index) {
                                  final card = addedCards[index];
                                  return checkingRequirements(
                                      card, card['primaryUserOwnership']);
                                },
                              );
                            } else {
                              const fixedHeight = 240.0;
                              final screenWidth = constraints.maxWidth;
                              const crossAxisCount = 2;
                              const crossAxisSpacing = 10.0;
                              const mainAxisSpacing = 10.0;

                              final availableWidthForItems = screenWidth -
                                  (crossAxisSpacing * (crossAxisCount - 1));
                              final itemWidth =
                                  availableWidthForItems / crossAxisCount;
                              final childAspectRatio = itemWidth / fixedHeight;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisSpacing: crossAxisSpacing,
                                  mainAxisSpacing: mainAxisSpacing,
                                ),
                                itemCount: addedCards.length,
                                itemBuilder: (context, index) {
                                  final card = addedCards[index];
                                  return checkingRequirements(
                                      card, card['primaryUserOwnership']);
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

  Widget checkingRequirements(
      Map<String, dynamic> card, bool primaryUserOwnership) {
    int cardId = card['insurance_id'];
    bool isRevealed = card['is_revealed'] == 1;
    bool primaryUserOwnership = card['primaryUserOwnership'] ?? false;
    print("-------------------");
    print("Processing insurance card: $cardId, Is Revealed: $isRevealed");
    print("-------------------");
    bool isPrimaryUserPage = primaryUserId == card['customers_id'] &&
        primaryUserId == widget.customerId;

    // bool isPrimaryUserCardInConnection =
    //     !isPrimaryUserPage && primaryUserId == card['customers_id'];
    bool isPrimaryUserCardInConnection =
        !isPrimaryUserPage && primaryUserOwnership;

    bool shouldApplySpecialChanges =
        !isPrimaryUserPage && isPrimaryUserCardInConnection;

    print("isPrimaryUserPage: $isPrimaryUserPage");
    print("isPrimaryUserCardInConnection: $isPrimaryUserCardInConnection");
    print("shouldApplySpecialChanges: $shouldApplySpecialChanges");
    print("isRevealed: $isRevealed");
    print("primaryUserOwnership: $primaryUserOwnership");

    return _buildCardItem(
      card,
      isPrimaryUserPage,
      isPrimaryUserCardInConnection,
      shouldApplySpecialChanges,
      isRevealed,
      primaryUserOwnership,
    );
  }

  Widget _buildCardItem(
    Map<String, dynamic> card,
    bool isPrimaryUserPage,
    bool isPrimaryUserCardInConnection,
    bool shouldApplySpecialChanges,
    bool isRevealed,
    bool primaryUserOwnership,
  ) {
    print("-------------------");
    print("Building card item...");

    print("Insurance ID: ${card['insurance_id']}");
    print("Customer ID: ${card['customers_id']}");
    print("isPrimaryUserPage: $isPrimaryUserPage");
    print("primaryUserOwnership: $primaryUserOwnership");
    print("isPrimaryUserCardInConnection: $isPrimaryUserCardInConnection");
    print("shouldApplySpecialChanges: $shouldApplySpecialChanges");
    print("Is Revealed: $isRevealed");

    return Container(
      height: 250.0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: shouldApplySpecialChanges
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 38, 40, 38),
                  Color.fromARGB(255, 0, 128, 0)
                ],
              )
            : const LinearGradient(
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
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            //Apply blur effect if not revealed
            if (shouldApplySpecialChanges && !isRevealed)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
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
              bottom: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (shouldApplySpecialChanges && !isRevealed)
                    IconButton(
                      onPressed: () {
                        _showRequestOtpDialog(
                            card['insurance_id'], widget.customerId);
                      },
                      icon: const Icon(Icons.add, color: Colors.green),
                    )
                  else if (shouldApplySpecialChanges && isRevealed)
                    IconButton(
                      onPressed: () {
                        _confirmCardHide(
                            card['insurance_id'], widget.customerId);
                      },
                      icon: const Icon(Icons.remove, color: Colors.orange),
                    )
                  else ...[
                    IconButton(
                      onPressed: () {
                        _showEditDialog(card);
                      },
                      icon: const Icon(Icons.edit, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(card['insurance_id']);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestOtpDialog(int cardId, int customerId) {
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
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.orange, // Orange to indicate verification
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.security,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "OTP Verification Required",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange, // Matching the icon color
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Need to verify for the primary user confirmation. Request an OTP to proceed.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // Grey for "Cancel"
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.orange, // Orange for "Request OTP"
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          _generateOtp(cardId, customerId); // Request OTP
                        },
                        child: const Text(
                          "Request OTP",
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

  Future<void> _handlePlusButtonAction(int cardId, int customerId) async {
    print("-----------");
    print("Plus button clicked for card ID: $cardId customer id: $customerId");
    print("-----------");
    // Perform the HTTP request first
    // final url = Uri.parse(
    //     "http://192.168.8.100/flutter_project_hayleys/php/employer_insurance_card.php");
    final url = Uri.parse(
      "${Config.baseUrl}insurance/employer_insurance_card.php",
    );

//172.16.200.79
    final response = await http.post(url, body: {
      'action': 'REVEAL', // Send action as "REVEAL"
      'insurance_id': cardId.toString(),
      'customers_id': customerId.toString(), // Use customers_id here
    });

    // Print the response status and body for debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      // Parse response if you want to handle the updated `is_revealed` value
      final data = jsonDecode(response.body);
      int isRevealed = data['is_revealed'];

      if (isRevealed == 1) {
        setState(() {
          revealedCards
              .add(cardId); // Reveal the card if the response indicates success
        });
        print("Card revealed successfully");

        // ✅ Fetch the updated card list immediately
        await _fetchAddedCards();
      } else {
        print("Failed to reveal card due to unexpected response");
      }
    } else {
      print("Failed to reveal card");
    }
  }

  Future<void> _handleMinusButtonAction(int cardId, int customerId) async {
    print("-----------");
    print("Minus button clicked for card ID: $cardId customer id: $customerId");
    print("-----------");

    // final url = Uri.parse(
    //     "http://192.168.8.100/flutter_project_hayleys/php/employer_insurance_card.php");
    final url = Uri.parse(
      "${Config.baseUrl}insurance/employer_insurance_card.php",
    );

    final response = await http.post(url, body: {
      'action': 'HIDE', // Send action as "HIDE"
      'insurance_id': cardId.toString(),
      'customers_id': customerId.toString(),
    });

    // Print the response status and body for debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int isRevealed = data['is_revealed'];

      if (isRevealed == 0) {
        setState(() {
          revealedCards.remove(cardId); // Hide the card only after confirmation
        });
        print("Card hidden successfully");

        // ✅ Fetch the updated card list immediately
        await _fetchAddedCards();
      } else {
        print("Failed to hide card due to unexpected response");
      }
    } else {
      print("Failed to hide card");
    }
  }

  // void _confirmCardReveal(int cardId, int customerId) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(20.0),
  //           child: SizedBox(
  //             width: 300, // Fixed width for the dialog
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   decoration: const BoxDecoration(
  //                     color: Colors.orange, // Orange for a neutral tone
  //                     shape: BoxShape.circle,
  //                   ),
  //                   padding: const EdgeInsets.all(16),
  //                   child: const Icon(
  //                     Icons.info,
  //                     size: 60,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 const Text(
  //                   "Confirm Action",
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.orange, // Match icon color
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 const Text(
  //                   "Are you sure you want to reveal this insurance card? Once revealed, it will be visible to the employer.",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontSize: 16, color: Colors.black),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.red,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.of(context).pop(); // Close the dialog
  //                       },
  //                       child: const Text(
  //                         "Cancel",
  //                         style: TextStyle(fontSize: 16, color: Colors.white),
  //                       ),
  //                     ),
  //                     ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color(0xFF00C853), // Green
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.of(context).pop(); // Close the dialog
  //                         _handlePlusButtonAction(
  //                             cardId, customerId); // Proceed
  //                       },
  //                       child: const Text(
  //                         "Reveal",
  //                         style: TextStyle(fontSize: 16, color: Colors.white),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // FOR THE OTP ENTER

  // void _confirmCardReveal(int cardId, int customerId) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       List<TextEditingController> otpControllers =
  //           List.generate(6, (index) => TextEditingController());

  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(20.0),
  //           child: SizedBox(
  //             width: 300, // Fixed width for the dialog
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   decoration: const BoxDecoration(
  //                     color: Colors.orange,
  //                     shape: BoxShape.circle,
  //                   ),
  //                   padding: const EdgeInsets.all(16),
  //                   child: const Icon(
  //                     Icons.info,
  //                     size: 60,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 const Text(
  //                   "Enter OTP",
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.orange,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Text(
  //                   "Please enter the 6-digit OTP sent to the registered mobile number of your primary user ${widget.phoneNo}.",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontSize: 16, color: Colors.black),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: List.generate(6, (index) {
  //                     return Container(
  //                       width: 40,
  //                       margin: const EdgeInsets.symmetric(horizontal: 5),
  //                       child: TextField(
  //                         controller: otpControllers[index],
  //                         keyboardType: TextInputType.number,
  //                         textAlign: TextAlign.center,
  //                         maxLength: 1,
  //                         style: const TextStyle(fontSize: 18),
  //                         decoration: const InputDecoration(
  //                           counterText: "",
  //                           border: OutlineInputBorder(),
  //                         ),
  //                         onChanged: (value) {
  //                           if (value.isNotEmpty && index < 5) {
  //                             FocusScope.of(context).nextFocus();
  //                           }
  //                         },
  //                       ),
  //                     );
  //                   }),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.red,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.of(context).pop(); // Close the dialog
  //                       },
  //                       child: const Text(
  //                         "Cancel",
  //                         style: TextStyle(fontSize: 16, color: Colors.white),
  //                       ),
  //                     ),
  //                     ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color(0xFF00C853),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       onPressed: () {
  //                         String otp = otpControllers.map((c) => c.text).join();
  //                         if (otp.length == 6) {
  //                           Navigator.of(context).pop(); // Close the dialog
  //                           _handlePlusButtonAction(cardId, customerId);
  //                         } else {
  //                           // Show error message or alert
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                                 content: Text("Enter complete OTP")),
  //                           );
  //                         }
  //                       },
  //                       child: const Text(
  //                         "Verify",
  //                         style: TextStyle(fontSize: 16, color: Colors.white),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _generateOtp(int cardId, int customerId) async {
    print("Requesting OTP for phone number: ${widget.phoneNo}");

    final url =
        Uri.parse("${Config.baseUrl}insurance/otp_insurance_card_reveal.php");

    final response = await http.post(url, body: {
      'action': 'generate',
      'phoneno': widget.phoneNo,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String status = data['status'];

      if (status == 'exists') {
        print("OTP sent to ${widget.phoneNo}");
        _confirmCardReveal(cardId, customerId); // Show Enter OTP dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Failed to send OTP. Please try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error requesting OTP.")),
      );
    }
  }

  Future<void> _verifyOtp(int cardId, int customerId, String otp) async {
    print("Verifying OTP for card ID: $cardId, customer ID: $customerId");

    final url = Uri.parse("${Config.baseUrl}otp_insurance_card_reveal.php");

    final response = await http.post(url, body: {
      'action': 'verify',
      'phoneno': widget.phoneNo,
      'otp': otp,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String status = data['status'];

      if (status == 'success') {
        print("✅ OTP verified successfully!");

        // 🔹 Show Success Dialog
        _showVerificationSuccessDialog(cardId, customerId);

        // 🔹 Call the plus button action after OTP is verified
        await _handlePlusButtonAction(cardId, customerId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Invalid OTP. Please try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Failed to verify OTP.")),
      );
    }
  }

  void _showVerificationSuccessDialog(int cardId, int customerId) {
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
                    color: Color(0xFF00C853), // Green color for success
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
                  "Verification Successful!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C853), // Green color for success
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your OTP has been verified successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
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
                    // Optionally, navigate to the next screen or perform an action
                  },
                  child: const Text(
                    "OK",
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

  void _confirmCardReveal(int cardId, int customerId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        List<TextEditingController> otpControllers =
            List.generate(6, (index) => TextEditingController());

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900, // ✅ Remove 'const'
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      Icons.security,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Enter OTP",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900, // ✅ Remove 'const'
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter the 6-digit OTP sent to ${widget.phoneNo}.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          controller: otpControllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue.shade900,
                                  width: 2), // ✅ Remove 'const'
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue.shade900, // ✅ Remove 'const'
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          String otp = otpControllers.map((c) => c.text).join();
                          if (otp.length == 6) {
                            Navigator.of(context).pop();
                            _verifyOtp(cardId, customerId, otp);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Invalid OTP"),
                                content: const Text(
                                    "Please enter all 6 digits of the OTP."),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Verify",
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

  void _confirmCardHide(int cardId, int customerId) {
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
                      color: Colors.red, // Red to indicate removal
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Confirm Action",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red, // Match icon color
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure you want to hide this insurance card? Once hidden, it will no longer be visible for you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red for "Hide"
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _handleMinusButtonAction(
                              cardId, customerId); // Proceed
                        },
                        child: const Text(
                          "Hide",
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
                      color: Colors.red,
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
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
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
    // final url = Uri.parse(
    //     'http://192.168.8.100/flutter_project_hayleys/php/insurance_card.php');
    final url = Uri.parse(
      "${Config.baseUrl}insurance_card.php",
    );

    //172.16.200.79
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
        //"phone_no": widget.phoneNo,
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
        // final response = await http.post(
        //   Uri.parse(
        //       "http://192.168.8.100/flutter_project_hayleys/php/insurance_card.php"),
        //   //172.16.200.79
        //   headers: {
        //     "Content-Type": "application/x-www-form-urlencoded",
        //   },
        //   body: cardDetails,
        // );

        final response = await http.post(
          Uri.parse(
            "${Config.baseUrl}insurance_card.php",
          ),
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
        "Edit button pressed for insurance_id: ${card['insurance_id']} customers_id=${widget.customerId} ");

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
