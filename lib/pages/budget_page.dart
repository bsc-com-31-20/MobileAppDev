import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_model.dart';
import 'add_entry_page.dart'; // Added import for AddEntryPage

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  String _selectedMonth = 'September 2024';
  List<Map<String, dynamic>> _budgetedItems = [];

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
          title: const Text("Add Budget"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryNameController,
                decoration: const InputDecoration(labelText: "Category Name"),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: "Set Amount"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
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
              child: const Text("Add"),
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
        title: const Text('Budget Page'),
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
              const Text('Budgeted items:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Column(
                children: _budgetedItems.map((item) {
                  double remaining =
                      (item['amount'] ?? 0.0) - (item['spent'] ?? 0.0);
                  return ListTile(
                    leading: const Icon(Icons.category, size: 40),
                    title: Text(item['category_name'] ?? '',
                        style: const TextStyle(fontSize: 16)),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('MK${item['budget']}',
                          style: const TextStyle(fontSize: 16)),
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
