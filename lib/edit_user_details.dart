import 'package:flutter_project_hayleys/home_page.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditUserDetails extends StatefulWidget {
  final int customerId;
  final String phoneNo;
  final String userName;

  const EditUserDetails({
    required this.customerId,
    required this.phoneNo,
    required this.userName,
  });

  @override
  _EditUserDetailsState createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController homeNoController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController contact1Controller = TextEditingController();
  final TextEditingController contact2Controller = TextEditingController();
  final TextEditingController occupationController = TextEditingController();

  String? customers_blood_group;
  String? district;
  String? province;
  String? relationship;
  String? gender;

  String? phoneNo;

  List<String> genderOptions = ['Male', 'Female', 'Not prefered to say'];

  List<String> districtOptions = [
    "Ampara",
    "Anuradhapura",
    "Badulla",
    "Batticaloa",
    "Colombo",
    "Galle",
    "Gampaha",
    "Hambantota",
    "Jaffna",
    "Kalutara",
    "Kandy",
    "Kegalle",
    "Kilinochchi",
    "Kurunegala",
    "Mannar",
    "Matale",
    "Matara",
    "Monaragala",
    "Mullaitivu",
    "Nuwara Eliya",
    "Polonnaruwa",
    "Puttalam",
    "Ratnapura",
    "Trincomalee",
    "Vavuniya"
  ];

  List<String> provinceOptions = [
    "Central",
    "Eastern",
    "Northern",
    "North Central",
    "North Western",
    "Sabaragamuwa",
    "Southern",
    "Uva",
    "Western"
  ];

  List<String> bloodGroupOptions = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-"
  ];
  List<String> relationshipOptions = [
    'Mother',
    'Father',
    'Spouse',
    'Sister',
    'Brother',
    'Daughter',
    'Son',

    // Second Connections
    'Grandmother',
    'Grandfather',
    'Aunt',
    'Uncle',
    'Niece',
    'Nephew',
    'Cousin',

    // Others

    'Guardian',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    print('edit_user_details.dart');

    // Print phone number to the terminal - 03/01/2024
    print('edit_Logged in user phone number : ${widget.phoneNo}');

    print('edit_Logged in user Username : ${widget.userName}');

    print('edit_Logged in user customer ID : ${widget.customerId} ');

    _fetchExistingDetails();
  }

  Future<void> _fetchExistingDetails() async {
    print('come to _fetchExistingDetails');
    print('Customer ID : ${widget.customerId} ');

    // Corrected URL with '&' for multiple query parameters
    final url = Uri.parse(
        "http://172.16.200.79/flutter_project_hayleys/php/fetch_user_details.php?phone_no=${widget.phoneNo}&CUSTOMERS_ID=${widget.customerId}");

    // Send the GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Response body _fetchExistingDetails: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        // Parse the existing data and populate the form fields
        var existingData = jsonResponse['customer_data'];

        setState(() {
          firstnameController.text = existingData['CUSTOMERS_FIRST_NAME'];
          lastnameController.text = existingData['CUSTOMERS_LAST_NAME'];
          dobController.text = existingData['CUSTOMERS_DOB'];
          cityController.text = existingData['CUSTOMERS_CITY'];

          district =
              districtOptions.contains(existingData['CUSTOMERS_DISTRICT'])
                  ? existingData['CUSTOMERS_DISTRICT']
                  : null;

          province = provinceOptions
                  .contains(existingData['CUSTOMERS_PROVINCE']?.trim())
              ? existingData['CUSTOMERS_PROVINCE']?.trim()
              : null;

          gender = genderOptions.contains(existingData['CUSTOMERS_GENDER'])
              ? existingData['CUSTOMERS_GENDER']
              : null;
          customers_blood_group =
              bloodGroupOptions.contains(existingData['CUSTOMERS_BLOOD_GROUP'])
                  ? existingData['CUSTOMERS_BLOOD_GROUP']
                  : null;

          relationship = relationshipOptions
                  .contains(existingData['CUSTOMERS_RELATIONSHIP'])
              ? existingData['CUSTOMERS_RELATIONSHIP']
              : null;

          contact1Controller.text =
              existingData['CUSTOMERS_CONTACT_NO1'].toString();
          contact2Controller.text =
              existingData['CUSTOMERS_CONTACT_NO2']?.toString() ?? "";
          nicController.text = existingData['CUSTOMERS_IDENTIFICATION'] ?? "";
          occupationController.text =
              existingData['CUSTOMERS_OCCUPATION'] ?? "";
          homeNoController.text = existingData['CUSTOMERS_HOME_NO'] ?? "";
          streetController.text = existingData['CUSTOMERS_STREET_NAME'] ?? "";
        });

        // Optionally, show a success message if needed
        //_showSuccessDialog("Existing member details fetched successfully.");
      } else {
        //_showErrorDialog(jsonResponse['message'] ?? "Failed to fetch details.");
      }
    } else {
      _showErrorDialog("Failed to fetch details. Please try again later.");
    }
  }

  Future<void> _refreshForm() async {
    setState(() {
      firstnameController.clear();
      lastnameController.clear();
      streetController.clear();
      homeNoController.clear();
      cityController.clear();
      nicController.clear();
      dobController.clear();
      contact1Controller.clear();
      contact2Controller.clear();
      occupationController.clear();
      customers_blood_group = null;
      district = null;
      province = null;
      relationship = null;
      gender = null;
    });
    await Future.delayed(const Duration(seconds: 1));
  }

  // Function to save the updated details
  Future<void> _saveDetails() async {
    print(' _saveDetails function');

// Mandatory fields to check
    final mandatoryFields = {
      "First Name": firstnameController.text,
      "Last Name": lastnameController.text,
      "Date of Birth": dobController.text,
      "City": cityController.text,
      "District": district,
      "Province": province,
      "Gender": gender,
      "Contact Number 1": contact1Controller.text,
      "Relationship": relationship,
    };

    // Check if any mandatory field is missing
    final missingFields = mandatoryFields.entries
        .where((entry) =>
            entry.value == null || entry.value.toString().trim().isEmpty)
        .map((entry) => entry.key)
        .toList();

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
        "customers_first_name": firstnameController.text,
        "customers_last_name": lastnameController.text,
        "customers_home_no": homeNoController.text,
        "customers_street_name": streetController.text,
        "customers_city": cityController.text,
        "customers_identification": nicController.text,
        "customers_dob": dobController.text,
        "customers_blood_group": customers_blood_group ?? "",
        "customers_gender": gender,
        "customers_contact_no1": contact1Controller.text,
        "customers_contact_no2": contact2Controller.text,
        "customers_district": district,
        "customers_province": province,
        "customers_occupation": occupationController.text,
        "customers_relationship": relationship,
      };

      // Print the user-entered details to the terminal for debugging
      print('User Details: $userDetails');

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
            final customerId =
                jsonResponse['customer_id']; // Extract customer_id
            print('Customer ID: $customerId');

            if (jsonResponse['message'] ==
                'Customer details updated successfully') {
              _showSuccessDialog('Customer details updated successfully');
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
          'Edit User Details',
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
              // onTap: () {
              //   _showExitConfirmationDialog(context);
              // },
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
      body: RefreshIndicator(
        onRefresh: _refreshForm,
        color: const Color.fromARGB(255, 8, 120, 212),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name title
                    const Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        // First Name
                        Expanded(
                          child: buildTextField(
                            "First Name",
                            firstnameController,
                            "",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: buildTextField(
                            "Last Name",
                            lastnameController,
                            "",
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      "Date of Birth",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        // DOB
                        Expanded(
                          child: buildDatePickerField(
                            "Date of Birth",
                            dobController,
                            "",
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      "Address",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        // First Name
                        Expanded(
                          child: buildTextField(
                            "Home No",
                            homeNoController,
                            "",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: buildTextField(
                            "Street Name",
                            streetController,
                            "",
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        // City
                        Expanded(
                          child: buildTextField(
                            "City",
                            cityController,
                            "",
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        // District
                        Expanded(
                          child: buildDropdownField(
                            "District",
                            district,
                            [
                              'Ampara',
                              'Anuradhapura',
                              'Badulla',
                              'Batticaloa',
                              'Colombo',
                              'Galle',
                              'Gampaha',
                              'Hambantota',
                              'Jaffna',
                              'Kalutara',
                              'Kandy',
                              'Kegalle',
                              'Kilinochchi',
                              'Kurunegala',
                              'Mannar',
                              'Matale',
                              'Matara',
                              'Monaragala',
                              'Mullaitivu',
                              'Nuwara Eliya',
                              'Polonnaruwa',
                              'Puttalam',
                              'Ratnapura',
                              'Trincomalee',
                              'Vavuniya',
                            ],
                            (value) => district = value,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Province
                        Expanded(
                          child: buildDropdownField(
                            "Province",
                            province,
                            [
                              'Central',
                              'Eastern',
                              'North Central',
                              'Northern',
                              'North Western',
                              'Sabaragamuwa',
                              'Southern',
                              'Uva',
                              'Western',
                            ],
                            (value) => province = value,
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      "Gender",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    buildDropdownField(
                      "Gender",
                      gender,
                      ['Male', 'Female', 'Not prefer to say'],
                      (value) => gender = value,
                    ),

                    const Text(
                      "Identification",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Row(
                    //   children: [
                    //     // NIC
                    //     Expanded(
                    //       child: buildTextField(
                    //         "NIC",
                    //         nicController,
                    //         "",
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    Row(
                      children: [
                        // NIC
                        Expanded(
                          child: buildTextField(
                            "NIC",
                            nicController,
                            "", // HINT
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }

                              // Check NIC format (Old or New format)
                              RegExp oldFormat = RegExp(
                                  r'^\d{9}[Vv]$'); // Old format: 9 digits followed by 'V' or 'v'
                              RegExp newFormat =
                                  RegExp(r'^\d{12}$'); // New format: 12 digits

                              if (!oldFormat.hasMatch(value) &&
                                  !newFormat.hasMatch(value)) {
                                return "Invalid NIC format.";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      "Blood Group",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    buildDropdownField(
                      "Blood Group",
                      customers_blood_group,
                      ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                      (value) => customers_blood_group = value,
                    ),

                    // Contact
                    const Text(
                      "Contact",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        // Contact Number 1
                        Expanded(
                          child: buildTextField(
                            "Contact Number 1",
                            contact1Controller,
                            "",
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Contact Number 2
                        Expanded(
                          child: buildTextField(
                            "Contact Number 2 (Optional)",
                            contact2Controller,
                            keyboardType: TextInputType.phone,
                            "",
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      "Occupation",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        // Occupation
                        Expanded(
                          child: buildTextField(
                            "Occupation",
                            occupationController,
                            "",
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      "Relationship",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    buildDropdownField(
                      "Relationship",
                      relationship,
                      [
                        // First Connections

                        'Mother',
                        'Father',
                        'Spouse',
                        'Sister',
                        'Brother',
                        'Daughter',
                        'Son',

                        // Second Connections
                        'Grandmother',
                        'Grandfather',
                        'Aunt',
                        'Uncle',
                        'Niece',
                        'Nephew',
                        'Cousin',

                        // Others

                        'Guardian',
                        'Other',
                      ],
                      (value) => relationship = value,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      //duration: const Duration(milliseconds: 1600),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: MaterialButton(
                              onPressed: _showConfirmationDialog,
                              height: 50,
                              minWidth: MediaQuery.of(context).size.width * 0.4,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(String message) {
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
                    // Navigate to the HomeScreen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          userName: widget.userName,
                          phoneNo: widget.phoneNo,
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

  // Function to show confirmation dialog
  // Function to show confirmation dialog
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
            child: Container(
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

  Widget buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
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
          // Label below the input field
          Text(
            label,
            style: TextStyle(fontSize: 12, color: labelColor),
          ),
        ],
      ),
    );
  }

  Widget buildDatePickerField(
    String label,
    TextEditingController controller,
    String hint, {
    Color hintColor = const Color(0xFFB0BEC5),
    Color borderColor = const Color(0xFFCFD8DC),
    Color labelColor = const Color(0xFF78909C),
    Color focusedBorderColor = const Color(0xFF607D8B),
    Color selectedColor =
        const Color.fromARGB(255, 5, 101, 180), // Blue color for selection
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker field
          GestureDetector(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary:
                            selectedColor, // Header background color (blue)
                        onPrimary: Colors.white, // Header text color
                        onSurface: Colors.black, // Body text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: selectedColor, // Button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (selectedDate != null) {
                controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
              }
            },
            child: AbsorbPointer(
              child: AnimatedContainer(
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
                  readOnly: true,
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
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Label below the input field
          Text(
            label,
            style: TextStyle(fontSize: 12, color: labelColor),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField(
    String label,
    String? currentValue,
    List<String> options,
    ValueChanged<String?> onChanged, {
    Key? fieldKey,
    Color focusedBorderColor = const Color(0xFF607D8B),
    Color borderColor = const Color(0xFFCFD8DC),
    Color labelColor = const Color(0xFF78909C),
    Color hintColor = const Color(0xFFB0BEC5),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown field
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
            child: DropdownButtonFormField<String>(
              key: fieldKey, // Ensures unique state for each dropdown
              value: currentValue, // Dynamically updates with fetched values
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: hintColor,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10.0,
                ),
              ),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                onChanged(value);
              },
              dropdownColor: Colors.white,
              elevation: 8,
              menuMaxHeight: 500,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select $label';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8),
          // Label below the dropdown field
          Text(
            label,
            style: TextStyle(fontSize: 14, color: labelColor),
          ),
        ],
      ),
    );
  }
}