// options.dart
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/dashboard/claim/submit_claim.dart';
import 'package:flutter_project_hayleys/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OptionsDialog extends StatelessWidget {
  final Map<String, dynamic> illness;
  final TabController tabController;
  final int customerId;

  const OptionsDialog({
    super.key,
    required this.illness,
    required this.tabController,
    required this.customerId,
  });

  void _showAddDoctorsForm(BuildContext parentContext) {
    final TextEditingController doctorNameController = TextEditingController();
    final TextEditingController doctorContactNumberController =
        TextEditingController();
    final TextEditingController doctorHospitalNameController =
        TextEditingController();
    String? doctorSpecialization;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    const List<String> doctorSpecializationOptions = [
      'Cardiologist (Heart Specialist)',
      'Dermatologist (Skin Specialist)',
      'Endocrinologist (Hormone Specialist)',
      'Gastroenterologist (Stomach & Digestive Specialist)',
      'Hematologist (Blood Specialist)',
      'Neurologist (Brain & Nerve Specialist)',
      'Oncologist (Cancer Specialist)',
      'Ophthalmologist (Eye Specialist)',
      'Orthopedic Surgeon (Bone & Joint Specialist)',
      'Pediatrician (Children’s Specialist)',
      'Psychiatrist (Mental Health Specialist)',
      'Pulmonologist (Lung Specialist)',
      'Radiologist (Medical Imaging Specialist)',
      'Rheumatologist (Arthritis & Joint Pain Specialist)',
      'Urologist (Urinary & Kidney Specialist)',
    ];

    Future<void> _addDoctor(BuildContext dialogContext) async {
      print('ADD DOCTOR for illness ${illness['ILLNESS_ID']} ');
      if (_formKey.currentState!.validate()) {
        print('Form validation passed');

        final recordDetails = {
          "customers_id": customerId.toString(),
          "doctor_name": doctorNameController.text,
          "doctor_specialization": doctorSpecialization,
          "doctor_contact_number": doctorContactNumberController.text,
          "doctor_hospital_name": doctorHospitalNameController.text,
          "illness_id": illness['ILLNESS_ID'].toString(),
        };

        print('Record Details: $recordDetails');

        try {
          final response = await http.post(
            Uri.parse("${Config.baseUrl}doctor.php"),
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: recordDetails,
          );

          print('Response received. Status Code: ${response.statusCode}');
          print('Response Body: ${response.body}');

          if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(response.body);
            if (jsonResponse['status'] == 'success') {
              final doctorId = jsonResponse['doctor_id'];
              print('Doctor ID: $doctorId');

              Navigator.pop(dialogContext);

              _showSuccessDialog(
                dialogContext,
                "Doctor added successfully!\nDoctor ID: $doctorId",
                customerId,
              );

              doctorNameController.clear();
              doctorContactNumberController.clear();
              doctorHospitalNameController.clear();
              doctorSpecialization = null;
            } else {
              print('Server Response Error: ${jsonResponse['message']}');
              _showErrorDialog(dialogContext,
                  "Server returned an error: ${response.statusCode}");
            }
          } else {
            print('Server returned an error: ${response.statusCode}');
          }
        } catch (e) {
          print("Exception caught: $e");
        }
      } else {
        print('Form validation failed');
      }
    }

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 5, 94, 166),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Add New Doctor",
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
                                  Navigator.of(dialogContext).pop();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
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
                      const SizedBox(height: 16),
                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel("Doctor Name"),
                                      _buildTextField(doctorNameController, ""),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel("Doctor Specialization"),
                                      _buildDropdownField(
                                        "Doctor Specialization",
                                        doctorSpecialization,
                                        doctorSpecializationOptions,
                                        (value) {
                                          setState(() {
                                            doctorSpecialization = value;
                                          });
                                        },
                                        isMandatory: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildLabel("Doctor Contact Number"),
                            _buildTextField(doctorContactNumberController, ""),
                            const SizedBox(height: 8),
                            _buildLabel("Doctor Hospital Name"),
                            _buildTextField(doctorHospitalNameController, ""),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _addDoctor(dialogContext),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    minimumSize: const Size(200, 50),
                                  ),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    doctorNameController.clear();
                                    doctorContactNumberController.clear();
                                    doctorHospitalNameController.clear();
                                    setState(() {
                                      doctorSpecialization = null;
                                    });
                                  },
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
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddPrescriptionForm(BuildContext parentContext) {
    final TextEditingController doctorNameController = TextEditingController();
    final TextEditingController doctorContactNumberController =
        TextEditingController();
    final TextEditingController doctorHospitalNameController =
        TextEditingController();
    String? doctorSpecialization;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    const List<String> doctorSpecializationOptions = [
      'Cardiologist (Heart Specialist)',
      'Dermatologist (Skin Specialist)',
      'Endocrinologist (Hormone Specialist)',
      'Gastroenterologist (Stomach & Digestive Specialist)',
      'Hematologist (Blood Specialist)',
      'Neurologist (Brain & Nerve Specialist)',
      'Oncologist (Cancer Specialist)',
      'Ophthalmologist (Eye Specialist)',
      'Orthopedic Surgeon (Bone & Joint Specialist)',
      'Pediatrician (Children’s Specialist)',
      'Psychiatrist (Mental Health Specialist)',
      'Pulmonologist (Lung Specialist)',
      'Radiologist (Medical Imaging Specialist)',
      'Rheumatologist (Arthritis & Joint Pain Specialist)',
      'Urologist (Urinary & Kidney Specialist)',
    ];

    Future<void> _addDoctor(BuildContext dialogContext) async {
      print('ADD DOCTOR for illness ${illness['ILLNESS_ID']} ');
      if (_formKey.currentState!.validate()) {
        print('Form validation passed');

        final recordDetails = {
          "customers_id": customerId.toString(),
          "doctor_name": doctorNameController.text,
          "doctor_specialization": doctorSpecialization,
          "doctor_contact_number": doctorContactNumberController.text,
          "doctor_hospital_name": doctorHospitalNameController.text,
          "illness_id": illness['ILLNESS_ID'].toString(),
        };

        print('Record Details: $recordDetails');

        try {
          final response = await http.post(
            Uri.parse("${Config.baseUrl}doctor.php"),
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: recordDetails,
          );

          print('Response received. Status Code: ${response.statusCode}');
          print('Response Body: ${response.body}');

          if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(response.body);
            if (jsonResponse['status'] == 'success') {
              final doctorId = jsonResponse['doctor_id'];
              print('Doctor ID: $doctorId');

              Navigator.pop(dialogContext);

              _showSuccessDialog(
                dialogContext,
                "Doctor added successfully!\nDoctor ID: $doctorId",
                customerId,
              );

              doctorNameController.clear();
              doctorContactNumberController.clear();
              doctorHospitalNameController.clear();
              doctorSpecialization = null;
            } else {
              print('Server Response Error: ${jsonResponse['message']}');
              _showErrorDialog(dialogContext,
                  "Server returned an error: ${response.statusCode}");
            }
          } else {
            print('Server returned an error: ${response.statusCode}');
          }
        } catch (e) {
          print("Exception caught: $e");
        }
      } else {
        print('Form validation failed');
      }
    }

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 5, 94, 166),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Add New Doctor",
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
                                  Navigator.of(dialogContext).pop();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
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
                      const SizedBox(height: 16),
                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel("Doctor Name"),
                                      _buildTextField(doctorNameController, ""),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel("Doctor Specialization"),
                                      _buildDropdownField(
                                        "Doctor Specialization",
                                        doctorSpecialization,
                                        doctorSpecializationOptions,
                                        (value) {
                                          setState(() {
                                            doctorSpecialization = value;
                                          });
                                        },
                                        isMandatory: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildLabel("Doctor Contact Number"),
                            _buildTextField(doctorContactNumberController, ""),
                            const SizedBox(height: 8),
                            _buildLabel("Doctor Hospital Name"),
                            _buildTextField(doctorHospitalNameController, ""),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _addDoctor(dialogContext),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    minimumSize: const Size(200, 50),
                                  ),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    doctorNameController.clear();
                                    doctorContactNumberController.clear();
                                    doctorHospitalNameController.clear();
                                    setState(() {
                                      doctorSpecialization = null;
                                    });
                                  },
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
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(
      BuildContext context, String message, int customerId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
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
                    color: Color(0xFF00C853),
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
                    color: Color(0xFF00C853),
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
                    Navigator.of(dialogContext).pop(); // Close success dialog
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

  void _showErrorDialog(BuildContext context, String errorMessage) {
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

  Widget _buildLabel(String labelText) {
    return Row(
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFCFD8DC),
            width: 1.0,
          ),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 10.0,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter $hint";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? currentValue,
    List<String> options,
    Function(String?) onChanged, {
    bool isMandatory = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFCFD8DC),
            width: 1.0,
          ),
        ),
        child: DropdownButtonFormField<String>(
          value: currentValue,
          decoration: const InputDecoration(
            hintStyle: TextStyle(
              color: Color(0xFFB0BEC5),
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
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
          onChanged: onChanged,
          validator: isMandatory
              ? (value) => value == null ? "Please select $label" : null
              : null,
          dropdownColor: Colors.white,
          elevation: 8,
          menuMaxHeight: 300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.person_add, color: Colors.green),
          title: const Text('Add Doctors'),
          onTap: () {
            Navigator.pop(context);
            print(
                "Click on Doctor Option for illness ${illness['ILLNESS_ID']}");
            _showAddDoctorsForm(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.receipt_long, color: Colors.orange),
          title: const Text('Add Prescriptions'),
          onTap: () {
            Navigator.pop(context);
            print(
                "Click on Prescriptions Option for illness ${illness['ILLNESS_ID']}");
            _showAddPrescriptionForm(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.insert_drive_file, color: Colors.purple),
          title: const Text('Add Reports'),
          onTap: () {
            Navigator.pop(context);
            print(
                "Click on Reports Option for illness ${illness['ILLNESS_ID']}");
          },
        ),
        ListTile(
          leading: const Icon(Icons.attach_money, color: Colors.teal),
          title: const Text('Add Bills'),
          onTap: () {
            Navigator.pop(context);
            print("Click on Bills Option for illness ${illness['ILLNESS_ID']}");
          },
        ),
        ListTile(
          leading: const Icon(Icons.folder, color: Colors.brown),
          title: const Text('Add Other Documents'),
          onTap: () {
            Navigator.pop(context);
            print(
                "Click on Other Documents Option for illness ${illness['ILLNESS_ID']}");
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 3, 106, 94),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              Navigator.pop(context);
              print(
                  "Click on Claim Option for illness ${illness['ILLNESS_ID']}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubmitClaim(
                    //  illnessId: illness['ILLNESS_ID'],
                    customerId: customerId,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Claim',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required Map<String, dynamic> illness,
    required TabController tabController,
    required int customerId,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => OptionsDialog(
        illness: illness,
        tabController: tabController,
        customerId: customerId,
      ),
    );
  }
}
