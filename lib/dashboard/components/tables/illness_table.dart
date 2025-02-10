import 'package:flutter/material.dart';

class IllnessTable extends StatefulWidget {
  const IllnessTable({super.key});

  @override
  _IllnessTableState createState() => _IllnessTableState();
}

class _IllnessTableState extends State<IllnessTable> {
  int _rowsPerPage = 5;

  final List<Map<String, dynamic>> _illnessData = [
    {
      'illness': 'Flu',
      'diagnosis_date': '2025-01-15',
      'status': 'Active',
      'next_follow_up': '2025-02-15',
    },
    {
      'illness': 'Diabetes',
      'diagnosis_date': '2024-10-10',
      'status': 'Stable',
      'next_follow_up': '2025-03-10',
    },
    {
      'illness': 'Asthma',
      'diagnosis_date': '2023-06-25',
      'status': 'Controlled',
      'next_follow_up': '2025-05-20',
    },
    {
      'illness': 'Asthma',
      'diagnosis_date': '2023-06-25',
      'status': 'Controlled',
      'next_follow_up': '2025-05-20',
    },
    {
      'illness': 'Asthma',
      'diagnosis_date': '2023-06-25',
      'status': 'Controlled',
      'next_follow_up': '2025-05-20',
    },
  ];

  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
        },
        child: Container(
          color: Colors.white, // Full-page white background
          child: ListView(
            children: [
              Container(
                color: const Color.fromARGB(
                    255, 255, 255, 255), // Wraps entire table in white
                child: PaginatedDataTable(
                  header: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Illness Records',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  columns: const [
                    DataColumn(label: Text('Illness/Condition')),
                    DataColumn(label: Text('Diagnosis Date')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Next Follow-up')),
                    DataColumn(label: Text('Actions')),
                  ],
                  source: _IllnessTableDataSource(
                    _illnessData,
                    context,
                    _refreshData,
                  ),
                  rowsPerPage: _rowsPerPage,
                  columnSpacing: 20.0,
                  showCheckboxColumn: false,
                  onPageChanged: (int rowIndex) {},
                  headingRowColor: MaterialStateProperty.all(
                      Colors.white), // White header row
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    const Text('Rows per page:'),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      items: [5, 10, 20].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _rowsPerPage = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ FIX: The row background color is set inside the DataTableSource class
class _IllnessTableDataSource extends DataTableSource {
  final List<Map<String, dynamic>> illnesses;
  final BuildContext context;
  final Function refreshData;

  _IllnessTableDataSource(this.illnesses, this.context, this.refreshData);

  @override
  DataRow? getRow(int index) {
    if (index >= illnesses.length) return null;

    final illness = illnesses[index];

    return DataRow(
      color: MaterialStateProperty.all(
          Colors.white), // ✅ Set row background to white
      cells: [
        DataCell(Text(illness['illness'] ?? '')),
        DataCell(Text(illness['diagnosis_date'] ?? '')),
        DataCell(Text(illness['status'] ?? '')),
        DataCell(Text(illness['next_follow_up'] ?? '')),
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'Edit') {
                _editIllnessDialog(illness);
              } else if (value == 'Delete') {
                _deleteIllnessDialog(illness);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'Edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'Delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editIllnessDialog(Map<String, dynamic> illness) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${illness['illness']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: illness['illness']),
              decoration: const InputDecoration(labelText: 'Illness/Condition'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              refreshData();
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
        content: Text(
            'Are you sure you want to delete ${illness['illness']} from the list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              illnesses.remove(illness);
              refreshData();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => illnesses.length;

  @override
  int get selectedRowCount => 0;
}
