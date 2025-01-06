// ADD THE DETAILS OF THE USER FOR THE OTHER MEMBERS TO THE SYSTEM
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

// 31/12/2024 CONNECT WITH THE USER_DETAILS.PHP CODE
import 'package:http/http.dart' as http;

class UserDetails extends StatefulWidget {
  // To accept the phone number - 03/01/2024
  final String phoneNo;

  //const UserDetails({super.key});

  // Modify constructor - 03/01/2024
  const UserDetails({super.key, required this.phoneNo});

  @override
  State<UserDetails> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetails> {
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

  @override
  void initState() {
    super.initState();

    // Print phone number to the terminal - 03/01/2024
    print('Logged in user phone number (user_details.dart): ${widget.phoneNo}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Member Details Form',
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
                        // Contact Number 1
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
                              'Central ',
                              'Eastern ',
                              'North Central ',
                              'Northern ',
                              'North Western ',
                              'Sabaragamuwa ',
                              'Southern ',
                              'Uva ',
                              'Western ',
                            ],
                            (value) => province = value,
                          ),
                        ),
                      ],
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
                            "Enter your NIC",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your NIC.";
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
                              return null; // NIC is valid
                            },
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
                            "Contact Number 2",
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
                        'Friend',
                        'Colleague',
                        'Neighbor',
                        'Guardian',
                        'Other',
                      ],
                      (value) => relationship = value,
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: MaterialButton(
                              onPressed: _addMember,
                              height: 50,
                              minWidth: MediaQuery.of(context).size.width * 0.4,
                              color: Colors.blue[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  "Add Member",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: MaterialButton(
                              onPressed: () => _showClearFormDialog(context),
                              height: 50,
                              minWidth: MediaQuery.of(context).size.width * 0.4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                  color: Colors.blue[800]!,
                                  width: 2.0,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "Clear Form",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 2, 99, 178),
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

  // This method submits the form
  Future<void> _addMember() async {
    if (_formKey.currentState!.validate()) {
      final userDetails = {
        "phone_no": widget.phoneNo,
        "customers_first_name": firstnameController.text,
        "customers_last_name": lastnameController.text,
        "customers_home_no": homeNoController.text,
        "customers_street_name": streetController.text,
        "customers_city": cityController.text,
        "customers_identification": nicController.text,
        "customers_dob": dobController.text,
        "customers_blood_group": customers_blood_group,
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
            // Show success dialog
            _showSuccessDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${jsonResponse['message']}")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error: Unable to submit form.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
        print("Error: $e");
      }
    }
  }

  void _showSuccessDialog() {
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
                  const Text(
                    "Member Added Successfully!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853), // Green color
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

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text("Form Submitted Successfully!")),
          // );
          // print("User Details: $userDetails");
        });
  }

  // Helper function to show a clear form dialog
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

  // This function clears all form fields
  void _clearForm() {
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
    setState(() {
      customers_blood_group = null;
      district = null;
      province = null;
      relationship = null;
      gender = null;
    });
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select $label.";
                    }
                    return null;
                  },
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
    Function(String?) onChanged, {
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
          GestureDetector(
            onTap: () {},
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
              child: DropdownButtonFormField<String>(
                value: currentValue,
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
                dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                elevation: 8,
                menuMaxHeight: 500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Label
          Text(
            label,
            style: TextStyle(fontSize: 12, color: labelColor),
          ),
        ],
      ),
    );
  }
}
