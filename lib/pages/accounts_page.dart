import 'package:flutter/material.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'StudentBudget',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Money Accounts',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Accounts List
            Expanded(
              child: ListView(
                children: [
                  _buildAccountTileWithActions(
                      'Airtel Money', 'MK450,000', context),
                  _buildAccountTileWithActions('TNM Mpamba', 'MK0', context),
                  _buildAccountTileWithActions('National Bank', 'MK0', context),
                  _buildAccountTileWithActions(
                      'Hard Cash', 'MK40,000', context),
                ],
              ),
            ),

            // Add Account Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            // Remove Ads Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.block, color: Colors.red, size: 30),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Remove Ads - MK3,500',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40, color: Colors.black),
      ),
    );
  }

  // Method to build Account tile with PopupMenuButton for Edit/Delete/Ignore actions
  Widget _buildAccountTileWithActions(
      String accountName, String balance, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        leading: const Icon(Icons.account_balance_wallet, size: 40),
        title: Text(accountName, style: const TextStyle(fontSize: 18)),
        subtitle:
            Text('Balance: $balance', style: const TextStyle(fontSize: 14)),
        trailing: PopupMenuButton<String>(
          onSelected: (String value) {
            switch (value) {
              case 'Edit':
                // Handle Edit
                print('Edit selected for $accountName');
                break;
              case 'Delete':
                // Handle Delete
                print('Delete selected for $accountName');
                break;
              case 'Ignore':
                // Handle Ignore
                print('Ignore selected for $accountName');
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
            const PopupMenuItem<String>(
              value: 'Ignore',
              child: Text('Ignore'),
            ),
          ],
          icon: const Icon(Icons.more_vert), // The three dots icon
        ),
        onTap: () {
          // Handle account tap
        },
      ),
    );
  }
}
