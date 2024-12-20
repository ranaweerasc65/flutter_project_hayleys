// 20/12/2024 UI DESIGN DONE FOR THE USER DETAILS FORM

import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetails> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController contact1Controller = TextEditingController();
  final TextEditingController contact2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();

  String? bloodGroup;
  String? district;
  String? province;
  String? relationship;
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details Form',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("Name", nameController, "Enter your name"),
              buildDatePickerField(
                  "Date of Birth", dobController, "Select your DOB"),
              buildTextField(
                  "Address", addressController, "Enter your address"),
              buildTextField("NIC", nicController, "Enter your NIC"),
              buildDropdownField(
                  "Gender",
                  gender,
                  ['Male', 'Female', 'Not prefer to say'],
                  (value) => gender = value),
              buildDropdownField(
                  "Blood Group",
                  bloodGroup,
                  ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                  (value) => bloodGroup = value),
              buildTextField("Contact Number 1", contact1Controller,
                  "Enter your primary contact number",
                  keyboardType: TextInputType.phone),
              buildTextField("Contact Number 2", contact2Controller,
                  "Enter your secondary contact number",
                  keyboardType: TextInputType.phone),
              buildDropdownField(
                  "District",
                  district,
                  ['District 1', 'District 2', 'District 3'],
                  (value) => district = value),
              buildDropdownField(
                  "Province",
                  province,
                  ['Province 1', 'Province 2', 'Province 3'],
                  (value) => province = value),
              buildTextField("City", cityController, "Enter your city"),
              buildTextField(
                  "Country", countryController, "Enter your country"),
              buildTextField(
                  "Occupation", occupationController, "Enter your occupation"),
              buildDropdownField(
                  "Relationship",
                  relationship,
                  ['Single', 'Married', 'Other'],
                  (value) => relationship = value),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget buildDropdownField(String label, String? currentValue,
      List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final userDetails = {
        "name": nameController.text,
        "address": addressController.text,
        "nic": nicController.text,
        "dob": dobController.text,
        "bloodGroup": bloodGroup,
        "gender": gender,
        "contact1": contact1Controller.text,
        "contact2": contact2Controller.text,
        "district": district,
        "province": province,
        "city": cityController.text,
        "country": countryController.text,
        "occupation": occupationController.text,
        "relationship": relationship,
      };
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form Submitted Successfully!")),
      );
      print("User Details: $userDetails");
    }
  }
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
