import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'account_model.dart';
import 'category_model.dart';

class AddEntryPage extends StatefulWidget {
  final Function(String category, double amount)? onExpenseAdded;

  const AddEntryPage({super.key, this.onExpenseAdded});

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  bool isIncome = false;
  String selectedAccount = 'Account';
  String selectedCategory = 'Category';
  String amount = '0';

  @override
  Widget build(BuildContext context) {
    final accountModel = Provider.of<AccountModel>(context);
    final categoryModel = Provider.of<CategoryModel>(context);

    final incomeCategories = categoryModel.incomeCategories;
    final expenseCategories = categoryModel.expenseCategories;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, color: Colors.teal),
              label: const Text('CANCEL', style: TextStyle(color: Colors.teal)),
            ),
            TextButton.icon(
              onPressed: _saveEntry,
              icon: const Icon(Icons.check, color: Colors.teal),
              label: const Text('SAVE', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isIncome = true;
                    });
                  },
                  child: Text(
                    'INCOME',
                    style: TextStyle(
                      color: isIncome ? Colors.teal : Colors.grey,
                      fontWeight:
                          isIncome ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                const Text('|', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isIncome = false;
                    });
                  },
                  child: Text(
                    'EXPENSE',
                    style: TextStyle(
                      color: !isIncome ? Colors.teal : Colors.grey,
                      fontWeight:
                          !isIncome ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Account and Category Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButtonWithIcon(
                  Icons.account_balance_wallet,
                  selectedAccount,
                  () => _showAccountSelector(context, accountModel.accounts),
                ),
                _buildButtonWithIcon(
                  Icons.category,
                  selectedCategory,
                  () => _showCategorySelector(
                    context,
                    isIncome ? incomeCategories : expenseCategories,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Amount Display
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(fontSize: 36),
                  ),
                  IconButton(
                    icon: const Icon(Icons.backspace_outlined,
                        color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        if (amount.isNotEmpty) {
                          amount = amount.length > 1
                              ? amount.substring(0, amount.length - 1)
                              : '0';
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: _buildCalculator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWithIcon(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.teal),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
    );
  }

  Widget _buildCalculator() {
    const buttonLabels = [
      '+',
      '7',
      '8',
      '9',
      '-',
      '4',
      '5',
      '6',
      '×',
      '1',
      '2',
      '3',
      '÷',
      '0',
      '.',
      '='
    ];
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
      ),
      itemCount: buttonLabels.length,
      itemBuilder: (context, index) {
        final label = buttonLabels[index];
        return InkWell(
          onTap: () {
            setState(() {
              if (label == '=') {
                // Calculation logic
              } else if (['+', '-', '×', '÷'].contains(label)) {
                // Operator logic
              } else {
                amount = (amount == '0') ? label : amount + label;
              }
            });
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 24,
                  color: ['+', '-', '×', '÷'].contains(label)
                      ? Colors.teal
                      : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAccountSelector(
      BuildContext context, List<Map<String, dynamic>> accounts) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: const Text('Select an Account'),
            ),
            ...accounts.map((account) {
              return ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text(account['type']),
                subtitle: Text('Balance: ${account['balance']}'),
                onTap: () {
                  setState(() {
                    selectedAccount = account['type'];
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  void _showCategorySelector(
      BuildContext context, List<Map<String, dynamic>> categories) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(8),
          children: categories.map((category) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = category['name'];
                });
                Navigator.pop(context);
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category['icon'], size: 40, color: Colors.teal),
                    const SizedBox(height: 8),
                    Text(category['name']),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _saveEntry() {
    final accountModel = Provider.of<AccountModel>(context, listen: false);
    final account = accountModel.getAccountByName(selectedAccount);
    final double enteredAmount = double.tryParse(amount) ?? 0;

    if (selectedCategory == 'Category' || selectedAccount == 'Account') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a valid category and account.')),
      );
      return;
    }

    if (account != null && enteredAmount > 0) {
      if (isIncome) {
        account['balance'] += enteredAmount;
        accountModel.addIncome(selectedCategory, enteredAmount);
      } else {
        account['balance'] -= enteredAmount;
        accountModel.addExpense(selectedCategory, enteredAmount);

        // Notify BudgetPage about the expense
        if (widget.onExpenseAdded != null) {
          widget.onExpenseAdded!(selectedCategory, enteredAmount);
        }
      }

      accountModel.notifyListeners();
      setState(() {
        amount = '0';
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${isIncome ? "Income" : "Expense"} saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid entry. Please check again.')),
      );
    }
  }
}
