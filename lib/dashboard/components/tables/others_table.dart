import 'package:flutter/material.dart';

class OthersTable extends StatefulWidget {
  const OthersTable({super.key});

  @override
  _OthersTableState createState() => _OthersTableState();
}

class _OthersTableState extends State<OthersTable> {
  final List<Map<String, dynamic>> _othersData = [];

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
                            WidgetStateProperty.all(Colors.blue.shade800),
                        dataRowColor: WidgetStateProperty.all(Colors.white),
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
                        rows: _othersData.map((other) {
                          return DataRow(cells: [
                            DataCell(Text(other['document_id'].toString())),
                            DataCell(Text(other['document_type'])),
                            DataCell(Text(other['document_name'])),
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
                                  _showOptionsDialog(other);
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

  void _showOptionsDialog(Map<String, dynamic> other) {
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
                _editOtherDialog(other);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteOtherDialog(other);
              },
            ),
          ],
        );
      },
    );
  }

  void _editOtherDialog(Map<String, dynamic> other) {
    TextEditingController detailsController =
        TextEditingController(text: other['description']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Document ${other['document_name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: other['document_name']),
              decoration: const InputDecoration(labelText: 'Document Name'),
              readOnly: true, // Read-only since it's unique
            ),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                other['description'] = detailsController.text;
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

  void _deleteOtherDialog(Map<String, dynamic> other) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content:
            Text('Are you sure you want to delete ${other['document_name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _othersData.remove(other);
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
