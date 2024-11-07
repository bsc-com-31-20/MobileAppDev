import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_model.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  double get _totalBudget =>
      _budgetedItems.fold(0.0, (sum, item) => sum + (item['amount'] ?? 0.0));
  double get _totalSpent =>
      _budgetedItems.fold(0.0, (sum, item) => sum + (item['spent'] ?? 0.0));

  void _showBudgetDialog(Map<String, dynamic> item, {bool isEdit = false}) {
    TextEditingController _limitController = TextEditingController(
      text: isEdit ? (item['amount']?.toString() ?? '0') : '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isEdit ? 'Edit Budget' : 'Set Budget',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item['icon'] ?? Icons.category, size: 40),
                  const SizedBox(width: 10),
                  Text(item['label'] ?? item['name'] ?? 'Unnamed',
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Limit:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              TextField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
              ),
              const SizedBox(height: 20),
              Text('Month: $_selectedMonth',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_limitController.text.isNotEmpty) {
                  setState(() {
                    double limit =
                        double.tryParse(_limitController.text) ?? 0.0;

                    if (isEdit) {
                      item['amount'] = limit; // Update amount if editing
                    } else {
                      _budgetedItems.add({
                        'icon': item['icon'] ?? Icons.category,
                        'label': item['label'] ?? item['name'] ?? 'Unnamed',
                        'amount': limit,
                        'spent': 0.0,
                        'monthYear': _selectedMonth,
                      });
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(isEdit ? 'SAVE' : 'SET'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveConfirmationDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Remove this budget?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Budget over this category will be removed for this month. Are you sure?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NO'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _budgetedItems.remove(item);
                });
                Navigator.pop(context);
              },
              child: const Text('YES'),
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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              '${_selectedMonth.split(" ")[0]}, ${_selectedMonth.split(" ")[1]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL BUDGET',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  'TOTAL SPENT',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MK${_totalBudget.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'MK${_totalSpent.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Selected month:', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: _selectedMonth,
                    items: <String>[
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
                      if (mounted) {
                        setState(() {
                          _selectedMonth = newValue!;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Display budgeted items with month
              Text(
                'Budgeted items: ${_selectedMonth.split(" ")[0].substring(0, 3)}, ${_selectedMonth.split(" ")[1]}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          _showBudgetDialog(item, isEdit: true);
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

              // Display not budgeted items
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
                      onPressed: () => _showBudgetDialog(item),
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
    );
  }
}
