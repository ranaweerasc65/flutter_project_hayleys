// ADD THE DETAILS OF THE USER FOR THE OTHER MEMBERS TO THE SYSTEM

import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

// 31/12/2024 CONNECT WITH THE USER_DETAILS.PHP CODE
import 'package:http/http.dart' as http;

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetails> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
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

  String? phoneNo; // 31/12/2024 Holds the phone number of the logged-in user

  @override

//31/12/2024
  // Future<void> _fetchLoggedUserPhoneNo() async {
  //   print('come to _fetchLoggedUserPhoneNo');
  //   try {
  //     print('come to _fetchLoggedUserPhoneNo - try block');

  //     final response = await http.get(
  //       Uri.parse("http://172.16.200.79/flutter_project_hayleys/php/login.php"),
  //     );

  //     if (response.statusCode == 200) {
  //       print('come to _fetchLoggedUserPhoneNo - try block - if');

  //       final data = jsonDecode(response.body);
  //       print(
  //           'come to _fetchLoggedUserPhoneNo - try block - if - after jsondecode');
  //       setState(() {
  //         phoneNo = data['phone_no']; // Assume the response contains `phone_no`
  //         print('Logged-in user phone number: ${data['phone_no']}');
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error: Unable to fetch phone number.")),
  //       );
  //     }
  //   } catch (e) {
  //     print('come to _fetchLoggedUserPhoneNo - catch block');

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: $e")),
  //     );
  //   }
  // }

  // Future<void> _loadAndFetchPhoneNo() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final phoneNumber = prefs.getString('loggedUserPhoneNo');
  //   final password = prefs.getString('loggedUserPassword');

  //   if (phoneNumber != null && password != null) {
  //     await _fetchLoggedUserPhoneNo(phoneNumber, password);
  //   } else {
  //     print('No saved login credentials found.');
  //   }
  // }

  // Future<void> _fetchLoggedUserPhoneNo(
  //     String phoneNumber, String password) async {
  //   print('Fetching logged-in user phone number...');
  //   try {
  //     final response = await http.post(
  //       Uri.parse("http://172.16.200.79/flutter_project_hayleys/php/login.php"),
  //       body: {
  //         'phone_no': phoneNumber,
  //         'password': password,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       if (data['status'] == 'success' && data.containsKey('phone_no')) {
  //         setState(() {
  //           phoneNo = data['phone_no'];
  //         });
  //         print('Logged-in user phone number: ${data['phone_no']}');
  //       } else {
  //         print('Error: ${data['message']}');
  //       }
  //     } else {
  //       print(
  //           'Error: Unable to fetch phone number. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
  // Future<void> _fetchLoggedUserPhoneNo() async {
  //   print('come to _fetchLoggedUserPhoneNo');
  //   try {
  //     print('come to _fetchLoggedUserPhoneNo - try block');

  //     final response = await http.post(
  //       Uri.parse("http://172.16.200.79/flutter_project_hayleys/php/login.php"),
  //       body: {
  //         'phone_no': '0710998878', // Replace with the actual phone number
  //         'password': 'qwerty', // Replace with the actual password
  //       },
  //     );

  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}'); // Log the raw response

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body); // Decode JSON response
  //       print('Decoded JSON: $data');

  //       if (data['status'] == 'success' && data.containsKey('phone_no')) {
  //         setState(() {
  //           phoneNo = data['phone_no']; // Save phone number
  //         });
  //         print('Logged-in user phone number: ${data['phone_no']}');
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(data['message'] ?? "Unknown error")),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error: Unable to fetch phone number.")),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: $e")),
  //     );
  //   }
  // }

  Future<void> _refreshForm() async {
    setState(() {
      nameController.clear();
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
        color: Colors.blue,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children: [
                  buildTextField("1. Name", nameController, "Enter your name"),
                  buildDatePickerField(
                      "2. Date of Birth", dobController, "Select your DOB"),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "3. Address",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: buildTextField("(a) Home No.", homeNoController,
                        "Enter your home no."),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: buildTextField("(b) Street Name", streetController,
                        "Enter your street name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: buildTextField(
                        "(c) City", cityController, "Enter your city"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: buildDropdownField(
                      "(d) District",
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
                      hintText: "Please select your district",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: buildDropdownField(
                      "(e) Province",
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
                      hintText: "Please select your province",
                    ),
                  ),
                  buildTextField("4. Identification", nicController,
                      "Enter your NIC number"),
                  buildDropdownField(
                    "5. Gender",
                    gender,
                    ['Male', 'Female', 'Not prefer to say'],
                    (value) => gender = value,
                    hintText: "Please select your gender",
                  ),
                  buildDropdownField(
                    "6. Blood Group",
                    customers_blood_group,
                    ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                    (value) => customers_blood_group = value,
                    hintText: "Please select your blood group",
                  ),
                  buildTextField("7. Contact Number 1", contact1Controller,
                      "Enter your primary contact number",
                      keyboardType: TextInputType.phone),
                  buildTextField("8. Contact Number 2", contact2Controller,
                      "Enter your secondary contact number",
                      keyboardType: TextInputType.phone),
                  buildTextField("9. Occupation", occupationController,
                      "Enter your occupation"),
                  buildDropdownField(
                    "10. Relationship",
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
                    hintText: "Please select relationship",
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
    );
  }

  // This method submits the form
  Future<void> _addMember() async {
    if (_formKey.currentState!.validate()) {
      final userDetails = {
        "customers_name": nameController.text,
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

      try {
        final response = await http.post(
          Uri.parse(
              "http://172.16.200.79/flutter_project_hayleys/php/user_details.php"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userDetails),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Form Submitted Successfully!")),
            );

            // After successful form submission, fetch phone number of logged-in user
            _fetchPhoneNumber();
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
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Form Submitted Successfully!")),
      // );
      // print("User Details: $userDetails");
    }
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
    nameController.clear();
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

  // Build text fields, dropdowns, and date pickers (existing code)
  Widget buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    Color hintColor = Colors.grey,
    Color focusedBorderColor = const Color.fromARGB(255, 2, 99, 178),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: hintColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: focusedBorderColor,
                    width: 2.0,
                  ),
                ),
              ),
              keyboardType: keyboardType,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter $label.";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDatePickerField(
    String label,
    TextEditingController controller,
    String hint, {
    Color hintColor = Colors.grey,
    Color focusedBorderColor = const Color.fromARGB(255, 2, 99, 178),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: hintColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: focusedBorderColor,
                    width: 2.0,
                  ),
                ),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  setState(() {
                    controller.text =
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select $label.";
                }
                return null;
              },
            ),
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
    Color focusedBorderColor = const Color.fromARGB(255, 2, 99, 178),
    String hintText = "Please select",
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: currentValue,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: focusedBorderColor,
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
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
                setState(() {
                  onChanged(value);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select $label.";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Function to fetch the phone number of the logged-in user
Future<void> _fetchPhoneNumber() async {
  print('come to _fetchPhoneNumber');

  try {
    final response = await http.get(Uri.parse(
        "http://172.16.200.79/flutter_project_hayleys/php/login.php"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Check if phone number is available in the response
      if (jsonResponse.containsKey('phone_no')) {
        final phoneNumber = jsonResponse['phone_no'];
        print(
            'Logged-in user phone number: $phoneNumber'); // Print phone number in the terminal
      } else {
        print('Error: Phone number not found.');
      }
    } else {
      print('Error: Unable to fetch phone number.');
    }
  } catch (e) {
    print('Error fetching phone number: $e');
  }
}
