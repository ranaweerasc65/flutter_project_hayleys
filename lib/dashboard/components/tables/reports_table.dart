import 'package:flutter/material.dart';

class ReportsTable extends StatefulWidget {
  const ReportsTable({super.key});

  @override
  _ReportsTableState createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  int _rowsPerPage = 5;

  final List<Map<String, dynamic>> _reportsData = [
    {
      'report_id': 'R001',
      'patient_name': 'John Doe',
      'report_type': 'Blood Test',
      'date_issued': '2025-02-10'
    },
    {
      'report_id': 'R002',
      'patient_name': 'Jane Smith',
      'report_type': 'X-Ray',
      'date_issued': '2025-02-12'
    },
    {
      'report_id': 'R003',
      'patient_name': 'Alice Brown',
      'report_type': 'MRI',
      'date_issued': '2025-02-15'
    },
    {
      'report_id': 'R001',
      'patient_name': 'John Doe',
      'report_type': 'Blood Test',
      'date_issued': '2025-02-10'
    },
    {
      'report_id': 'R002',
      'patient_name': 'Jane Smith',
      'report_type': 'X-Ray',
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
                      'Medical Reports',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  columns: const [
                    DataColumn(label: Text('Report ID')),
                    DataColumn(label: Text('Patient Name')),
                    DataColumn(label: Text('Report Type')),
                    DataColumn(label: Text('Date Issued')),
                    DataColumn(label: Text('Actions')),
                  ],
                  source: _ReportsTableDataSource(
                    _reportsData,
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

class _ReportsTableDataSource extends DataTableSource {
  final List<Map<String, dynamic>> reports;
  final BuildContext context;
  final Function refreshData;

  _ReportsTableDataSource(this.reports, this.context, this.refreshData);

  @override
  DataRow? getRow(int index) {
    if (index >= reports.length) return null;

    final report = reports[index];

    return DataRow(
      color: MaterialStateProperty.all(Colors.white),
      cells: [
        DataCell(Text(report['report_id'] ?? '')),
        DataCell(Text(report['patient_name'] ?? '')),
        DataCell(Text(report['report_type'] ?? '')),
        DataCell(Text(report['date_issued'] ?? '')),
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'Edit') {
                _editReportDialog(report);
              } else if (value == 'Delete') {
                _deleteReportDialog(report);
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

  void _editReportDialog(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Report ${report['report_id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: report['report_type']),
              decoration: const InputDecoration(labelText: 'Report Type'),
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

  void _deleteReportDialog(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report'),
        content: Text(
            'Are you sure you want to delete Report ${report['report_id']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              reports.remove(report);
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
  int get rowCount => reports.length;
  @override
  int get selectedRowCount => 0;
}
