import 'package:flutter/material.dart';

class BillsTable extends StatefulWidget {
  const BillsTable({super.key});

  @override
  _BillsTableState createState() => _BillsTableState();
}

class _BillsTableState extends State<BillsTable> {
  int _rowsPerPage = 5;

  final List<Map<String, dynamic>> _billsData = [
    {
      'bill_number': 'B001',
      'patient_name': 'John Doe',
      'amount': 250.0,
      'due_date': '2025-02-15',
      'status': 'Unpaid'
    },
    {
      'bill_number': 'B002',
      'patient_name': 'Jane Smith',
      'amount': 150.5,
      'due_date': '2025-03-10',
      'status': 'Paid'
    },
    {
      'bill_number': 'B003',
      'patient_name': 'Alice Brown',
      'amount': 500.0,
      'due_date': '2025-02-20',
      'status': 'Unpaid'
    },
    {
      'bill_number': 'B001',
      'patient_name': 'John Doe',
      'amount': 250.0,
      'due_date': '2025-02-15',
      'status': 'Unpaid'
    },
    {
      'bill_number': 'B002',
      'patient_name': 'Jane Smith',
      'amount': 150.5,
      'due_date': '2025-03-10',
      'status': 'Paid'
    }
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
                      'Bills Records',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  columns: const [
                    DataColumn(label: Text('Bill Number')),
                    DataColumn(label: Text('Patient Name')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Due Date')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  source: _BillsTableDataSource(
                    _billsData,
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

class _BillsTableDataSource extends DataTableSource {
  final List<Map<String, dynamic>> bills;
  final BuildContext context;
  final Function refreshData;

  _BillsTableDataSource(this.bills, this.context, this.refreshData);

  @override
  DataRow? getRow(int index) {
    if (index >= bills.length) return null;

    final bill = bills[index];

    return DataRow(
      color: MaterialStateProperty.all(Colors.white),
      cells: [
        DataCell(Text(bill['bill_number'] ?? '')),
        DataCell(Text(bill['patient_name'] ?? '')),
        DataCell(Text('\$${bill['amount'].toStringAsFixed(2)}')),
        DataCell(Text(bill['due_date'] ?? '')),
        DataCell(Text(bill['status'] ?? '')),
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'Edit') {
                _editBillDialog(bill);
              } else if (value == 'Delete') {
                _deleteBillDialog(bill);
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

  void _editBillDialog(Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Bill ${bill['bill_number']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: bill['patient_name']),
              decoration: const InputDecoration(labelText: 'Patient Name'),
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

  void _deleteBillDialog(Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bill'),
        content: Text(
            'Are you sure you want to delete Bill ${bill['bill_number']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              bills.remove(bill);
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
  int get rowCount => bills.length;
  @override
  int get selectedRowCount => 0;
}
