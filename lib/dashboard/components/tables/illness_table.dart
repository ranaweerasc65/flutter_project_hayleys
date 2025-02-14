import 'package:flutter/material.dart';

class IllnessTable extends StatefulWidget {
  const IllnessTable({super.key});

  @override
  _IllnessTableState createState() => _IllnessTableState();
}

class _IllnessTableState extends State<IllnessTable> {
  final List<Map<String, dynamic>> _illnessData = [
    {
      'illness_id': 1,
      'customer_id': 101,
      'doctor_id': 501,
      'illness_name': 'Flu',
      'illness_symptoms': 'Fever, Cough, Headache',
      'illness_status': 'Active',
      'diagnosis_date': '2025-02-10',
      'next_follow_up': '2025-02-20',
    },
    {
      'illness_id': 2,
      'customer_id': 102,
      'doctor_id': 502,
      'illness_name': 'Diabetes',
      'illness_symptoms': 'Increased thirst, Frequent urination',
      'illness_status': 'Chronic',
      'diagnosis_date': '2024-05-12',
      'next_follow_up': '2025-03-01',
    },
    {
      'illness_id': 3,
      'customer_id': 103,
      'doctor_id': 503,
      'illness_name': 'Hypertension',
      'illness_symptoms': 'High BP, Dizziness',
      'illness_status': 'Managed',
      'diagnosis_date': '2023-10-15',
      'next_follow_up': '2025-06-10',
    }
  ];

  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: () async {
              _refreshData();
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.blue.shade800),
                        dataRowColor: MaterialStateProperty.all(Colors.white),
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(
                              label: Text('ID',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Name',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Symptoms',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Status',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Diagnosis Date',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Next Follow-up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Actions',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ],
                        rows: _illnessData.map((illness) {
                          return DataRow(cells: [
                            DataCell(Text(illness['illness_id'].toString())),
                            DataCell(Text(illness['illness_name'])),
                            DataCell(Text(illness['illness_symptoms'])),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: illness['illness_status'] == 'Active'
                                      ? Colors.green
                                      : (illness['illness_status'] == 'Chronic'
                                          ? Colors.red
                                          : Colors.orange),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  illness['illness_status'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataCell(Text(illness['diagnosis_date'])),
                            DataCell(Text(illness['next_follow_up'] ?? 'N/A')),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  _showOptionsDialog(illness);
                                },
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
                _editIllnessDialog(illness);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteIllnessDialog(illness);
              },
            ),
          ],
        );
      },
    );
  }

  void _editIllnessDialog(Map<String, dynamic> illness) {
    TextEditingController symptomsController =
        TextEditingController(text: illness['illness_symptoms']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Illness ${illness['illness_name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: illness['illness_name']),
              decoration: const InputDecoration(labelText: 'Illness Name'),
              readOnly: true,
            ),
            TextField(
              controller: symptomsController,
              decoration: const InputDecoration(labelText: 'Symptoms'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                illness['illness_symptoms'] = symptomsController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteIllnessDialog(Map<String, dynamic> illness) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Illness'),
        content:
            Text('Are you sure you want to delete ${illness['illness_name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _illnessData.remove(illness);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
