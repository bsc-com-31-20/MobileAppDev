import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  String _selectedMonth = 'September 2024';
  List<Map<String, dynamic>> _budgetedItems = [];

  @override
  void initState() {
    super.initState();
    _fetchBudgets();  // Fetch budgeted items on page load
  }

  // Fetch budgeted items from Supabase
  Future<void> _fetchBudgets() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final response = await Supabase.instance.client
          .from('categories')
          .select('category_name, budget')
          .eq('user_id', user.id)
          .execute();

      if (response.status == 200 && response.data != null) {
        setState(() {
          _budgetedItems = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        print('Error fetching budgets: ${response.status}');
      }
    }
  }

  // Show add budget dialog
  void _showAddBudgetDialog(BuildContext context) {
    final TextEditingController _categoryNameController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Budget"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _categoryNameController,
                decoration: const InputDecoration(labelText: "Category Name"),
              ),
              TextField(
                controller: _amountController,
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
                String categoryName = _categoryNameController.text.trim();
                double? budgetAmount = double.tryParse(_amountController.text.trim());

                if (categoryName.isNotEmpty && budgetAmount != null) {
                  // Save to database
                  _addBudgetToDatabase(categoryName, budgetAmount);
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

  // Add budget to Supabase database
  Future<void> _addBudgetToDatabase(String categoryName, double budgetAmount) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final response = await Supabase.instance.client
          .from('categories')
          .insert({
            'category_name': categoryName,
            'budget': budgetAmount,
          })
          .execute();

      if (response.status == 201) {
        _fetchBudgets(); // Refresh the budgeted items list after adding a new entry
      } else {
        print('Error adding budget: ${response.status}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      setState(() {
                        _selectedMonth = newValue!;
                      });
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddBudgetDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('ADD NEW BUDGET'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(180, 60), // Adjust the size as needed
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}