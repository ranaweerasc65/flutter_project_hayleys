import 'package:flutter/material.dart';

class BillsTable extends StatefulWidget {
  const BillsTable({super.key});

  @override
  _BillsTableState createState() => _BillsTableState();
}

class _BillsTableState extends State<BillsTable> {
  final List<Map<String, dynamic>> _billsData = [
    {
      'bill_id': 1, // This is the auto-incremented BILL_ID
      'customer_id': 101, // Corresponds to CUSTOMERS_ID
      'illness_id': 201, // Corresponds to ILLNESS_ID
      'bill_number': 'B001',
      'bill_amount': 250.0, // BILL_AMOUNT
      'bill_issue_date': '2025-02-15', // BILL_ISSUE_DATE
      'bill_status': 'Unpaid', // BILL_STATUS
      'bill_description': 'Treatment for fever', // BILL_DESCRIPTION (nullable)
    },
    {
      'bill_id': 2,
      'customer_id': 102,
      'illness_id': 202,
      'bill_number': 'B002',
      'bill_amount': 150.5,
      'bill_issue_date': '2025-03-10',
      'bill_status': 'Paid',
      'bill_description': 'Consultation fee',
    },
    {
      'bill_id': 3,
      'customer_id': 103,
      'illness_id': 203,
      'bill_number': 'B003',
      'bill_amount': 500.0,
      'bill_issue_date': '2025-02-20',
      'bill_status': 'Unpaid',
      'bill_description': 'Surgery fee',
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
                    color: Colors.white, // Table background
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Soft shadow
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
                                    child: Text('Bill ID',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Bill Number',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Amount',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Issue Date',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Status',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Description',
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
                          rows: _billsData.map((bill) {
                            return DataRow(cells: [
                              DataCell(
                                  Text(bill['bill_id'].toString())), // Bill ID
                              DataCell(Text(bill['bill_number'])),
                              DataCell(Text(
                                  '\$${bill['bill_amount'].toStringAsFixed(2)}')),
                              DataCell(Text(bill['bill_issue_date'])),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: bill['bill_status'] == 'Paid'
                                        ? Colors.green
                                        : (bill['bill_status'] == 'Unpaid'
                                            ? Colors.red
                                            : Colors.orange),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    bill['bill_status'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              DataCell(Text(bill['bill_description'] ??
                                  'No Description')),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    _showOptionsDialog(bill);
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

  void _showOptionsDialog(Map<String, dynamic> bill) {
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
                _editBillDialog(bill);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteBillDialog(bill);
              },
            ),
          ],
        );
      },
    );
  }

  void _editBillDialog(Map<String, dynamic> bill) {
    TextEditingController descriptionController =
        TextEditingController(text: bill['bill_description']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Bill ${bill['bill_number']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: bill['bill_number']),
              decoration: const InputDecoration(labelText: 'Bill Number'),
              readOnly: true, // Read-only since it's unique
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Bill Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                bill['bill_description'] = descriptionController.text;
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
              setState(() {
                _billsData.remove(bill);
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
