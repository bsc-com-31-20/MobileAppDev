import 'package:flutter/material.dart';
import 'add_entry_page.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  String _selectedMonth = 'September 2024';

  final List<Map<String, dynamic>> _records = [
    {
      'icon': Icons.fastfood,
      'label': 'Food - Airtel Money',
      'date': '13th September 2024',
      'amount': '-MK2,000',
      'color': Colors.red
    },
    {
      'icon': Icons.account_balance,
      'label': 'Upkeep - National Bank',
      'date': '12th September 2024',
      'amount': 'MK280,000',
      'color': Colors.green
    },
    {
      'icon': Icons.fastfood,
      'label': 'Food - Airtel Money',
      'date': '8th September 2024',
      'amount': '-MK6,500',
      'color': Colors.red
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'StudentBudget',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Selected month:',
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: _selectedMonth,
                    items: const <String>[
                      'September 2024',
                      'October 2024',
                      'November 2024'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonth = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              
              const Text(
                'Analysis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              
              const Text(
                'Monthly records',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              
              Column(
                children: _records.map((record) {
                  return ListTile(
                    leading: Icon(record['icon'], size: 40),
                    title: Text(
                      record['label'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      record['date'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      record['amount'],
                      style: TextStyle(
                        fontSize: 16,
                        color: record['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Remove Ads Section
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, size: 30, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Remove Ads - MK3,500', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEntryPage()),
    );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }

  
  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
