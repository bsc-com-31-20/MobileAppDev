import 'package:flutter/material.dart';
import 'add_entry_page.dart';
import 'package:pie_chart/pie_chart.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  String _selectedMonth = 'November 2024';
  String _overviewType = 'Expense Overview';

  // List of expenses
  final List<Map<String, dynamic>> _expenses = [
    {"category": "Food", "amount": 20000.0},
    {"category": "Education", "amount": 50000.0},
    {"category": "Electronics", "amount": 10000.0},
  ];

  // Expense data for pie chart
  Map<String, double> _expenseData = {};

  @override
  void initState() {
    super.initState();
    _calculateExpenseData();
  }

  // Method to calculate expense data for pie chart
  void _calculateExpenseData() {
    Map<String, double> data = {};

    for (var expense in _expenses) {
      String category = expense["category"];
      double amount = expense["amount"];
      data[category] = (data[category] ?? 0) + amount;
    }

    setState(() {
      _expenseData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_ios, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              _selectedMonth,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.black),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row with Expense, Income, and Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn('EXPENSE', 'K90,000.00', Colors.red),
                _buildStatColumn('INCOME', 'K130,000.00', Colors.green),
                _buildStatColumn('TOTAL', 'K40,000.00', Colors.blue),
              ],
            ),
            const SizedBox(height: 20),

            // Dropdown for Expense/Income Overview with border
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: DropdownButton<String>(
                value: _overviewType,
                isExpanded: true,
                underline: SizedBox(),
                items: const [
                  DropdownMenuItem(
                      value: 'Expense Overview',
                      child: Text('Expense Overview')),
                  DropdownMenuItem(
                      value: 'Income Overview', child: Text('Income Overview')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _overviewType = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Dynamic Pie Chart
            Expanded(
              child: Center(
                child: PieChart(
                  dataMap: _expenseData,
                  animationDuration: const Duration(milliseconds: 800),
                  chartType: ChartType.ring,
                  colorList: [Colors.red, Colors.yellow, Colors.purple],
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                  ),
                  legendOptions: const LegendOptions(
                    showLegends: false,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Legend for Pie Chart Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Icons.circle, 'Food', Colors.red),
                const SizedBox(width: 20),
                _buildLegendItem(Icons.circle, 'Education', Colors.yellow),
                const SizedBox(width: 20),
                _buildLegendItem(Icons.circle, 'Electronics', Colors.purple),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEntryPage()),
          ).then((value) {
            // Optionally, recalculate the data if a new entry is added
            _calculateExpenseData();
          });
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(value,
            style: TextStyle(
                fontSize: 18, color: color, fontWeight: FontWeight.bold)),
      ],
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
