import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Financial Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AccountsPage(),
    );
  }
}

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<Map<String, dynamic>> accounts = [
    {'name': 'Airtel Money', 'balance': 450000, 'ignored': false},
    {'name': 'TNM Mpamba', 'balance': 0, 'ignored': false},
    {'name': 'National Bank', 'balance': 0, 'ignored': false},
    {'name': 'Hard Cash', 'balance': 40000, 'ignored': false},
  ];

  double totalBalance = 0;
  double expenseSoFar = 50000;
  double incomeSoFar = 150000;

  @override
  void initState() {
    super.initState();
    _calculateTotalBalance();
  }

  void _calculateTotalBalance() {
    totalBalance = accounts.fold(
      0.0,
      (sum, account) =>
          sum + (account['ignored'] == false ? account['balance'] : 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              '[All Accounts MK$totalBalance]',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  return _buildAccountTileWithActions(accounts[index], index);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddAccountDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    minimumSize:
                        const Size(180, 60), // Adjust the size as needed
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTileWithActions(Map<String, dynamic> account, int index) {
    bool isIgnored = account['ignored'];
    return Opacity(
      opacity: isIgnored ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: ListTile(
          leading: const Icon(Icons.account_balance_wallet, size: 40),
          title: Text(
            account['name'],
            style: TextStyle(
              fontSize: 18,
              decoration: isIgnored ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            'Balance: MK${account['balance']}',
            style: const TextStyle(fontSize: 14),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Edit':
                  _showEditAccountDialog(context, index);
                  break;
                case 'Delete':
                  _showDeleteConfirmationDialog(
                      context, account['name'], index);
                  break;
                case 'Ignore':
                  _showIgnoreConfirmationDialog(context, index);
                  break;
                case 'Restore':
                  setState(() {
                    accounts[index]['ignored'] = false;
                    _calculateTotalBalance();
                  });
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'Delete',
                child: Text('Delete'),
              ),
              PopupMenuItem<String>(
                value: isIgnored ? 'Restore' : 'Ignore',
                child: Text(isIgnored ? 'Restore' : 'Ignore'),
              ),
            ],
            icon: const Icon(Icons.more_horiz),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountDetailsPage(
                  accountName: account['name'],
                  balance: account['balance'].toString(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAccountDialog(
          onSave: (String name, String balance, IconData icon) {
            setState(() {
              double parsedBalance = double.tryParse(balance) ?? 0.0;
              accounts.add({
                'name': name,
                'balance': parsedBalance,
                'ignored': false,
              });
              _calculateTotalBalance();
            });
          },
        );
      },
    );
  }

  void _showEditAccountDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAccountDialog(
          account: accounts[index],
          onSave: (String name, String balance, IconData icon) {
            setState(() {
              double parsedBalance = double.tryParse(balance) ?? 0.0;
              accounts[index]['name'] = name;
              accounts[index]['balance'] = parsedBalance;
              _calculateTotalBalance();
            });
          },
        );
      },
    );
  }

  void _showIgnoreConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ignore this account?'),
          content: const Text(
              'Unless used, this account will not appear anywhere else. You can restore it at any time.\nAre you sure?'),
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
                  accounts[index]['ignored'] = true;
                  _calculateTotalBalance();
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('YES'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String accountName, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this account?'),
          content: const Text(
              'Deleting this account will also delete all records with this account. Are you sure?'),
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
                  accounts.removeAt(index);
                  _calculateTotalBalance();
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('YES'),
            ),
          ],
        );
      },
    );
  }
}

class AddAccountDialog extends StatefulWidget {
  final Map<String, dynamic>? account;
  final Function(String, String, IconData) onSave;

  const AddAccountDialog({this.account, required this.onSave, super.key});

  @override
  _AddAccountDialogState createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  int? _selectedIconIndex;

  final List<IconData> _iconOptions = [
    Icons.account_balance_wallet,
    Icons.credit_card,
    Icons.money,
    Icons.attach_money,
    Icons.savings,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.account != null ? widget.account!['name'] : '',
    );
    _amountController = TextEditingController(
      text:
          widget.account != null ? widget.account!['balance'].toString() : '0',
    );
    _selectedIconIndex = 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.account != null ? 'Edit Account' : 'Add New Account'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    'Initial Amount:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    'Name:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose an Icon',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_iconOptions.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIconIndex = index;
                    });
                  },
                  child: Icon(
                    _iconOptions[index],
                    size: 40,
                    color:
                        _selectedIconIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          ),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              _nameController.text,
              _amountController.text,
              _iconOptions[_selectedIconIndex!],
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          ),
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}

// Account Details Page with Cross (X) button on the left
class AccountDetailsPage extends StatelessWidget {
  final String accountName;
  final String balance;

  const AccountDetailsPage({
    required this.accountName,
    required this.balance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes default back arrow
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: const Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              accountName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Account balance: $balance',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
