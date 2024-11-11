import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  bool isIncome = true;
  String selectedAccount = 'Airtel Money';
  String selectedCategory = 'Food';
  String amount = '';

  final List<String> accounts = ['Airtel Money', 'Bank Transfer', 'Cash'];
  final List<String> categories = ['Food', 'Transport', 'Entertainment', 'Utilities'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Entry',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.cancel, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black),
            onPressed: () {
              // Handle save action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isIncome ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isIncome = true;
                    });
                  },
                  child: const Text('Income'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isIncome ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isIncome = false;
                    });
                  },
                  child: const Text('Expenses'),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Account and Category selection
            DropdownButton<String>(
              value: selectedAccount,
              items: accounts.map((String account) {
                return DropdownMenuItem<String>(
                  value: account,
                  child: Text(account),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedAccount = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: isIncome ? null : (String? newValue) { // Disable if income
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Text input for amount
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
              controller: TextEditingController(text: amount),
              readOnly: true,
            ),
            const SizedBox(height: 20),

            // Calculator/Amount Input
            _buildCalculator(),
            const SizedBox(height: 20),

            // Date and Time Display
            Text(
              DateFormat('MMM dd, yyyy').format(DateTime.now()),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat('hh:mm a').format(DateTime.now()),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Remove Ads
            const Text(
              'Remove Ads - MK3,500',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for calculator layout
  Widget _buildCalculator() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: 1.5,
      children:
          List.generate(12, (index) {
        String buttonText;
        if (index < 9) {
          buttonText = '${index + 1}';
        } else if (index == 9) {
          buttonText = '0';
        } else if (index == 10) {
          buttonText = '+';
        } else {
          buttonText = 'x'; // Change "-" to "x"
        }

        return InkWell(
          onTap: () {
            setState(() {
              if (buttonText == '+') {
                // Handle addition logic if needed
              } else if (buttonText == 'x') { // Delete last character
                if (amount.isNotEmpty) {
                  amount = amount.substring(0, amount.length - 1);
                }
              } else {
                amount += buttonText; // Append number to the amount
              }
            });
          },
          child:
           Card(
             color:
               index == 10 ? Colors.blueAccent : index == 11 ? Colors.redAccent : null, // Color for operators
             child:
               Center(
                 child:
                   Text(
                     buttonText,
                     style:
                       const TextStyle(fontSize:
                         24),
                   ),
               ),
           ),
        );
      }),
    );
  }
}
