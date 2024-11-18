import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_model.dart';
import 'add_entry_page.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int _selectedIndex = 2;
  String _selectedMonth = 'September 2024';

  final List<Map<String, dynamic>> _budgetedItems = [
    {
      'icon': Icons.fastfood,
      'label': 'Food',
      'amount': 200000.0,
      'spent': 50000.0
    },
    {
      'icon': Icons.directions_bus,
      'label': 'Transportation',
      'amount': 100000.0,
      'spent': 25000.0
    },
    {
      'icon': Icons.shopping_bag,
      'label': 'Clothing',
      'amount': 150000.0,
      'spent': 75000.0
    },
  ];

  double get _totalBudget =>
      _budgetedItems.fold(0.0, (sum, item) => sum + (item['amount'] ?? 0.0));
  double get _totalSpent =>
      _budgetedItems.fold(0.0, (sum, item) => sum + (item['spent'] ?? 0.0));

  void _changeMonth(bool isNext) {
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

    final currentMonth = _selectedMonth.split(' ')[0];
    final currentYear = int.parse(_selectedMonth.split(' ')[1]);
    int currentIndex = months.indexOf(currentMonth);

    if (isNext) {
      if (currentIndex == 11) {
        currentIndex = 0;
        _selectedMonth = '${months[currentIndex]} ${currentYear + 1}';
      } else {
        _selectedMonth = '${months[currentIndex + 1]} $currentYear';
      }
    } else {
      if (currentIndex == 0) {
        currentIndex = 11;
        _selectedMonth = '${months[currentIndex]} ${currentYear - 1}';
      } else {
        _selectedMonth = '${months[currentIndex - 1]} $currentYear';
      }
    }

    setState(() {});
  }

  // Show dialog to set or change budget
  void _showBudgetDialog(Map<String, dynamic> item, {bool isNew = false}) {
    TextEditingController amountController = TextEditingController(
      text: isNew ? '' : item['amount'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isNew ? 'Set Budget' : 'Change Budget Limit'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter amount'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (isNew) {
                    _budgetedItems.add({
                      'icon': item['icon'],
                      'label': item['name'],
                      'amount': double.parse(amountController.text),
                      'spent': 0.0,
                    });
                  } else {
                    item['amount'] = double.parse(amountController.text);
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog to remove budget
  void _showRemoveConfirmationDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Budget'),
          content: Text(
              'Are you sure you want to remove the budget for "${item['label']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _budgetedItems.remove(item);
                });
                Navigator.pop(context);
              },
              child: const Text('REMOVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryModel = Provider.of<CategoryModel>(context);
    final notBudgetedItems = categoryModel.expenseCategories
        .where((category) =>
            !_budgetedItems.any((item) => item['label'] == category['name']))
        .toList();

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
              onPressed: () => _changeMonth(false),
            ),
            Text(
              _selectedMonth,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right, color: Colors.white),
              onPressed: () => _changeMonth(true),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Budget and Total Spent
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL BUDGET',
                        style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'MK${_totalBudget.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'TOTAL SPENT',
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'MK${_totalSpent.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Budgeted items
              Text(
                'Budgeted items:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: _budgetedItems.map((item) {
                  double remaining =
                      (item['amount'] ?? 0.0) - (item['spent'] ?? 0.0);
                  return ListTile(
                    leading: Icon(item['icon'] ?? Icons.category, size: 40),
                    title: Text(item['label'] ?? 'Unnamed',
                        style: const TextStyle(fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Limit: MK${item['amount']}'),
                        Text('Spent: MK${item['spent']}'),
                        Text('Remaining: MK$remaining'),
                        LinearProgressIndicator(
                          value:
                              item['spent'] / (item['amount'] as double? ?? 1),
                          color: Colors.red,
                          backgroundColor: Colors.grey[200],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz),
                      onSelected: (value) {
                        if (value == 'change') {
                          _showBudgetDialog(item);
                        } else if (value == 'remove') {
                          _showRemoveConfirmationDialog(item);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: 'change', child: Text('Change Limit')),
                        const PopupMenuItem(
                            value: 'remove', child: Text('Remove Budget')),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              // Not Budgeted Items
              const Text(
                'Not budgeted items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: notBudgetedItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'] ?? Icons.category, size: 40),
                    title: Text(item['name'] ?? 'Unnamed',
                        style: const TextStyle(fontSize: 16)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                      ),
                      onPressed: () {
                        _showBudgetDialog(item, isNew: true);
                      },
                      child: const Text(
                        'SET BUDGET',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEntryPage()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }
}
