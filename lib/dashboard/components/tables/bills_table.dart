import 'package:flutter/material.dart';

class BillsTable extends StatefulWidget {
  const BillsTable({super.key});

  @override
  _BillsTableState createState() => _BillsTableState();
}

class _BillsTableState extends State<BillsTable> {
  final List<Map<String, dynamic>> _billsData = [];

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
                              WidgetStateProperty.all(Colors.blue.shade800),
                          dataRowColor: WidgetStateProperty.all(Colors.white),
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
                                    child: Text('Illness ID',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Doctor ID',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: Expanded(
                                    child: Text('Document Path',
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
