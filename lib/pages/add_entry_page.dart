import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the default back arrow
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close,
                  color: Colors.teal), // Cross icon for "CANCEL"
              label: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.teal),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Handle save action
              },
              icon: const Icon(Icons.check,
                  color: Colors.teal), // Checkmark icon for "SAVE"
              label: const Text('SAVE', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Toggle Buttons for Income/Expense
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
                _buildButtonWithIcon(Icons.account_balance_wallet, 'Account'),
                _buildButtonWithIcon(Icons.category, 'Category'),
              ],
            ),
            const SizedBox(height: 20),

            // Amount Display with Clear Button
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

            // Calculator Keypad
            Expanded(
              child: _buildCalculator(),
            ),

            // Date and Time
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(DateTime.now()),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    DateFormat('hh:mm a').format(DateTime.now()),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWithIcon(IconData icon, String label) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.teal),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        // Handle button tap
      },
    );
  }

  // Calculator layout
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
        return _buildCalculatorButton(label);
      },
    );
  }

  Widget _buildCalculatorButton(String label) {
    return InkWell(
      onTap: () {
        setState(() {
          if (label == '=') {
            // Handle calculation (optional: use a package for expression parsing)
          } else if (label == '÷' ||
              label == '×' ||
              label == '-' ||
              label == '+') {
            // Handle operators
          } else {
            // Append number to amount
            amount = (amount == '0') ? label : amount + label;
          }
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              color:
                  (label == '+' || label == '-' || label == '×' || label == '÷')
                      ? Colors.teal
                      : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
