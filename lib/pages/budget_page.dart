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
  String _selectedMonth = 'November 2024';

  double get _totalBudget {
    final categoryModel = Provider.of<CategoryModel>(context, listen: false);
    return categoryModel.budgetedCategories.fold(
      0.0,
      (sum, item) => sum + (item['amount'] ?? 0.0),
    );
  }

  double get _totalSpent {
    final categoryModel = Provider.of<CategoryModel>(context, listen: false);
    return categoryModel.budgetedCategories.fold(
      0.0,
      (sum, item) => sum + (item['spent'] ?? 0.0),
    );
  }

  void _updateSpentAmount(String category, double spentAmount) {
    final categoryModel = Provider.of<CategoryModel>(context, listen: false);
    categoryModel.updateSpentAmount(category, spentAmount);
  }

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
                final categoryModel =
                    Provider.of<CategoryModel>(context, listen: false);
                if (isNew) {
                  categoryModel.addBudgetedCategory({
                    'icon': item['icon'],
                    'label': item['name'],
                    'amount': double.parse(amountController.text),
                    'spent': 0.0,
                  });
                } else {
                  categoryModel.updateBudgetLimit(
                    item['label'],
                    double.parse(amountController.text),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

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
                final categoryModel =
                    Provider.of<CategoryModel>(context, listen: false);
                categoryModel.removeBudgetedCategory(item['label']);
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
    final budgetedItems = categoryModel.budgetedCategories;
    final notBudgetedItems = categoryModel.expenseCategories
        .where((category) =>
            !budgetedItems.any((item) => item['label'] == category['name']))
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
                fontSize: 24,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL BUDGET',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
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
              Text(
                'Budgeted items:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              budgetedItems.isEmpty
                  ? const Center(
                      child: Text(
                        'Currently, no budget is applied for this month. Set budget-limits for this month.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Column(
                      children: budgetedItems.map((item) {
                        double remaining =
                            (item['amount'] ?? 0.0) - (item['spent'] ?? 0.0);
                        return ListTile(
                          leading:
                              Icon(item['icon'] ?? Icons.category, size: 40),
                          title: Text(item['label'] ?? 'Unnamed',
                              style: const TextStyle(fontSize: 16)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Limit: MK${item['amount']}'),
                              Text('Spent: MK${item['spent']}'),
                              Text('Remaining: MK$remaining'),
                              LinearProgressIndicator(
                                value: item['spent'] /
                                    (item['amount'] as double? ?? 1),
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
                                  value: 'remove',
                                  child: Text('Remove Budget')),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 30),
              const Text(
                'Not budgeted items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              notBudgetedItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No category found. Add categories in order to apply budget.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Column(
                      children: notBudgetedItems.map((item) {
                        return ListTile(
                          leading:
                              Icon(item['icon'] ?? Icons.category, size: 40),
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
            MaterialPageRoute(
              builder: (context) => AddEntryPage(
                onExpenseAdded: _updateSpentAmount,
              ),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }
}
