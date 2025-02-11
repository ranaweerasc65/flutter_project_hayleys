import 'package:flutter/material.dart';

class PrescriptionsTable extends StatefulWidget {
  const PrescriptionsTable({super.key});

  @override
  _PrescriptionTableState createState() => _PrescriptionTableState();
}

class _PrescriptionTableState extends State<PrescriptionsTable> {
  int _rowsPerPage = 5;

  final List<Map<String, dynamic>> _prescriptionData = [
    {
      'prescription_id': 'P001',
      'patient_name': 'John Doe',
      'medication': 'Paracetamol',
      'dosage': '500mg',
      'date_issued': '2025-02-10'
    },
    {
      'prescription_id': 'P002',
      'patient_name': 'Jane Smith',
      'medication': 'Ibuprofen',
      'dosage': '200mg',
      'date_issued': '2025-02-12'
    },
    {
      'prescription_id': 'P003',
      'patient_name': 'Alice Brown',
      'medication': 'Amoxicillin',
      'dosage': '250mg',
      'date_issued': '2025-02-15'
    },
    {
      'prescription_id': 'P001',
      'patient_name': 'John Doe',
      'medication': 'Paracetamol',
      'dosage': '500mg',
      'date_issued': '2025-02-10'
    },
    {
      'prescription_id': 'P002',
      'patient_name': 'Jane Smith',
      'medication': 'Ibuprofen',
      'dosage': '200mg',
      'date_issued': '2025-02-12'
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
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                color: Colors.white,
                child: PaginatedDataTable(
                  header: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Prescription Records',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  columns: const [
                    DataColumn(label: Text('Prescription ID')),
                    DataColumn(label: Text('Patient Name')),
                    DataColumn(label: Text('Medication')),
                    DataColumn(label: Text('Dosage')),
                    DataColumn(label: Text('Date Issued')),
                    DataColumn(label: Text('Actions')),
                  ],
                  source: _PrescriptionTableDataSource(
                    _prescriptionData,
                    context,
                    _refreshData,
                  ),
                  rowsPerPage: _rowsPerPage,
                  columnSpacing: 20.0,
                  showCheckboxColumn: false,
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

class _PrescriptionTableDataSource extends DataTableSource {
  final List<Map<String, dynamic>> prescriptions;
  final BuildContext context;
  final Function refreshData;

  _PrescriptionTableDataSource(
      this.prescriptions, this.context, this.refreshData);

  @override
  DataRow? getRow(int index) {
    if (index >= prescriptions.length) return null;

    final prescription = prescriptions[index];

    return DataRow(
      color: MaterialStateProperty.all(Colors.white),
      cells: [
        DataCell(Text(prescription['prescription_id'] ?? '')),
        DataCell(Text(prescription['patient_name'] ?? '')),
        DataCell(Text(prescription['medication'] ?? '')),
        DataCell(Text(prescription['dosage'] ?? '')),
        DataCell(Text(prescription['date_issued'] ?? '')),
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'Edit') {
                _editPrescriptionDialog(prescription);
              } else if (value == 'Delete') {
                _deletePrescriptionDialog(prescription);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'Edit', child: Text('Edit')),
              const PopupMenuItem(
                value: 'Delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editPrescriptionDialog(Map<String, dynamic> prescription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Prescription ${prescription['prescription_id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller:
                  TextEditingController(text: prescription['medication']),
              decoration: const InputDecoration(labelText: 'Medication'),
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

  void _deletePrescriptionDialog(Map<String, dynamic> prescription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Prescription'),
        content: Text(
            'Are you sure you want to delete Prescription ${prescription['prescription_id']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              prescriptions.remove(prescription);
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
  int get rowCount => prescriptions.length;
  @override
  int get selectedRowCount => 0;
}
