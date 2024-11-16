import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:pie_chart/pie_chart.dart';
import 'add_entry_page.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  DateTime _currentMonth = DateTime(2024, 11); // Initialize to November 2024
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
    double totalAmount =
        _expenses.fold(0.0, (sum, expense) => sum + expense["amount"]);
    Map<String, double> data = {};

    for (var expense in _expenses) {
      String category = expense["category"];
      double amount = expense["amount"];
      double percentage = (amount / totalAmount) * 100;
      data[category] = percentage;
    }

    setState(() {
      _expenseData = data;
    });
  }

  // Update the current month and format it
  void _updateMonth(int increment) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + increment,
      );
    });
  }

  String _getFormattedMonth() {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String month = months[_currentMonth.month - 1];
    int year = _currentMonth.year;
    return " $month $year ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left, color: Colors.black),
              onPressed: () => _updateMonth(-1),
            ),
            Text(
              _getFormattedMonth(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right, color: Colors.black),
              onPressed: () => _updateMonth(1),
            ),
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
                underline: const SizedBox(),
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

            // Dynamic Pie Chart and Legend
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Pie Chart
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 150, // Make the pie chart smaller
                        width: 150,
                        child: PieChart(
                          dataMap: _expenseData,
                          animationDuration: const Duration(milliseconds: 800),
                          chartType: ChartType.ring,
                          colorList: [Colors.red, Colors.yellow, Colors.purple],
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage:
                                true, // Show percentages
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                          legendOptions: const LegendOptions(
                            showLegends: false,
                          ),
                        ),
                      ),
                      // Center Text
                      Text(
                        _overviewType.contains('Expense')
                            ? 'Expense'
                            : 'Income',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 20),

                  // Legend for Categories
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(Icons.circle, 'Food', Colors.red),
                      const SizedBox(height: 10),
                      _buildLegendItem(
                          Icons.circle, 'Education', Colors.yellow),
                      const SizedBox(height: 10),
                      _buildLegendItem(
                          Icons.circle, 'Electronics', Colors.purple),
                    ],
                  ),
                ],
              ),
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
