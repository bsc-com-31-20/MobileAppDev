import 'package:flutter/foundation.dart';

class AccountModel with ChangeNotifier {
  final List<Map<String, dynamic>> _accounts = [];
  final List<Map<String, dynamic>> _incomeEntries = [];
  final List<Map<String, dynamic>> _expenseEntries = [];

  List<Map<String, dynamic>> get accounts => List.unmodifiable(_accounts);
  List<Map<String, dynamic>> get incomeEntries =>
      List.unmodifiable(_incomeEntries);
  List<Map<String, dynamic>> get expenseEntries =>
      List.unmodifiable(_expenseEntries);

  void addAccount(String type, double balance) {
    _accounts.add({
      'type': type,
      'balance': balance,
      'ignored': false,
    });
    notifyListeners();
  }

  void updateAccount(int index, String type, double balance) {
    if (index >= 0 && index < _accounts.length) {
      _accounts[index]['type'] = type;
      _accounts[index]['balance'] = balance;
      notifyListeners();
    }
  }

  void deleteAccount(int index) {
    if (index >= 0 && index < _accounts.length) {
      _accounts.removeAt(index);
      notifyListeners();
    }
  }

  void toggleIgnore(int index) {
    if (index >= 0 && index < _accounts.length) {
      _accounts[index]['ignored'] = !_accounts[index]['ignored'];
      notifyListeners();
    }
  }

  // Method to get account by name
  Map<String, dynamic>? getAccountByName(String accountName) {
    return _accounts.firstWhere(
      (account) => account['type'] == accountName,
      orElse: () => {}, // Return an empty map if no account is found
    ) as Map<String, dynamic>?; // Cast to the expected type
  }

  // Method to add income entry
  void addIncome(String category, double amount) {
    _incomeEntries.add({'category': category, 'amount': amount});
    notifyListeners();
  }

  // Method to add expense entry
  void addExpense(String category, double amount) {
    _expenseEntries.add({'category': category, 'amount': amount});
    notifyListeners();
  }

  // Method to get all income entries
  List<Map<String, dynamic>> getIncomes() {
    return _incomeEntries;
  }

  // Method to get all expense entries
  List<Map<String, dynamic>> getExpenses() {
    return _expenseEntries;
  }
}
