import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/config.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DoctorTable extends StatefulWidget {
  final int customerId;
  final Function onDoctorAdded;
  final int? illnessId;

  const DoctorTable({
    super.key,
    required this.customerId,
    required this.onDoctorAdded,
    this.illnessId,
  });

  @override
  _DoctorTableState createState() => _DoctorTableState();
}

class _DoctorTableState extends State<DoctorTable> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorContactNumberController =
      TextEditingController();
  final TextEditingController doctorHospitalNameController =
      TextEditingController();

  String? doctorSpecialization;

  List<String> doctorSpecializationOptions = [
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
    'Urologist (Urinary & Kidney Specialist)'
  ];

  List<Map<String, dynamic>> _doctorsData = [];

  int doctorsCount = 0;

  @override
  void initState() {
    super.initState();

    print('---------------------');
    print('Doctor Table for Customer ID: ${widget.customerId}');

    _fetchAddedRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/background_img.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          _isLoading
              ? Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: Colors.blue.shade800,
                    size: 30,
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        _fetchAddedRecords();
                      },
                      child: _doctorsData.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  "No records found",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black54),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.3),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minWidth: constraints.maxWidth),
                                          child: DataTable(
                                            headingRowColor:
                                                MaterialStateProperty.all(
                                                    Colors.blue.shade800),
                                            dataRowColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            columnSpacing: 20,
                                            columns: const [
                                              DataColumn(
                                                  label: Text('Doctor ID',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Illness ID',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Doctor Name',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Specialization',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Contact Number',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Hospital Name',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Actions',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                            ],
                                            rows: _doctorsData.map((doctor) {
                                              return DataRow(cells: [
                                                DataCell(Text(
                                                    doctor['DOCTOR_ID']
                                                            ?.toString() ??
                                                        'Not Specified')),
                                                DataCell(Text(
                                                    doctor['ILLNESS_ID']
                                                            ?.toString() ??
                                                        'Not Specified')),
                                                DataCell(Text(
                                                    doctor['DOCTOR_NAME'] ??
                                                        'N/A')),
                                                DataCell(
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      color: _getSpecializationColor(
                                                          doctor[
                                                              'DOCTOR_SPECIALIZATION']),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      doctor['DOCTOR_SPECIALIZATION'] ??
                                                          'N/A',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(Text(doctor[
                                                        'DOCTOR_CONTACT_NUMBER'] ??
                                                    'N/A')),
                                                DataCell(Text(doctor[
                                                        'DOCTOR_HOSPITAL_NAME'] ??
                                                    'N/A')),
                                                DataCell(
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.edit,
                                                            color:
                                                                Colors.green),
                                                        onPressed: () {
                                                          _editDoctor(doctor);
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red),
                                                        onPressed: () {
                                                          _showDeleteConfirmationDialog(
                                                              doctor[
                                                                  'DOCTOR_ID']);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]);
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  void _editDoctor(Map<String, dynamic> doctor) {
    print(
        "Edit button pressed for doctor Id: ${doctor['DOCTOR_ID']} customers_id=${widget.customerId} illness_id: ${doctor['ILLNESS_ID']}");

    print("Updating doctor details: $doctor");

    doctorNameController.text = doctor['DOCTOR_NAME'] ?? '';
    doctorContactNumberController.text = doctor['DOCTOR_CONTACT_NUMBER'] ?? '';
    doctorHospitalNameController.text = doctor['DOCTOR_HOSPITAL_NAME'] ?? '';
    doctorSpecialization = doctor['DOCTOR_SPECIALIZATION'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                      // Header Section
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
                                "Edit Doctor Record",
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
                                  Navigator.of(context).pop();
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

                      const SizedBox(height: 16),
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
                                      buildLabel("Doctor Name"),
                                      buildTextField(
                                        doctorNameController,
                                        "",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Doctor Specialization",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      buildDropdownField(
                                        "Doctor Specialization",
                                        doctorSpecialization,
                                        [
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
                                          'Urologist (Urinary & Kidney Specialist)'
                                        ],
                                        (value) => doctorSpecialization = value,
                                        isMandatory: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            buildLabel("Doctor Contact Number "),
                            buildTextField(doctorContactNumberController, ""),
                            const SizedBox(height: 8),
                            const SizedBox(height: 8),
                            buildLabel("Doctor Hospital Name "),
                            buildTextField(doctorHospitalNameController, ""),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: MaterialButton(
                                    onPressed: () {
                                      _showConfirmationDialog(
                                          doctor['DOCTOR_ID'],
                                          doctor['ILLNESS_ID']);
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

  void _showDeleteConfirmationDialog(int doctorId) {
    print("Delete Button pressed for $doctorId");
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
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure you want to delete this Doctor Record?",
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
                          print("Doctor Id at delete: $doctorId");

                          try {
                            final response = await deleteDoctorRecord(doctorId);

                            print("Response from API: $response");

                            if (response['status'] == 'success') {
                              _fetchAddedRecords();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Failed to delete doctor record: ${response['message']}"),
                                ),
                              );
                            }
                          } catch (e) {
                            print("Error deleting doctor record: $e");
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

  Future<Map<String, dynamic>> deleteDoctorRecord(int doctorId) async {
    final url = Uri.parse(
      "${Config.baseUrl}doctor.php",
    );

    final response = await http.post(
      url,
      body: {
        'action': 'delete',
        'doctor_id': doctorId.toString(),
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete doctor record');
    }
  }

  Future<void> _addRecord() async {
    print('-----------------');
    print('ADD DOCTOR FUNCTION STARTED');

    print("Checking illnessId in DoctorTable: ${widget.illnessId}");

    if (_formKey.currentState!.validate()) {
      print('Form validation passed');

      final recordDetails = {
        "customers_id": widget.customerId.toString(),
        "doctor_name": doctorNameController.text,
        "doctor_specialization": doctorSpecialization,
        "doctor_contact_number": doctorContactNumberController.text,
        "doctor_hospital_name": doctorHospitalNameController.text,
        "illness_id": widget.illnessId.toString(),
      };

      print('Record Details: $recordDetails');

      try {
        print('Sending HTTP request to: ${Config.baseUrl}doctor.php');
        final response = await http.post(
          Uri.parse("${Config.baseUrl}doctor.php"),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: recordDetails,
        );

        print('Response received. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          print('Parsed JSON Response: $jsonResponse');

          if (jsonResponse['status'] == 'success') {
            final doctorId = jsonResponse['doctor_id'];
            print('Doctor ID: $doctorId');

            _showSuccessDialog(
                'Doctor record added successfully\nDoctor ID: $doctorId',
                doctorId);

            widget.onDoctorAdded();
            print('Doctor added successfully, refreshing records...');

            _fetchAddedRecords();
          } else {
            print('Server Response Error: ${jsonResponse['message']}');
            _showErrorDialog(
                jsonResponse['message'] ?? "An unknown error occurred.");
          }
        } else {
          print('Server returned an error: ${response.statusCode}');
          _showErrorDialog("Server returned an error: ${response.statusCode}");
        }
      } catch (e) {
        print("Exception caught: $e");
        _showErrorDialog("An error occurred: $e");
      }
    } else {
      print('Form validation failed');
    }
    print('ADD DOCTOR FUNCTION ENDED');
  }

  Future<void> _fetchAddedRecords() async {
    print("Fetching Doctor Records for ${widget.customerId}");

    setState(() {
      _isLoading = true;
    });

    try {
      final url =
          "${Config.baseUrl}fetch_doctor_data.php?customer_id=${widget.customerId}";
      print("Request URL: $url");

      final response = await http.get(Uri.parse(url));
      print("Response received with status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Response Body: ${response.body}");

        if (jsonResponse['status'] == 'success') {
          final List<dynamic>? doctor = jsonResponse['doctor'];
          print("Fetched doctor data: $doctor");

          setState(() {
            _doctorsData = (doctor != null && doctor.isNotEmpty)
                ? List<Map<String, dynamic>>.from(doctor)
                : [];
            print(
                "Doctors data fetched. Current count: ${_doctorsData.length}");
          });
        } else {
          setState(() {
            _doctorsData = [];
          });
          print("No doctor records found or error in response data.");
        }
      } else {
        print(
            "Error: Server returned an error with status code: ${response.statusCode}");
        _showErrorDialog("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
      _showErrorDialog("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String message, int customerId) {
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
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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
                    color: Colors.red,
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

  Widget buildDropdownField(
    String label,
    String? currentValue,
    List<String> options,
    Function(String?) onChanged, {
    bool isMandatory = false,
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
        ],
      ),
    );
  }

  Widget buildDatePickerField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isMandatory = false,
    Color hintColor = const Color(0xFFB0BEC5),
    Color borderColor = const Color(0xFFCFD8DC),
    Color labelColor = const Color(0xFF78909C),
    Color focusedBorderColor = const Color(0xFF607D8B),
    Color selectedColor = const Color.fromARGB(255, 5, 101, 180),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Default to today
                firstDate: DateTime.now(), // Disallow past dates
                lastDate: DateTime(2101), // Allow dates far in the future
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: selectedColor,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: selectedColor,
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
        ],
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
                errorText: errorMessage,
              ),
              keyboardType: keyboardType,
              validator: validator,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget buildLabel(String labelText) {
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

  Future<void> _showConfirmationDialog(int doctorId, int illnessId) async {
    print(
        "Confirm for updating doctor id: $doctorId for illness id: $illnessId");
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
                      color: Colors.orange,
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
                      color: Colors.orange,
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
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _saveDetails(doctorId, illnessId);
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

  Future<void> _saveDetails(int? doctorId, int illnessId) async {
    print("Save updates for doctor id: $doctorId for illness id: $illnessId");
    if (_formKey.currentState!.validate()) {
      // Debug print for form validation
      print('Form is valid. Proceeding with saving doctor details.');

      final recordDetails = {
        "customers_id": widget.customerId.toString(),
        "doctor_name": doctorNameController.text,
        "doctor_specialization": doctorSpecialization,
        "doctor_contact_number": doctorContactNumberController.text,
        "doctor_hospital_name": doctorHospitalNameController.text,
        "illness_id": illnessId.toString(),
      };

      if (doctorId != null) {
        recordDetails["doctor_id"] = doctorId.toString();
      }

      print('Doctor Record Details: $recordDetails');

      try {
        final response = await http.post(
          Uri.parse("${Config.baseUrl}doctor.php"),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: recordDetails,
        );

        print('Response when updating: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);

          print('Parsed JSON Response: $jsonResponse');

          if (jsonResponse['status'] == 'success') {
            final updatedDoctorId = jsonResponse['doctor_id'];

            print('Updated Doctor ID: $updatedDoctorId');
            _showSuccessDialog(
                'Doctor details updated successfully\nDoctor ID: $updatedDoctorId',
                updatedDoctorId);
            _fetchAddedRecords();
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
    } else {
      print('Form is invalid. Please check the input fields.');
    }
  }
}

Color _getSpecializationColor(String specialization) {
  switch (specialization) {
    case 'Cardiologist (Heart Specialist)':
      return Colors.red;
    case 'Dermatologist (Skin Specialist)':
      return Colors.pink;
    case 'Endocrinologist (Hormone Specialist)':
      return Colors.purple;
    case 'Gastroenterologist (Stomach & Digestive Specialist)':
      return Colors.brown;
    case 'Hematologist (Blood Specialist)':
      return Colors.deepOrange;
    case 'Neurologist (Brain & Nerve Specialist)':
      return Colors.blue;
    case 'Oncologist (Cancer Specialist)':
      return Colors.green;
    case 'Ophthalmologist (Eye Specialist)':
      return Colors.teal;
    case 'Orthopedic Surgeon (Bone & Joint Specialist)':
      return Colors.indigo;
    case 'Pediatrician (Children’s Specialist)':
      return Colors.cyan;
    case 'Psychiatrist (Mental Health Specialist)':
      return Colors.deepPurple;
    case 'Pulmonologist (Lung Specialist)':
      return Colors.lightBlue;
    case 'Radiologist (Medical Imaging Specialist)':
      return Colors.grey;
    case 'Rheumatologist (Arthritis & Joint Pain Specialist)':
      return Colors.amber;
    case 'Urologist (Urinary & Kidney Specialist)':
      return Colors.blueGrey;
    default:
      return Colors.orange;
  }
}
