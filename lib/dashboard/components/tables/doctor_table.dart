import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/config.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:math';
import 'dart:ui';

class DoctorTable extends StatefulWidget {
  final int customerId;
  final Function onDoctorAdded;

  const DoctorTable({
    super.key,
    required this.customerId,
    required this.onDoctorAdded,
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

  List<String> illnessIds = [];
  String? selectedIllnessId;

  Future<void> _refreshData() async {
    setState(() {
      doctorNameController.clear();
      doctorContactNumberController.clear();
      doctorHospitalNameController.clear();

      doctorSpecialization = null;
    });
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();

    print('---------------------');
    print('Doctor Table for Customer ID: ${widget.customerId}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAddDoctorsForm(); // Show form immediately when page opens
    });

    _fetchAddedRecords();
    _fetchIllnessIDs();
  }

  void _showAddDoctorsForm() {
    doctorNameController.clear();
    doctorContactNumberController.clear();
    doctorHospitalNameController.clear();

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
                                "Add New Record",
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLabel("Illness ID"),
                                buildDropdownField(
                                  "Illness ID",
                                  selectedIllnessId,
                                  illnessIds,
                                  (value) =>
                                      setState(() => selectedIllnessId = value),
                                  isMandatory: true,
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: _addRecord,
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
                                  onPressed: () =>
                                      _showClearFormDialog(context),
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

  @override
  Widget build(BuildContext context) {
    return AnimatedWavesBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            _isLoading
                ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: Colors.purple.shade800,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 60),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
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
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text('Illness ID',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text('Doctor Name',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text(
                                                        'Specialization',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text(
                                                        'Contact Number',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text('Hospital Name',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text('Actions',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
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
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Text(
                                                        doctor['DOCTOR_SPECIALIZATION'] ??
                                                            'N/A',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
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
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.more_vert),
                                                      onPressed: () {
                                                        _showOptionsDialog(
                                                            doctor);
                                                      },
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
            Positioned(
              right: 10,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddDoctorsForm();
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add Doctor",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade800,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsDialog(Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editDoctor(doctor);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(doctor['DOCTOR_ID']);
              },
            ),
          ],
        );
      },
    );
  }

  void _editDoctor(Map<String, dynamic> doctor) {
    print(
        "Edit button pressed for doctor Id: ${doctor['DOCTOR_ID']} customers_id=${widget.customerId} ");

    print("Updating doctor details: $doctor");

    doctorNameController.text = doctor['DOCTOR_NAME'] ?? '';
    doctorContactNumberController.text = doctor['DOCTOR_CONTACT_NUMBER'] ?? '';
    doctorHospitalNameController.text = doctor['DOCTOR_HOSPITAL_NAME'] ?? '';
    doctorSpecialization = doctor['DOCTOR_SPECIALIZATION'];
    selectedIllnessId =
        doctor['ILLNESS_ID'] == null || doctor['ILLNESS_ID'] == 'Not Specified'
            ? 'Not Specified'
            : doctor['ILLNESS_ID'].toString();

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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLabel("Illness ID"),
                                buildDropdownField(
                                  "Illness ID",
                                  selectedIllnessId,
                                  illnessIds,
                                  (value) =>
                                      setState(() => selectedIllnessId = value),
                                  isMandatory: true,
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                                          doctor['DOCTOR_ID']);
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

    if (_formKey.currentState!.validate()) {
      print('Form validation passed');

      String illnessId =
          selectedIllnessId == "Not Specified" ? "NULL" : selectedIllnessId!;

      final recordDetails = {
        "customers_id": widget.customerId.toString(),
        "doctor_name": doctorNameController.text,
        "doctor_specialization": doctorSpecialization,
        "doctor_contact_number": doctorContactNumberController.text,
        "doctor_hospital_name": doctorHospitalNameController.text,
        "illness_id": illnessId, // Send illness_id here
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
        print("Response Body: ${response.body}"); // Print raw response body

        if (jsonResponse['status'] == 'success') {
          final List<dynamic>? doctor = jsonResponse['doctor'];
          print("Fetched doctor data: $doctor"); // Print fetched doctor data

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
        _fetchIllnessIDs();
      } else {
        print(
            "Error: Server returned an error with status code: ${response.statusCode}");
        _showErrorDialog("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e"); // Print exception details for debugging
      _showErrorDialog("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchIllnessIDs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url =
          "${Config.baseUrl}get_illness_count.php?customer_id=${widget.customerId}";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> illnesses = jsonResponse['illness_ids'];

          setState(() {
            illnessIds = ["Not Specified"];
            illnessIds.addAll(illnesses.map((id) => id.toString()));
          });

          print("Illness IDs fetched: $illnessIds");
        } else {
          print("Failed to fetch illness IDs: ${jsonResponse['message']}");
        }
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
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
    doctorNameController.clear();
    doctorContactNumberController.clear();
    doctorHospitalNameController.clear();

    setState(() {
      doctorSpecialization = null;
    });
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
    Color selectedColor =
        const Color.fromARGB(255, 5, 101, 180), // Blue color for selection
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

  Future<void> _showConfirmationDialog(int doctorId) async {
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
                          _saveDetails(doctorId);
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

  Future<void> _saveDetails(int? doctorId) async {
    if (_formKey.currentState!.validate()) {
      // Debug print for form validation
      print('Form is valid. Proceeding with saving doctor details.');

      // Assign illnessId, checking if the selected illness is 'Not Specified'
      final illnessId =
          selectedIllnessId == "Not Specified" ? "0" : selectedIllnessId;

      // Debug print for illnessId
      print('Illness ID: $illnessId');

      // Prepare the record details to be sent in the request
      final recordDetails = {
        "customers_id": widget.customerId.toString(),
        "doctor_name": doctorNameController.text,
        "doctor_specialization": doctorSpecialization,
        "doctor_contact_number": doctorContactNumberController.text,
        "doctor_hospital_name": doctorHospitalNameController.text,
        "illness_id": illnessId,
      };

      if (doctorId != null) {
        recordDetails["doctor_id"] = doctorId.toString();
      }

      // Debug print for the record details
      print('Doctor Record Details: $recordDetails');

      try {
        // Sending HTTP POST request
        final response = await http.post(
          Uri.parse("${Config.baseUrl}doctor.php"),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: recordDetails,
        );

        // Debug print for response body
        print('Response when updating: ${response.body}');

        if (response.statusCode == 200) {
          // Parse the response
          final jsonResponse = jsonDecode(response.body);

          // Debug print for parsed JSON response
          print('Parsed JSON Response: $jsonResponse');

          if (jsonResponse['status'] == 'success') {
            final updatedDoctorId = jsonResponse['doctor_id'];
            // Debug print for successful update
            print('Updated Doctor ID: $updatedDoctorId');
            _showSuccessDialog(
                'Doctor details updated successfully\nDoctor ID: $updatedDoctorId',
                updatedDoctorId);
            _fetchAddedRecords();
          } else {
            // Error message from the server
            _showErrorDialog(
                jsonResponse['message'] ?? "An unknown error occurred.");
          }
        } else {
          // Server returned an error
          _showErrorDialog("Server returned an error: ${response.statusCode}");
        }
      } catch (e) {
        // Exception occurred
        _showErrorDialog("An error occurred: $e");
        print("Error: $e");
      }
    } else {
      // Form is invalid
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

class AnimatedWavesBackground extends StatefulWidget {
  final Widget child;
  const AnimatedWavesBackground({Key? key, required this.child})
      : super(key: key);

  @override
  _AnimatedWavesBackgroundState createState() =>
      _AnimatedWavesBackgroundState();
}

class _AnimatedWavesBackgroundState extends State<AnimatedWavesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Slow and smooth animation
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(_controller.value),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint wavePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.purple.withOpacity(0.2);
    _drawWave(canvas, size, wavePaint, 1.0, 20, 0);
    _drawWave(canvas, size, wavePaint..color = Colors.blue.withOpacity(0.15),
        0.8, 15, pi / 2);
    _drawWave(canvas, size, wavePaint..color = Colors.blue.withOpacity(0.1),
        0.6, 10, pi);
  }

  void _drawWave(Canvas canvas, Size size, Paint paint, double amplitude,
      double waveHeight, double phaseShift) {
    Path path = Path();
    double waveFrequency = 2.0 * pi / size.width; // Controls wave length
    double yOffset = size.height * 0.8; // Adjust wave height position

    path.moveTo(0, yOffset);

    for (double x = 0; x <= size.width; x++) {
      double y = yOffset +
          sin((x * waveFrequency) + (animationValue * 2 * pi) + phaseShift) *
              waveHeight *
              amplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
