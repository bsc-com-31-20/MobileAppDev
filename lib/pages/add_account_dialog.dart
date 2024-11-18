import 'package:flutter/material.dart';

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
      text: widget.account != null ? widget.account!['type'] : '',
    );
    _amountController = TextEditingController(
      text: widget.account != null ? widget.account!['balance'].toString() : '',
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
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Account Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Initial Balance'),
            ),
            const SizedBox(height: 20),
            const Text('Choose an Icon'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
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
          child: const Text('Cancel'),
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
          child: const Text('Save'),
        ),
      ],
    );
  }
}
