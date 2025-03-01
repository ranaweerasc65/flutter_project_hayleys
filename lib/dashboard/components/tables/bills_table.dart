import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillsTable extends StatefulWidget {
  final int customerId;
  final int? illnessId;
  final Function onBillAdded;
  final bool showAddForm; // New flag to show add form

  const BillsTable({
    super.key,
    required this.customerId,
    this.illnessId,
    required this.onBillAdded,
    this.showAddForm = false,
  });

  @override
  _BillsTableState createState() => _BillsTableState();
}

class _BillsTableState extends State<BillsTable> {
  final List<Map<String, dynamic>> _billsData = [];
  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController billAmountController = TextEditingController();
  final TextEditingController billIssueDateController = TextEditingController();
  final TextEditingController billDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    // Print statement when coming to the Bills table with an illnessId
    if (widget.illnessId != null) {
      print('Coming to the Bills table with illness id: ${widget.illnessId}');
    }

    if (widget.showAddForm && widget.illnessId != null) {
      _showAddBillForm();
    }
  }

  void _refreshData() {
    setState(() {});
  }

  void _showAddBillForm() {
    billNumberController.clear();
    billAmountController.clear();
    billIssueDateController.clear();
    billDescriptionController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Bill'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: billNumberController,
                  decoration: const InputDecoration(labelText: 'Bill Number'),
                ),
                TextField(
                  controller: billAmountController,
                  decoration: const InputDecoration(labelText: 'Bill Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: billIssueDateController,
                  decoration: const InputDecoration(labelText: 'Issue Date'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      billIssueDateController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    }
                  },
                ),
                TextField(
                  controller: billDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _billsData.add({
                    'bill_id': _billsData.length + 1,
                    'bill_number': billNumberController.text,
                    'bill_amount': double.parse(billAmountController.text),
                    'bill_issue_date': billIssueDateController.text,
                    'bill_description': billDescriptionController.text,
                    'illness_id': widget.illnessId,
                  });
                });
                widget.onBillAdded();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _showAddBillForm,
                      child: const Text('Add Bill'),
                    ),
                    Container(
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
                                      child: Text('Description',
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
                                      child: Text('Actions',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)))),
                            ],
                            rows: _billsData.map((bill) {
                              return DataRow(cells: [
                                DataCell(Text(bill['bill_id'].toString())),
                                DataCell(Text(bill['bill_number'])),
                                DataCell(Text(
                                    '\$${bill['bill_amount'].toStringAsFixed(2)}')),
                                DataCell(Text(bill['bill_issue_date'])),
                                DataCell(Text(bill['bill_description'] ??
                                    'No Description')),
                                DataCell(Text(
                                    bill['illness_id']?.toString() ?? 'N/A')),
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
              readOnly: true,
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
              widget.onBillAdded();
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
              widget.onBillAdded();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
