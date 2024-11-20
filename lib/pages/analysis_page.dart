import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'account_model.dart';
import 'add_entry_page.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  DateTime _currentMonth = DateTime.now();
  String _overviewType = 'Expense Overview';

  Map<String, double> _expenseData = {};
  Map<String, double> _incomeData = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateOverviewData(); // Calculate data after first frame
    });
  }

  void _calculateOverviewData() {
    final accountModel = Provider.of<AccountModel>(context, listen: false);

    // Aggregate income data
    Map<String, double> incomeData = {};
    for (var entry in accountModel.incomeEntries) {
      final category = entry['category'];
      final amount = entry['amount'] ?? 0.0;
      incomeData[category] = (incomeData[category] ?? 0) + amount;
    }

    // Aggregate expense data
    Map<String, double> expenseData = {};
    for (var entry in accountModel.expenseEntries) {
      final category = entry['category'];
      final amount = entry['amount'] ?? 0.0;
      expenseData[category] = (expenseData[category] ?? 0) + amount;
    }

    setState(() {
      _incomeData = incomeData;
      _expenseData = expenseData;
    });
  }

  double _getTotal(Map<String, double> data) {
    return data.values.fold(0, (sum, value) => sum + value);
  }

  void _updateMonth(int increment) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + increment,
      );
    });
  }

  String _getFormattedMonth() {
    final months = [
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
    return "${months[_currentMonth.month - 1]} ${_currentMonth.year}";
  }

  @override
  Widget build(BuildContext context) {
    final totalExpense = _getTotal(_expenseData);
    final totalIncome = _getTotal(_incomeData);
    final totalBalance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left, color: Colors.white),
              onPressed: () => _updateMonth(-1),
            ),
            Text(
              _getFormattedMonth(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right, color: Colors.white),
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
            // Header Row with Totals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn('EXPENSE',
                    'K${totalExpense.toStringAsFixed(2)}', Colors.red),
                _buildStatColumn('INCOME', 'K${totalIncome.toStringAsFixed(2)}',
                    Colors.green),
                _buildStatColumn('TOTAL', 'K${totalBalance.toStringAsFixed(2)}',
                    Colors.blue),
              ],
            ),
            const SizedBox(height: 20),

            // Dropdown for Overview Type
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

            // Pie Chart
            Expanded(
              child: _overviewType.contains('Expense')
                  ? _buildPieChart(_expenseData, 'Expense')
                  : _buildPieChart(_incomeData, 'Income'),
            ),

            // Category Labels
            const SizedBox(height: 20),
            _buildCategoryLabels(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEntryPage()),
          ).then((value) {
            _calculateOverviewData(); // Recalculate after adding new entries
          });
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> data, String type) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No $type Data Available',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: PieChart(
            dataMap: data,
            animationDuration: const Duration(milliseconds: 800),
            chartType: ChartType.ring,
            colorList: type == 'Expense'
                ? [Colors.red, Colors.yellow, Colors.purple, Colors.orange]
                : [Colors.green, Colors.orange, Colors.blue, Colors.cyan],
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
            legendOptions: const LegendOptions(
              showLegends: false,
            ),
          ),
        ),
        Text(
          type,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryLabels() {
    // Determine data based on the selected overview type
    final data = _overviewType.contains('Expense') ? _expenseData : _incomeData;

    // Generate a list of category labels with corresponding colors
    final categoryWidgets = data.entries.map((entry) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getCategoryColor(entry.key),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            entry.key,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      );
    }).toList();

    // Wrap the category widgets in a Wrap layout for responsiveness
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: categoryWidgets,
    );
  }

  // Get a color for the category based on its position in the data map
  Color _getCategoryColor(String category) {
    final data = _overviewType.contains('Expense') ? _expenseData : _incomeData;
    final index = data.keys.toList().indexOf(category);

    // Assign colors from the same list used for the pie chart
    final colorList = _overviewType.contains('Expense')
        ? [Colors.red, Colors.yellow, Colors.purple, Colors.orange]
        : [Colors.green, Colors.orange, Colors.blue, Colors.cyan];

    // Cycle through colors if there are more categories than colors
    return colorList[index % colorList.length];
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
}
