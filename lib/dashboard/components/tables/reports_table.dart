import 'package:flutter/material.dart';

class ReportsTable extends StatefulWidget {
  const ReportsTable({super.key});

  @override
  _ReportsTableState createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  final List<Map<String, dynamic>> _reportsData = [
    {
      'report_id': 1,
      'customer_id': 101,
      'illness_id': 201,
      'report_number': 'R001',
      'report_type': 'Medical Report',
      'report_date': '2025-02-10',
      'report_details': 'Detailed health checkup report',
      'document_path': 'path/to/document1.pdf',
      'created_at': '2025-02-10 12:00:00',
      'updated_at': '2025-02-12 15:30:00',
    },
    {
      'report_id': 2,
      'customer_id': 102,
      'illness_id': 202,
      'report_number': 'R002',
      'report_type': 'Lab Report',
      'report_date': '2025-03-05',
      'report_details': 'Blood test results',
      'document_path': 'path/to/document2.pdf',
      'created_at': '2025-03-05 14:00:00',
      'updated_at': '2025-03-06 10:15:00',
    },
    {
      'report_id': 3,
      'customer_id': 103,
      'illness_id': 203,
      'report_number': 'R003',
      'report_type': 'X-Ray Report',
      'report_date': '2025-04-01',
      'report_details': 'Chest X-ray analysis',
      'document_path': 'path/to/document3.pdf',
      'created_at': '2025-04-01 09:30:00',
      'updated_at': '2025-04-02 11:45:00',
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
                                label: Expanded(
                                    child: Text('Report ID',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Report Number',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Report Type',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Report Date',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Details',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Document',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Actions',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                          ],
                          rows: _reportsData.map((report) {
                            return DataRow(cells: [
                              DataCell(Text(
                                  report['report_id'].toString())), // Report ID
                              DataCell(Text(report['report_number'])),
                              DataCell(Text(report['report_type'])),
                              DataCell(Text(report['report_date'])),
                              DataCell(Text(
                                  report['report_details'] ?? 'No Details')),
                              DataCell(
                                TextButton(
                                  onPressed: () {
                                    // Implement document opening logic
                                  },
                                  child: const Text(
                                    'View',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    _showOptionsDialog(report);
                                  },
                                ),
                              ),
                            ]);
                          }).toList(),
                        )),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOptionsDialog(Map<String, dynamic> report) {
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
                _editReportDialog(report);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteReportDialog(report);
              },
            ),
          ],
        );
      },
    );
  }

  void _editReportDialog(Map<String, dynamic> report) {
    TextEditingController detailsController =
        TextEditingController(text: report['report_details']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Report ${report['report_number']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: report['report_number']),
              decoration: const InputDecoration(labelText: 'Report Number'),
              readOnly: true, // Read-only since it's unique
            ),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Report Details'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                report['report_details'] = detailsController.text;
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

  void _deleteReportDialog(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report'),
        content: Text(
            'Are you sure you want to delete Report ${report['report_number']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _reportsData.remove(report);
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
