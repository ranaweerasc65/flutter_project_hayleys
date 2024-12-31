// ADD THE DETAILS OF THE USER FOR THE OTHER MEMBERS TO THE SYSTEM

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

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

  String? bloodGroup;
  String? district;
  String? province;
  String? relationship;
  String? gender;

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
      bloodGroup = null;
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
                    bloodGroup,
                    ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                    (value) => bloodGroup = value,
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
  void _addMember() {
    if (_formKey.currentState!.validate()) {
      final userDetails = {
        "name": nameController.text,
        "homeno": homeNoController.text,
        "street": streetController.text,
        "city": cityController.text,
        "nic": nicController.text,
        "dob": dobController.text,
        "bloodGroup": bloodGroup,
        "gender": gender,
        "contact1": contact1Controller.text,
        "contact2": contact2Controller.text,
        "district": district,
        "province": province,
        "occupation": occupationController.text,
        "relationship": relationship,
      };
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form Submitted Successfully!")),
      );
      print("User Details: $userDetails");
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
      bloodGroup = null;
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
