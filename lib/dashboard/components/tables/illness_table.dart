import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/config.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:math';
import 'dart:ui';

class IllnessTable extends StatefulWidget {
  final int customerId;
  final Function onIllnessAdded;

  const IllnessTable({
    super.key,
    required this.customerId,
    required this.onIllnessAdded,
  });

  @override
  _IllnessTableState createState() => _IllnessTableState();
}

class _IllnessTableState extends State<IllnessTable> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController diagnosisDateController = TextEditingController();
  final TextEditingController nextFollowUpDateController =
      TextEditingController();

  String? status;

  List<String> statusOptions = ['Active', 'Chronic', 'Managed'];

  List<Map<String, dynamic>> _illnessData = [];

  int illnessCount = 0;

  Future<void> _refreshData() async {
    setState(() {
      nameController.clear();
      symptomsController.clear();
      diagnosisDateController.clear();
      nextFollowUpDateController.clear();

      status = null;
    });
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();

    print('---------------------');
    print('Illness Table for Customer ID: ${widget.customerId}');
    print('---------------------');

    _fetchAddedRecords();
  }

  void _showAddIllnessForm() {
    nameController.clear();
    symptomsController.clear();
    diagnosisDateController.clear();
    nextFollowUpDateController.clear();

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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Illness Details",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
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
                                      buildLabel("Illness/ Condition Name"),
                                      buildTextField(
                                        nameController,
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
                                        "Status",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      buildDropdownField(
                                        "Status",
                                        status,
                                        ['Active', 'Chronic', 'Managed'],
                                        (value) => status = value,
                                        isMandatory: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            buildLabel("Symptoms"),
                            buildTextField(symptomsController, ""),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildLabel("Diagnosis Date"),
                                      buildDatePickerField(
                                        "Diagnosis Date",
                                        isMandatory: true,
                                        diagnosisDateController,
                                        "",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildLabel("Next Follow Up Date"),
                                      buildDatePickerField(
                                        "Next Follow Up Date",
                                        isMandatory: true,
                                        nextFollowUpDateController,
                                        "",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                      color: Colors.green.shade800,
                      size: 30,
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          _fetchAddedRecords();
                        },
                        child: _illnessData.isEmpty
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
                                                    label: Text('ID',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text('Name',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text('Symptoms',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text('Status',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text(
                                                        'Diagnosis Date',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text(
                                                        'Next Follow-up',
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
                                              rows: _illnessData.map((illness) {
                                                return DataRow(cells: [
                                                  DataCell(Text(
                                                      illness['ILLNESS_ID']
                                                              ?.toString() ??
                                                          'N/A')),
                                                  DataCell(Text(
                                                      illness['ILLNESS_NAME'] ??
                                                          'N/A')),
                                                  DataCell(Text(illness[
                                                          'ILLNESS_SYMPTOMS'] ??
                                                      'N/A')),
                                                  DataCell(
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4,
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        color: (illness[
                                                                    'ILLNESS_STATUS'] ==
                                                                'Active')
                                                            ? Colors.green
                                                            : (illness['ILLNESS_STATUS'] ==
                                                                    'Chronic'
                                                                ? Colors.red
                                                                : Colors
                                                                    .orange),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Text(
                                                        illness['ILLNESS_STATUS'] ??
                                                            'N/A',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(Text(illness[
                                                          'ILLNESS_DIAGNOSIS_DATE'] ??
                                                      'N/A')),
                                                  DataCell(Text(illness[
                                                          'ILLNESS_NEXT_FOLLOW_UP_DATE'] ??
                                                      'N/A')),
                                                  DataCell(
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.more_vert),
                                                      onPressed: () {
                                                        _showOptionsDialog(
                                                            illness);
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
                  _showAddIllnessForm();
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add Illness",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
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

  void _showOptionsDialog(Map<String, dynamic> illness) {
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
                _editIllness(illness);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(illness['ILLNESS_ID']);
              },
            ),
          ],
        );
      },
    );
  }

  void _editIllness(Map<String, dynamic> illness) {
    //print("Illness details: $illness");
    print(
        "Edit button pressed for illness Id: ${illness['ILLNESS_ID']} customers_id=${widget.customerId} ");

    nameController.text = illness['ILLNESS_NAME'] ?? '';
    symptomsController.text = illness['ILLNESS_SYMPTOMS'] ?? '';
    diagnosisDateController.text = illness['ILLNESS_DIAGNOSIS_DATE'] ?? '';
    nextFollowUpDateController.text =
        illness['ILLNESS_NEXT_FOLLOW_UP_DATE'] ?? '';

    status = illness['ILLNESS_STATUS'];

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
                                "Edit Illness Record",
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
                                      buildLabel("Illness/ Condition Name"),
                                      buildTextField(
                                        nameController,
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
                                        "Status",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      buildDropdownField(
                                        "Status",
                                        status,
                                        ['Active', 'Chronic', 'Managed'],
                                        (value) => status = value,
                                        isMandatory: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            buildLabel("Symptoms"),
                            buildTextField(symptomsController, ""),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildLabel("Diagnosis Date"),
                                      buildDatePickerField(
                                        "Diagnosis Date",
                                        isMandatory: true,
                                        diagnosisDateController,
                                        "",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildLabel("Next Follow Up Date"),
                                      buildDatePickerField(
                                        "Next Follow Up Date",
                                        isMandatory: true,
                                        nextFollowUpDateController,
                                        "",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: MaterialButton(
                                    onPressed: () {
                                      _showConfirmationDialog(
                                          illness['ILLNESS_ID']);
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

  void _showDeleteConfirmationDialog(int illnessId) {
    print("Delete Button pressed for $illnessId");
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
                      color: Colors.red, // Match icon color
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure you want to delete this Illness Record?",
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
                          print("Illness Id at delete: $illnessId");

                          try {
                            final response =
                                await deleteIllnessRecord(illnessId);

                            print(
                                "Response from API: $response"); // Debugging line to print response

                            if (response['status'] == 'success') {
                              _fetchAddedRecords();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Failed to delete illness record: ${response['message']}"),
                                ),
                              );
                            }
                          } catch (e) {
                            print("Error deleting illness record: $e");
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

  Future<Map<String, dynamic>> deleteIllnessRecord(int illnessId) async {
    final url = Uri.parse(
      "${Config.baseUrl}illness.php",
    );

    final response = await http.post(
      url,
      body: {
        'action': 'delete',
        'illness_id': illnessId.toString(),
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete illness record');
    }
  }

  Future<void> _addRecord() async {
    print('-----------------');
    print('ADD RECORD');

    final mandatoryFields = {
      "Illness Name": nameController.text,
      "Illness Symptoms": symptomsController.text,
      "Illness Status": status,
      "Diagnosis Date": diagnosisDateController.text,
      "Next Follow-up Date": nextFollowUpDateController.text,
    };

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
      final recordDetails = {
        "customers_id": widget.customerId.toString(),
        "illness_name": nameController.text,
        "illness_symptoms": symptomsController.text,
        "illness_status": status,
        "illness_diagnosis_date": diagnosisDateController.text,
        "illness_next_follow_up_date": nextFollowUpDateController.text,
      };

      print('Record Details: $recordDetails');

      try {
        final response = await http.post(
          Uri.parse("${Config.baseUrl}illness.php"),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: recordDetails,
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            final illnessId = jsonResponse['illness_id'];
            print('Illness ID: $illnessId');

            _showSuccessDialog(
                'Illness record added successfully\nIllness ID: $illnessId',
                illnessId);

            widget.onIllnessAdded();

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
    }
  }

  Future<void> _fetchAddedRecords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url =
          "${Config.baseUrl}fetch_illness_data.php?customer_id=${widget.customerId}";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> illnesses = jsonResponse['illnesses'];

          setState(() {
            _illnessData = illnesses.isNotEmpty
                ? List<Map<String, dynamic>>.from(illnesses)
                : []; // Ensure empty list is handled
          });
        } else {
          setState(() {
            _illnessData = [];
          });
          // Do NOT show an error dialog if there are no records
        }
      } else {
        _showErrorDialog("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
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
    nameController.clear();
    symptomsController.clear();
    diagnosisDateController.clear();
    nextFollowUpDateController.clear();

    setState(() {
      status = null;
    });
  }

  Widget buildDropdownField(
    String label,
    String? currentValue,
    List<String> options,
    Function(String?) onChanged, {
    bool isMandatory =
        false, // New parameter to indicate if the field is mandatory
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

  Future<void> _showConfirmationDialog(int illnessId) async {
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
                              illnessId); // Now call the save details function
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

  Future<void> _saveDetails(int? illnessId) async {
    if (_formKey.currentState!.validate()) {
      final recordDetails = {
        "customers_id": widget.customerId.toString(),
        "illness_name": nameController.text,
        "illness_symptoms": symptomsController.text,
        "illness_status": status,
        "illness_diagnosis_date": diagnosisDateController.text,
        "illness_next_follow_up_date": nextFollowUpDateController.text,
      };

      if (illnessId != null) {
        recordDetails["illness_id"] =
            illnessId.toString(); // Ensure illness_id is sent for updates
      }

      print('Illness Record Details: $recordDetails');

      try {
        final response = await http.post(
          Uri.parse("${Config.baseUrl}illness.php"),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: recordDetails,
        );

        print('Response when updating: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            final updatedIllnessId = jsonResponse['illness_id'];
            print('Updated Illness ID: $updatedIllnessId');
            _showSuccessDialog(
                'Illness details updated successfully\nIllness ID: $updatedIllnessId',
                updatedIllnessId);
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
    }
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
      duration: const Duration(seconds: 10), // Slow wave movement
    )..repeat();
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
      ..color = Colors.green.withOpacity(0.2);
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
