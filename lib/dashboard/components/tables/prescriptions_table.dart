import 'package:flutter/material.dart';

class PrescriptionsTable extends StatefulWidget {
  const PrescriptionsTable({super.key});

  @override
  _PrescriptionsTableState createState() => _PrescriptionsTableState();
}

class _PrescriptionsTableState extends State<PrescriptionsTable> {
  final List<Map<String, dynamic>> _prescriptionsData = [
    {
      'prescription_id': 1,
      'customers_id': 101,
      'illness_id': 201,
      'prescription_number': 'RX001',
      'medication_name': 'Paracetamol',
      'medication_dosage': '500mg, twice a day',
      'prescription_date': '2025-02-10',
      'prescription_expiry_date': '2025-03-10',
      'prescription_details': 'Take after meals',
    },
    {
      'prescription_id': 2,
      'customers_id': 102,
      'illness_id': 202,
      'prescription_number': 'RX002',
      'medication_name': 'Metformin',
      'medication_dosage': '850mg, once a day',
      'prescription_date': '2025-01-15',
      'prescription_expiry_date': '2025-04-15',
      'prescription_details': 'Take in the morning',
    },
    {
      'prescription_id': 3,
      'customers_id': 103,
      'illness_id': 203,
      'prescription_number': 'RX003',
      'medication_name': 'Amlodipine',
      'medication_dosage': '10mg, once a day',
      'prescription_date': '2024-12-20',
      'prescription_expiry_date': '2025-06-20',
      'prescription_details': 'Take in the evening',
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
                              label: Text('Number',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Medication',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Dosage',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Prescription Date',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Expiry Date',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Details',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Actions',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ],
                        rows: _prescriptionsData.map((prescription) {
                          return DataRow(cells: [
                            DataCell(Text(
                                prescription['prescription_id'].toString())),
                            DataCell(Text(prescription['prescription_number'])),
                            DataCell(Text(prescription['medication_name'])),
                            DataCell(Text(prescription['medication_dosage'])),
                            DataCell(Text(prescription['prescription_date'])),
                            DataCell(Text(
                                prescription['prescription_expiry_date'] ??
                                    'N/A')),
                            DataCell(
                                Text(prescription['prescription_details'])),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  _showOptionsDialog(prescription);
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

  void _showOptionsDialog(Map<String, dynamic> prescription) {
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
                _editPrescriptionDialog(prescription);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deletePrescriptionDialog(prescription);
              },
            ),
          ],
        );
      },
    );
  }

  void _editPrescriptionDialog(Map<String, dynamic> prescription) {
    TextEditingController detailsController =
        TextEditingController(text: prescription['prescription_details']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Prescription ${prescription['prescription_number']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller:
                  TextEditingController(text: prescription['medication_name']),
              decoration: const InputDecoration(labelText: 'Medication Name'),
              readOnly: true,
            ),
            TextField(
              controller: TextEditingController(
                  text: prescription['medication_dosage']),
              decoration: const InputDecoration(labelText: 'Dosage'),
              readOnly: true,
            ),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                prescription['prescription_details'] = detailsController.text;
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

  void _deletePrescriptionDialog(Map<String, dynamic> prescription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Prescription'),
        content: Text(
            'Are you sure you want to delete ${prescription['prescription_number']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _prescriptionsData.remove(prescription);
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
