import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_entry_page.dart';
import 'account_model.dart';
import 'add_account_dialog.dart';
import 'account_details_page.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accountModel = Provider.of<AccountModel>(context);
    final accounts = accountModel.accounts;

    final totalBalance = accounts.fold(
      0.0,
      (sum, account) => sum + (account['balance'] ?? 0.0),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'All Accounts MK$totalBalance',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
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
                  final account = accounts[index];
                  return _buildAccountTileWithActions(
                    context,
                    accountModel,
                    account,
                    index,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddAccountDialog(context, accountModel);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: const Color.fromARGB(255, 255, 253, 253),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 29.0, vertical: 15.0),
                    minimumSize: const Size(180, 60),
                    side: const BorderSide(color: Colors.white),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEntryPage()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }

  Widget _buildAccountTileWithActions(
    BuildContext context,
    AccountModel accountModel,
    Map<String, dynamic> account,
    int index,
  ) {
    final isIgnored = account['ignored'] ?? false;
    return Opacity(
      opacity: isIgnored ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: ListTile(
          leading: const Icon(Icons.account_balance_wallet, size: 40),
          title: Text(
            account['type'] ?? 'Unknown Account',
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
            onSelected: (value) {
              switch (value) {
                case 'Edit':
                  _showEditAccountDialog(context, accountModel, index);
                  break;
                case 'Delete':
                  accountModel.deleteAccount(index);
                  break;
                case 'Ignore':
                  accountModel.toggleIgnore(index);
                  break;
                case 'Restore':
                  accountModel.toggleIgnore(index);
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
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
                  accountName: account['type'],
                  balance: account['balance'].toString(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context, AccountModel accountModel) {
    showDialog(
      context: context,
      builder: (context) => AddAccountDialog(
        onSave: (type, balance, icon) {
          accountModel.addAccount(type, double.tryParse(balance) ?? 0.0);
        },
      ),
    );
  }

  void _showEditAccountDialog(
    BuildContext context,
    AccountModel accountModel,
    int index,
  ) {
    final account = accountModel.accounts[index];
    showDialog(
      context: context,
      builder: (context) => AddAccountDialog(
        account: account,
        onSave: (type, balance, icon) {
          accountModel.updateAccount(
              index, type, double.tryParse(balance) ?? 0.0);
        },
      ),
    );
  }
}
