import 'package:flutter/material.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int _selectedIndex = 2;
  String _selectedMonth = 'September 2024';

  final List<Map<String, dynamic>> _budgetedItems = [
    {'icon': Icons.fastfood, 'label': 'Food', 'amount': 'MK200,000'},
    {'icon': Icons.directions_bus, 'label': 'Transportation', 'amount': 'MK100,000'},
    {'icon': Icons.shopping_bag, 'label': 'Clothing', 'amount': 'MK150,000'},
    {'icon': Icons.fastfood, 'label': 'Bossmnan', 'amount': 'MK20,000'},
    {'icon': Icons.directions_bus, 'label': 'School trip', 'amount': 'MK10,000'},
    {'icon': Icons.shopping_bag, 'label': 'Dapp', 'amount': 'MK150,000'},
  ];

  final List<Map<String, dynamic>> _notBudgetedItems = [
    {'icon': Icons.computer, 'label': 'Electronics'},
    {'icon': Icons.favorite, 'label': 'Healthy'},
    {'icon': Icons.phone_android, 'label': 'Bundles'},
    {'icon': Icons.computer, 'label': 'Tech'},
    {'icon': Icons.favorite, 'label': 'Panado'},
    {'icon': Icons.phone_android, 'label': 'Voice bundles'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'StudentBudget',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          )
        ],
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
                  Text('Selected month:', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: _selectedMonth,
                    items: <String>['September 2024', 'October 2024', 'November 2024']
                        .map<DropdownMenuItem<String>>((String value) {
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Budget:', style: TextStyle(fontSize: 16)),
                      Text('MK450,000', style: TextStyle(fontSize: 18, color: Colors.green)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Expenditure:', style: TextStyle(fontSize: 16)),
                      Text('MK50,000', style: TextStyle(fontSize: 18, color: Colors.red)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text('Budgeted items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Column(
                children: _budgetedItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], size: 40),
                    title: Text(item['label'], style: TextStyle(fontSize: 16)),
                    trailing: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(item['amount'], style: TextStyle(fontSize: 16)),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Text('Not budgeted items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Column(
                children: _notBudgetedItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], size: 40),
                    title: Text(item['label'], style: TextStyle(fontSize: 16)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black),
                      ),
                      onPressed: () {},
                      child: Text('SET BUDGET', style: TextStyle(color: Colors.black)),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, size: 30, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Remove Ads - MK3,500', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}
