import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SubmitClaim extends StatefulWidget {
  final int customerId;

  const SubmitClaim({
    super.key,
    required this.customerId,
  });

  @override
  _ClaimScreenState createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<SubmitClaim> {
  final Map<String, dynamic> dummyIllnessDetails = {
    'illness_name': 'Flu',
    'date': '2025-02-15',
    'claim_status': 1,
    'doctors': [
      {
        'DOCTOR_NAME': 'Dr. John Smith',
        'DOCTOR_SPECIALIZATION': 'General Physician'
      },
      {'DOCTOR_NAME': 'Dr. Sarah Lee', 'DOCTOR_SPECIALIZATION': 'Pulmonologist'}
    ],
    'prescriptions': [
      {'prescription_name': 'Antibiotics', 'date': '2025-02-16'},
      {'prescription_name': 'Cough Syrup', 'date': '2025-02-17'}
    ],
    'bills': [
      {'amount': '150.00', 'date': '2025-02-16'},
      {'amount': '75.50', 'date': '2025-02-17'}
    ],
    'reports': [
      {'report_name': 'Blood Test', 'date': '2025-02-15'},
      {'report_name': 'X-Ray', 'date': '2025-02-16'}
    ],
    'documents': [
      {'document_name': 'Insurance Card', 'date': '2025-02-15'},
      {'document_name': 'Receipt', 'date': '2025-02-16'}
    ],
  };

  bool _isLoading = true; // Start with loading true
  final TextEditingController _remarksController = TextEditingController();

  final List<String> stages = [
    'Submit',
    'Supervisor',
    'HR',
    'Insurance Company',
  ];
  int currentStage = 1;

  @override
  void initState() {
    super.initState();
    // Simulate fetching data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _submitClaim() {
    if (currentStage < stages.length - 1) {
      setState(() => currentStage++);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Claim stage updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Extend body behind AppBar for better background effect
      appBar: AppBar(
        title: const Text('Claim Details'),
        backgroundColor: Colors.blue.shade800, // Semi-transparent AppBar
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/claim_img.jpg'),
                fit: BoxFit.cover,
                opacity: 0.8, // Same opacity as before
              ),
            ),
          ),
          // Loading Animation or Content
          _isLoading
              ? Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: Colors.green,
                    size: 50,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50), // Space for AppBar
                      _buildSectionCard(
                          'Illness Details', _buildIllnessDetails()),
                      const SizedBox(height: 16),
                      _buildTrackingBar(),
                      const SizedBox(height: 16),
                      _buildSectionCard('Doctors', _buildDoctorsList()),
                      const SizedBox(height: 16),
                      _buildSectionCard(
                          'Prescriptions', _buildPrescriptionsList()),
                      const SizedBox(height: 16),
                      _buildSectionCard('Bills', _buildBillsList()),
                      const SizedBox(height: 16),
                      _buildSectionCard('Reports', _buildReportsList()),
                      const SizedBox(height: 16),
                      _buildSectionCard(
                          'Other Documents', _buildDocumentsList()),
                      const SizedBox(height: 16),
                      _buildRemarksSection(),
                      const SizedBox(height: 16),
                      if (currentStage < stages.length - 1)
                        ElevatedButton(
                          onPressed: _submitClaim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Submit to ${stages[currentStage + 1]}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white
          .withOpacity(0.9), // Semi-transparent white for readability
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildIllnessDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Text('Illness ID: ${widget.illnessId}'),
        Text('Name: ${dummyIllnessDetails['illness_name']}'),
        Text('Date: ${dummyIllnessDetails['date']}'),
      ],
    );
  }

  Widget _buildTrackingBar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Claim Progress',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(stages.length, (index) {
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index <= currentStage
                              ? Colors.green
                              : Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stages[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: index <= currentStage
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      if (index < stages.length - 1)
                        SizedBox(
                          width: 50,
                          child: Divider(
                            color: index < currentStage
                                ? Colors.green
                                : Colors.grey,
                            thickness: 2,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorsList() {
    final doctors = dummyIllnessDetails['doctors'] as List<dynamic>;
    return Column(
      children: doctors
          .map((doctor) => ListTile(
                title: Text(doctor['DOCTOR_NAME']),
                subtitle: Text(doctor['DOCTOR_SPECIALIZATION']),
              ))
          .toList(),
    );
  }

  Widget _buildPrescriptionsList() {
    final prescriptions = dummyIllnessDetails['prescriptions'] as List<dynamic>;
    return Column(
      children: prescriptions
          .map((prescription) => ListTile(
                title: Text(prescription['prescription_name']),
                subtitle: Text(prescription['date']),
              ))
          .toList(),
    );
  }

  Widget _buildBillsList() {
    final bills = dummyIllnessDetails['bills'] as List<dynamic>;
    return Column(
      children: bills
          .map((bill) => ListTile(
                title: Text('Amount: ${bill['amount']}'),
                subtitle: Text(bill['date']),
              ))
          .toList(),
    );
  }

  Widget _buildReportsList() {
    final reports = dummyIllnessDetails['reports'] as List<dynamic>;
    return Column(
      children: reports
          .map((report) => ListTile(
                title: Text(report['report_name']),
                subtitle: Text(report['date']),
              ))
          .toList(),
    );
  }

  Widget _buildDocumentsList() {
    final documents = dummyIllnessDetails['documents'] as List<dynamic>;
    return Column(
      children: documents
          .map((doc) => ListTile(
                title: Text(doc['document_name']),
                subtitle: Text(doc['date']),
              ))
          .toList(),
    );
  }

  Widget _buildRemarksSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Remarks (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _remarksController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter any additional remarks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
